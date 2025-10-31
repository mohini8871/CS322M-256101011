// IF/ID
module IF_ID (
  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] pc_in,
  input  logic [31:0] instr_in,
  output logic [31:0] pc_out,
  output logic [31:0] instr_out
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      pc_out    <= 32'd0;
      instr_out <= 32'h00000013;
    end else begin
      pc_out    <= pc_in;
      instr_out <= instr_in;
    end
  end
endmodule
