module tb_vending_mealy;

    reg clk;
    reg reset;
    reg [1:0] coin;
    wire vend, chg5;

    // Instantiate the vending machine module
    vending_mealy uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .vend(vend),
        .chg5(chg5)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1; coin = 2'b00; #10;
        reset = 0;

        // Scenario: 5+10+5 → vend
        coin = 2'b01; #10; // S0 → S5
        coin = 2'b10; #10; // S5 → S15
        coin = 2'b01; #10; // S15 → S0, vend=1
        coin = 2'b00; #10; // idle

        // Scenario: 10+10 → vend
        coin = 2'b10; #10; // S0 → S10
        coin = 2'b10; #10; // S10 → S0, vend=1
        coin = 2'b00; #10;

        // Scenario: 15+10 → vend+change
        coin = 2'b10; #10; // S0 → S10
        coin = 2'b01; #10; // S10 → S15
        coin = 2'b10; #10; // S15 → S0, vend=1, chg5=1
        coin = 2'b00; #10;

        $finish;
    end

    // Monitor for outputs
    initial $monitor("Time=%0t | Coin=%b | Vend=%b | Chg5=%b | State=%b", $time, coin, vend, chg5, uut.current_state);

endmodule
