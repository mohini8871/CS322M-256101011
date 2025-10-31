// RVX10-Pipeline
`timescale 1ns/1ps

module riscv_pipeline (
    input  logic       clk,
    input  logic       reset,
    input  logic [31:0] instr_in,   // external instruction input (can be left unconnected)
    output logic [31:0] result,
    output logic [31:0] addr
);
  // IF stage
  logic [31:0] pcF, instrF;
  assign pcF    = 32'd0;           // placeholder; PC generation not shown
  assign instrF = instr_in;        // feed external instruction stream (or NOPs if unconnected)

  // IF/ID
  logic [31:0] pcD, instrD;
  IF_ID if_id_reg (
    .clk(clk),
    .reset(reset),
    .pc_in(pcF),
    .instr_in(instrF),
    .pc_out(pcD),
    .instr_out(instrD)
  );

  // Datapath ID-side operands and simple pass-throughs
  logic [31:0] reg_data1_d, reg_data2_d;
  logic [31:0] alu_out_d, mem_out_d, wb_data_d, addr_d;
  logic [31:0] pc_passthru, instr_passthru;

  datapath dp (
    .clk(clk),
    .reset(reset),
    .pc_in(pcD),
    .instr_in(instrD),
    .pc_out(pc_passthru),
    .instr_out(instr_passthru),
    .reg_data1(reg_data1_d),
    .reg_data2(reg_data2_d),
    .alu_out(alu_out_d),
    .mem_out(mem_out_d),
    .wb_data(wb_data_d),
    .addr(addr_d)
  );

  // Controller (driven by instrD for decode)
  logic [3:0] alu_control_d;
  logic mem_read_d, mem_write_d, reg_write_d, alu_src_d, branch_d, jump_d;
  controller ctrl (
    .instr_in   (instrD),
    .alu_control(alu_control_d),
    .mem_read   (mem_read_d),
    .mem_write  (mem_write_d),
    .reg_write  (reg_write_d),
    .alu_src    (alu_src_d),
    .branch     (branch_d),
    .jump       (jump_d)
  );

  // ID/EX
  logic [31:0] reg_data1_e, reg_data2_e, imm_e;
  logic [4:0]  rd_e;
  logic [3:0]  alu_control_e;
  logic        mem_read_e, mem_write_e, reg_write_e, alu_src_e, branch_e, jump_e;

  ID_EX id_ex_reg (
    .clk(clk),
    .reset(reset),
    .reg_data1_in (reg_data1_d),
    .reg_data2_in (reg_data2_d),
    .imm_in       (32'd0),
    .reg_dest_in  (5'd0),
    .alu_control_in(alu_control_d),
    .mem_read_in  (mem_read_d),
    .mem_write_in (mem_write_d),
    .reg_write_in (reg_write_d),
    .alu_src_in   (alu_src_d),
    .branch_in    (branch_d),
    .jump_in      (jump_d),
    .reg_data1_out(reg_data1_e),
    .reg_data2_out(reg_data2_e),
    .imm_out      (imm_e),
    .reg_dest_out (rd_e),
    .alu_control_out(alu_control_e),
    .mem_read_out (mem_read_e),
    .mem_write_out(mem_write_e),
    .reg_write_out(reg_write_e),
    .alu_src_out  (alu_src_e),
    .branch_out   (branch_e),
    .jump_out     (jump_e)
  );

  // Execute stage ALU
  logic [31:0] alu_out_e;
  alu alu_i (
    .operand1   (reg_data1_e),
    .operand2   (reg_data2_e),
    .alu_control(alu_control_e),
    .alu_result (alu_out_e)
  );

  // EX/MEM
  logic [31:0] alu_out_m, mem_out_m;
  logic [4:0]  rd_m;
  logic        reg_write_m, mem_read_m, mem_write_m;

  EX_MEM ex_mem_reg (
    .clk(clk),
    .reset(reset),
    .alu_out_in   (alu_out_e),
    .mem_out_in   (32'd0),
    .reg_dest_in  (rd_e),
    .reg_write_in (reg_write_e),
    .mem_read_in  (mem_read_e),
    .mem_write_in (mem_write_e),
    .alu_out_out  (alu_out_m),
    .mem_out_out  (mem_out_m),
    .reg_dest_out (rd_m),
    .reg_write_out(reg_write_m),
    .mem_read_out (mem_read_m),
    .mem_write_out(mem_write_m)
  );

  // Memory adapter (observability only)
  memory mem_adapt (
    .alu_result(alu_out_m),
    .mem_out   (/* unused */),
    .addr      (addr)
  );

  // MEM/WB
  logic [31:0] mem_out_w, alu_out_w;
  logic [4:0]  rd_w;
  logic        reg_write_w;

  MEM_WB mem_wb_reg (
    .clk(clk),
    .reset(reset),
    .mem_out_in  (mem_out_m),
    .alu_out_in  (alu_out_m),
    .reg_dest_in (rd_m),
    .reg_write_in(reg_write_m),
    .mem_out_out (mem_out_w),
    .alu_out_out (alu_out_w),
    .reg_dest_out(rd_w),
    .reg_write_out(reg_write_w)
  );

  // Forwarding (minimal)
  logic [31:0] fwd_data;
  forwarding_unit fwd (
    .mem_write   (mem_write_m),
    .reg_write   (reg_write_m),
    .mem_out     (mem_out_m),
    .alu_out     (alu_out_m),
    .reg_dest    (rd_m),
    .forwarding_data(fwd_data)
  );

  // Result selection
  assign result = alu_out_w; // placeholder

endmodule
