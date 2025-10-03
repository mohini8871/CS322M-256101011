// tb_link_top.v
`timescale 1ns/1ps

module tb_link_top;
    reg clk, rst;
    wire done;

    link_top dut (
        .clk (clk),
        .rst (rst),
        .done(done)
    );

    // Clock: 10ns period (100 MHz)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Reset sequence
    initial begin
        rst = 1'b1;
        repeat (4) @(posedge clk);
        rst = 1'b0;
    end

    // VCD dumping
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_link_top);
        // Dump useful internal signals
        $dumpvars(0, dut.u_master);
        $dumpvars(0, dut.u_slave);
    end

    // Monitors (hierarchical refs)
    wire        req   = dut.u_master.req;
    wire        ack   = dut.u_slave.ack;
    wire [7:0]  data  = dut.u_master.data;
    wire [7:0]  lastb = dut.u_slave.last_byte;

    // Simple scoreboard: collect 4 bytes and check values
    reg [7:0] got [0:3];
    integer i;
    initial begin
        for (i=0; i<4; i=i+1) got[i] = 8'h00;
    end

    // Capture on ack rising edge (first cycle of ack high)
    reg ack_d;
    always @(posedge clk) begin
        ack_d <= ack;
        if (!ack_d && ack) begin
            // count which byte this is
            integer idx;
            idx = (got[0]!=8'h00) + (got[1]!=8'h00) + (got[2]!=8'h00) + (got[3]!=8'h00);
            if (idx < 4) got[idx] <= lastb;
            $display("[%0t] ACK rise: data=%02h last_byte=%02h req=%0b", $time, data, lastb, req);
        end
    end

    // Stop when done observed
    always @(posedge clk) begin
        if (done) begin
            $display("[%0t] DONE observed.", $time);
            // Print summary
            $display("Received bytes: %02h %02h %02h %02h", got[0], got[1], got[2], got[3]);
            #20;
            $finish;
        end
    end

endmodule
