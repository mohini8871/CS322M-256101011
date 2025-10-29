module forwarding_unit (
    input mem_write,
    input reg_write,
    input [31:0] mem_out,
    input [31:0] alu_out,
    output reg [31:0] forwarding_data
);

    always @(*) begin
        if (reg_write) begin
            forwarding_data = alu_out;  // Forward data from EX stage if needed
        end else begin
            forwarding_data = mem_out;  // Forward data from MEM stage if needed
        end
    end

endmodule
