module hazard_unit (
    input clk,
    input reset,
    input mem_read,
    input mem_write,
    input alu_src,
    input branch,
    input jump,
    output reg stall_out,
    output reg flush_out
);

    // Hazard detection logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stall_out <= 0;
            flush_out <= 0;
        end else begin
            // Detect load-use hazard
            if (mem_read && !mem_write) begin
                stall_out <= 1;
                flush_out <= 1;
            end else begin
                stall_out <= 0;
                flush_out <= 0;
            end
        end
    end

endmodule
