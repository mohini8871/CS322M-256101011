// EX/MEM
module EX_MEM (
  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] alu_out_in,
  input  logic [31:0] mem_out_in,
  input  logic [4:0]  reg_dest_in,
  input  logic        reg_write_in,
  input  logic        mem_read_in,
  input  logic        mem_write_in,
  output logic [31:0] alu_out_out,
  output logic [31:0] mem_out_out,
  output logic [4:0]  reg_dest_out,
  output logic        reg_write_out,
  output logic        mem_read_out,
  output logic        mem_write_out
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      alu_out_out   <= 32'd0;
      mem_out_out   <= 32'd0;
      reg_dest_out  <= 5'd0;
      reg_write_out <= 1'b0;
      mem_read_out  <= 1'b0;
      mem_write_out <= 1'b0;
    end else begin
      alu_out_out   <= alu_out_in;
      mem_out_out   <= mem_out_in;
      reg_dest_out  <= reg_dest_in;
      reg_write_out <= reg_write_in;
      mem_read_out  <= mem_read_in;
      mem_write_out <= mem_write_in;
    end
  end
endmodule
