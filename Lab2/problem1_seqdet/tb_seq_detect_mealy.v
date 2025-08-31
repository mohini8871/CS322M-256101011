`timescale 1ns/1ps


module testbench();
    reg clk, rst, in;
    wire out;

    // instantiate the port
    seq_detect_mealy uut(
        .clk(clk),
        .rst(rst),
        .din(in),
        .y(out)
    );
    initial begin
        clk = 1'b0;
        rst = 1'b1;


    end 
    initial forever begin
        #5 clk = ~clk;

    end

    initial begin
        $monitor("%t || in =%b || out = %b || s = %d", $time, in, out, uut.s);
        $dumpfile("tb_seq_detect_mealy.vcd");
        $dumpvars(0, testbench);
    end
    initial begin
        #10 rst = 1'b0; in = 1'b0;
        #10 in = 1'b1;
        #10 in = 0'b0;
        #10 in = 1'b1;
        #10 in = 1'b1;
        #10 in = 0'b0;
        #10 in = 1'b1;
        #10 in = 0'b0;
        #10 in = 1'b1;
        #10 in = 1'b1;
        #10 in = 1'b1;
        #10 in = 0'b0;
        #10 in = 1'b1;
        #10 in = 0'b0;
        #10 in = 0'b0;
        #10 in = 1'b1;
        #10 $finish;

    end

endmodule