// ALU
module alu (
  input  logic [31:0] operand1,
  input  logic [31:0] operand2,
  input  logic [3:0]  alu_control,
  output logic [31:0] alu_result
);
  logic [4:0] shamt = operand2[4:0];
  always_comb begin
    case (alu_control)
      4'b0000: alu_result = operand1 + operand2;
      4'b0001: alu_result = operand1 - operand2;
      4'b0010: alu_result = operand1 & operand2;
      4'b0011: alu_result = operand1 | operand2;
      4'b0100: alu_result = operand1 ^ operand2;
      4'b0101: alu_result = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;
      4'b0110: alu_result = (operand1 < operand2) ? 32'd1 : 32'd0;
      4'b0111: alu_result = operand1 << shamt;
      4'b1000: alu_result = operand1 >> shamt;
      4'b1001: alu_result = $signed(operand1) >>> shamt;
      default: alu_result = operand1 + operand2;
    endcase
  end
endmodule
