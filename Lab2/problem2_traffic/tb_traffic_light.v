// Testbench for the traffic_light module
`timescale 1ns / 1ps

module tb_traffic_light;

    // Inputs
    reg clk;
    reg rst;
    reg tick;

    // Outputs
    wire ns_g, ns_y, ns_r;
    wire ew_g, ew_y, ew_r;

    // Instantiate the Unit Under Test (UUT)
    traffic_light uut (
        .clk(clk), 
        .rst(rst), 
        .tick(tick), 
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

    // Clock generation (50 MHz equivalent period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period
    end

    // Test sequence
    initial begin
        // Dump waves
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_traffic_light);

        // 1. Initialize and apply reset
        rst = 1;
        tick = 0;
        #50; // Wait a few clock cycles
        
        // 2. De-assert reset and start simulation
        rst = 0;
        #20;
        
        // 3. Generate 1 Hz tick (here simulated every 10 clock cycles for visibility)
        repeat (30) begin
            #190; // Wait for 9 clock cycles
            tick = 1; // Pulse tick for one clock cycle
            #20;
            tick = 0;
        end

        // 4. End simulation
        #100;
        $finish;
    end

endmodule