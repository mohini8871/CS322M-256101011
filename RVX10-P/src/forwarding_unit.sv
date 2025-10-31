// -----------------------------------------------------------------------------
// Forwarding Unit
// Simple forwarding logic for resolving data hazards in pipeline stages.
// -----------------------------------------------------------------------------
module forwarding_unit (
  input  logic        mem_write,
  input  logic        reg_write,
  input  logic [31:0] mem_out,
  input  logic [31:0] alu_out,
  input  logic [4:0]  reg_dest,
  output logic [31:0] forwarding_data
);
  always_comb begin
    forwarding_data = reg_write ? alu_out : mem_out;
  end
endmodule
