module tb_pipeline;
    reg clk, reset;
    wire [31:0] result, addr;
    
    // Instantiate the top-level module
    riscv_pipeline uut (
        .clk(clk),
        .reset(reset),
        .result(result),
        .addr(addr)
    );
    
    // Clock generation
    always #5 clk = ~clk;  // 100 MHz clock
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        #10 reset = 0;  // Deassert reset after 10 time units
        
        // Test your processor with instructions here
        // Load instructions into memory
        
        #100;  // Run for a while
        
        // Check results
        
    end
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_pipeline); 
    end

endmodule
