module vending_mealy (
    input clk,
    input reset,        // synchronous, active-high
    input [1:0] coin,   // 01=5, 10=10, 00=idle, 11=ignore
    output reg vend,
    output reg chg5
);

    // State encoding (use parameters instead of typedef/enum)
    parameter S0  = 2'b00,
              S5  = 2'b01,
              S10 = 2'b10,
              S15 = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition (synchronous)
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        vend = 0;
        chg5 = 0;
        case (current_state)
            S0: case (coin)
                    2'b01: next_state = S5;
                    2'b10: next_state = S10;
                    default: next_state = S0;
                endcase
            S5: case (coin)
                    2'b01: next_state = S10;
                    2'b10: next_state = S15;
                    default: next_state = S5;
                endcase
            S10: case (coin)
                    2'b01: next_state = S15;
                    2'b10: begin
                        next_state = S0;
                        vend = 1; // total = 20 → vend
                    end
                    default: next_state = S10;
                endcase
            S15: case (coin)
                    2'b01: begin
                        next_state = S0;
                        vend = 1; // total = 20 → vend
                    end
                    2'b10: begin
                        next_state = S0;
                        vend = 1; // total = 25 → vend + change
                        chg5 = 1;
                    end
                    default: next_state = S15;
                endcase
            default: next_state = S0;
        endcase
    end
endmodule
