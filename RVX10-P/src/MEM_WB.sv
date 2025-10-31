// MEM/WB
module MEM_WB (
  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] mem_out_in,
  input  logic [31:0] alu_out_in,
  input  logic [4:0]  reg_dest_in,
  input  logic        reg_write_in,
  output logic [31:0] mem_out_out,
  output logic [31:0] alu_out_out,
  output logic [4:0]  reg_dest_out,
  output logic        reg_write_out
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      mem_out_out   <= 32'd0;
      alu_out_out   <= 32'd0;
      reg_dest_out  <= 5'd0;
      reg_write_out <= 1'b0;
    end else begin
      mem_out_out   <= mem_out_in;
      alu_out_out   <= alu_out_in;
      reg_dest_out  <= reg_dest_in;
      reg_write_out <= reg_write_in;
    end
  end
endmodule
