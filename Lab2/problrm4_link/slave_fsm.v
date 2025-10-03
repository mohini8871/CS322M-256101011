// slave_fsm.v (fixed for broad Icarus compatibility)
// Latches data on req, asserts ack for 2 cycles minimum, then waits for req to drop before deasserting ack.
module slave_fsm (
    input  wire       clk,
    input  wire       rst,        // synchronous, active-high
    input  wire       req,        // from master
    input  wire [7:0] data_in,    // from master
    output reg        ack,        // to master
    output reg [7:0]  last_byte   // latched byte (observable from TB)
);
    // State encoding
    localparam [1:0] W_WAIT_REQ  = 2'd0,
                     W_ASSERT    = 2'd1, // assert ack and count 2 cycles
                     W_HOLD      = 2'd2, // after 2 cycles, keep ack until req==0
                     W_DROP      = 2'd3; // drop ack (1 cycle), then back to WAIT

    reg [1:0] state, nstate;
    reg [1:0] hold_cnt; // counts 0,1 for 2 cycles

    // Sequential
    always @(posedge clk) begin
        if (rst) begin
            state     <= W_WAIT_REQ;
            ack       <= 1'b0;
            last_byte <= 8'h00;
            hold_cnt  <= 2'd0;
        end else begin
            state <= nstate;

            case (state)
                W_WAIT_REQ: begin
                    ack <= 1'b0;
                    if (req) begin
                        // Latch byte on req (sample when req observed high)
                        last_byte <= data_in;
                        ack       <= 1'b1;
                        hold_cnt  <= 2'd0;
                    end
                end

                W_ASSERT: begin
                    // ack stays high and we count 2 cycles
                    ack <= 1'b1;
                    hold_cnt <= hold_cnt + 2'd1;
                end

                W_HOLD: begin
                    // After 2 cycles, keep ack high until req drops
                    ack <= 1'b1;
                end

                W_DROP: begin
                    // Drop ack for one cycle
                    ack <= 1'b0;
                end
            endcase
        end
    end

    // Next-state logic
    always @* begin
        nstate = state;
        case (state)
            W_WAIT_REQ: begin
                if (req) nstate = W_ASSERT;
            end
            W_ASSERT: begin
                if (hold_cnt == 2'd1) nstate = W_HOLD; // 2 cycles: 0 and 1
                else nstate = W_ASSERT;
            end
            W_HOLD: begin
                if (!req) nstate = W_DROP;
            end
            W_DROP: begin
                nstate = W_WAIT_REQ;
            end
            default: nstate = W_WAIT_REQ;
        endcase
    end
endmodule
