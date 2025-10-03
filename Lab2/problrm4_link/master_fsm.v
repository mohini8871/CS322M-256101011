// master_fsm.v (fixed for broad Icarus compatibility)
// Synchronous, active-high reset master for 4-phase req/ack handshake.
// Sends 4 bytes over an 8-bit data bus. Pulses 'done' for 1 cycle after final transfer.
module master_fsm (
    input  wire       clk,
    input  wire       rst,       // synchronous, active-high
    input  wire       ack,       // from slave
    output reg        req,       // to slave
    output reg [7:0]  data,      // to slave
    output reg        done       // 1-cycle pulse when burst completes
);
    // Parameters
    localparam integer N_BYTES = 4;

    // Simple pattern
    reg [7:0] rom [0:N_BYTES-1];
    initial begin
        rom[0] = 8'hA0;
        rom[1] = 8'hA1;
        rom[2] = 8'hA2;
        rom[3] = 8'hA3;
    end

    // Byte index
    reg [2:0] idx;

    // State encoding (avoid typedef enum for Icarus)
    localparam [2:0] S_IDLE     = 3'd0,
                     S_DRIVE    = 3'd1, // drive data + raise req
                     S_WAIT_ACK = 3'd2, // wait until ack==1
                     S_DROP_REQ = 3'd3, // drop req after ack seen
                     S_NEXT     = 3'd4, // advance index / decide next
                     S_DONE     = 3'd5; // pulse done

    reg [2:0] state, nstate;

    // Sequential
    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
            req   <= 1'b0;
            data  <= 8'h00;
            done  <= 1'b0;
            idx   <= 3'd0;
        end else begin
            state <= nstate;
            // defaults that may be overridden in cases below
            done  <= 1'b0;
            case (state)
                S_IDLE: begin
                    idx  <= 3'd0;
                    req  <= 1'b0;
                    data <= 8'h00;
                end
                S_DRIVE: begin
                    data <= rom[idx];
                    req  <= 1'b1;
                end
                S_WAIT_ACK: begin
                    // hold req high, data valid
                    req  <= 1'b1;
                    data <= rom[idx];
                end
                S_DROP_REQ: begin
                    // drop req once ack observed
                    req  <= 1'b0;
                    data <= rom[idx];
                end
                S_NEXT: begin
                    // advance to next byte if any
                    if (idx < (N_BYTES-1)) begin
                        idx <= idx + 3'd1;
                    end
                end
                S_DONE: begin
                    req  <= 1'b0;
                    done <= 1'b1; // pulse for one cycle
                end
                default: ;
            endcase
        end
    end

    // Combinational next-state
    always @* begin
        nstate = state;
        case (state)
            S_IDLE:     nstate = S_DRIVE;
            S_DRIVE:    nstate = S_WAIT_ACK;
            S_WAIT_ACK: nstate = (ack ? S_DROP_REQ : S_WAIT_ACK);
            S_DROP_REQ: nstate = S_NEXT;
            S_NEXT:     nstate = (idx == (N_BYTES-1)) ? S_DONE : S_DRIVE;
            S_DONE:     nstate = S_DONE; // stay done; TB can reset to run again
            default:    nstate = S_IDLE;
        endcase
    end
endmodule
