// -----------------------------------------------------------------------------
// Memory Unit
// Generates address and provides default output until connected to main memory.
// -----------------------------------------------------------------------------
module memory (
  input  logic [31:0] alu_result,
  output logic [31:0] mem_out,
  output logic [31:0] addr
);
  assign addr    = alu_result;
  assign mem_out = 32'd0;
endmodule
