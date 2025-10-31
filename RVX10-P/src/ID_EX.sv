// ID/EX
module ID_EX (
  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] reg_data1_in,
  input  logic [31:0] reg_data2_in,
  input  logic [31:0] imm_in,
  input  logic [4:0]  reg_dest_in,
  input  logic [3:0]  alu_control_in,
  input  logic        mem_read_in,
  input  logic        mem_write_in,
  input  logic        reg_write_in,
  input  logic        alu_src_in,
  input  logic        branch_in,
  input  logic        jump_in,
  output logic [31:0] reg_data1_out,
  output logic [31:0] reg_data2_out,
  output logic [31:0] imm_out,
  output logic [4:0]  reg_dest_out,
  output logic [3:0]  alu_control_out,
  output logic        mem_read_out,
  output logic        mem_write_out,
  output logic        reg_write_out,
  output logic        alu_src_out,
  output logic        branch_out,
  output logic        jump_out
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      reg_data1_out  <= 32'd0;
      reg_data2_out  <= 32'd0;
      imm_out        <= 32'd0;
      reg_dest_out   <= 5'd0;
      alu_control_out<= 4'd0;
      mem_read_out   <= 1'b0;
      mem_write_out  <= 1'b0;
      reg_write_out  <= 1'b0;
      alu_src_out    <= 1'b0;
      branch_out     <= 1'b0;
      jump_out       <= 1'b0;
    end else begin
      reg_data1_out  <= reg_data1_in;
      reg_data2_out  <= reg_data2_in;
      imm_out        <= imm_in;
      reg_dest_out   <= reg_dest_in;
      alu_control_out<= alu_control_in;
      mem_read_out   <= mem_read_in;
      mem_write_out  <= mem_write_in;
      reg_write_out  <= reg_write_in;
      alu_src_out    <= alu_src_in;
      branch_out     <= branch_in;
      jump_out       <= jump_in;
    end
  end
endmodule
