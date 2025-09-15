// Moore FSM for a two-road (NS/EW) traffic light controller.
module traffic_light (
    input  wire clk,
    input  wire rst,          // Synchronous, active-high reset
    input  wire tick,         // 1 Hz tick input
    output reg  ns_g, ns_y, ns_r, // North-South 
    output reg  ew_g, ew_y, ew_r  // East-West 
);

    // State encoding
    parameter NS_GREEN  = 2'b00;
    parameter NS_YELLOW = 2'b01;
    parameter EW_GREEN  = 2'b10;
    parameter EW_YELLOW = 2'b11;

    // State regisers
    reg [1:0] current_state, next_state;

    // Counter tick 
    reg [2:0] tick_counter; // 000(1tick) 001 010 011 100(5ticks)
    // State Register
    always @(posedge clk) begin
        if (rst) begin
            current_state <= NS_GREEN;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic and Counter Block (Combinational)
    always @(*) begin
        next_state = current_state; // Default staysame state
        case (current_state)
            NS_GREEN: begin
                if (tick && (tick_counter == 3'd4)) begin
                    next_state = NS_YELLOW;
                end
            end
            NS_YELLOW: begin
                if (tick && (tick_counter == 3'd1)) begin
                    next_state = EW_GREEN;
                end
            end
            EW_GREEN: begin
                if (tick && (tick_counter == 3'd4)) begin
                    next_state = EW_YELLOW;
                end
            end
            EW_YELLOW: begin
                if (tick && (tick_counter == 3'd1)) begin
                    next_state = NS_GREEN;
                end
            end
            default: next_state = NS_GREEN;
        endcase
    end
    
    // Tick Counter Logic (Sequential)
    always @(posedge clk) begin
        if (rst) begin
            tick_counter <= 3'd0;
        // If state is about to change on the next clock, reset counter
        end else if (next_state != current_state) begin
            tick_counter <= 3'd0;
        // Otherwise, increment on each tick
        end else if (tick) begin
            tick_counter <= tick_counter + 1;
        end
    end

    // Output 
    always @(*) begin
        // Default all lights to off
        {ns_g, ns_y, ns_r} = 3'b001; // Default to RED
        {ew_g, ew_y, ew_r} = 3'b001; // Default to RED
        
        case (current_state)
            NS_GREEN: begin
                ns_g = 1'b1; ns_r = 1'b0;
                ew_r = 1'b1;
            end
            NS_YELLOW: begin
                ns_y = 1'b1; ns_r = 1'b0;
                ew_r = 1'b1;
            end
            EW_GREEN: begin
                ew_g = 1'b1; ew_r = 1'b0;
                ns_r = 1'b1;
            end
            EW_YELLOW: begin
                ew_y = 1'b1; ew_r = 1'b0;
                ns_r = 1'b1;
            end
        endcase
    end

endmodule