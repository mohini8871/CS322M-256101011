/*==============================================================================================================
 RVX10-P Core — SystemVerilog Source
  File      : RVX10pipeline.sv
  Generated : 25/10/25
  Purpose   : Merged source code of all the provided modules into a single, non-referential file for submission.
              This includes core pipeline logic, ALU, controller, forwarding, hazard, and memory modules.
              The file excludes testbenches and any separate top-level files.
  Stages    : IF → ID → EX → MEM → WB (with forwarding, hazard control, stalls).
==============================================================================================================*/
`timescale 1ns/1ps






module riscv_pipeline (
    input clk,               // Clock input
    input reset,             // Reset input
    input [31:0] instr_in,  // Instruction input (to the IF stage)
    output [31:0] result,   // Final result of computation
    output [31:0] addr      // Address output (for memory access)
);

    // Internal signals for connections between pipeline registers
    wire [31:0] pc_in, pc_out, instr_out;
    wire [31:0] reg_data1, reg_data2, alu_out, mem_out, wb_data;
    wire [31:0] imm_data;
    wire [4:0] reg_dest;
    wire mem_read, mem_write, reg_write, alu_src, branch, jump;
    wire [3:0] alu_control;

    // Pipeline registers between stages
    IF_ID if_id_reg (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .instr_in(instr_in),
        .pc_out(pc_out),
        .instr_out(instr_out)
    );
    
    ID_EX id_ex_reg (
        .clk(clk),
        .reset(reset),
        .reg_data1_in(reg_data1),
        .reg_data2_in(reg_data2),
        .imm_in(imm_data),
        .reg_dest_in(reg_dest),
        .alu_control_in(alu_control),
        .mem_read_in(mem_read),
        .mem_write_in(mem_write),
        .reg_write_in(reg_write),
        .alu_src_in(alu_src),
        .branch_in(branch),
        .jump_in(jump),
        .reg_data1_out(reg_data1),
        .reg_data2_out(reg_data2),
        .imm_out(imm_data),
        .reg_dest_out(reg_dest),
        .alu_control_out(alu_control),
        .mem_read_out(mem_read),
        .mem_write_out(mem_write),
        .reg_write_out(reg_write),
        .alu_src_out(alu_src),
        .branch_out(branch),
        .jump_out(jump)
    );

    EX_MEM ex_mem_reg (
        .clk(clk),
        .reset(reset),
        .alu_out_in(alu_out),
        .mem_out_in(mem_out),
        .reg_dest_in(reg_dest),
        .reg_write_in(reg_write),
        .mem_read_in(mem_read),
        .mem_write_in(mem_write),
        .alu_out_out(alu_out),
        .mem_out_out(mem_out),
        .reg_dest_out(reg_dest),
        .reg_write_out(reg_write),
        .mem_read_out(mem_read),
        .mem_write_out(mem_write)
    );

    MEM_WB mem_wb_reg (
        .clk(clk),
        .reset(reset),
        .mem_out_in(mem_out),
        .alu_out_in(alu_out),
        .reg_dest_in(reg_dest),
        .reg_write_in(reg_write),
        .mem_out_out(mem_out),
        .alu_out_out(alu_out),
        .reg_dest_out(reg_dest),
        .reg_write_out(reg_write)
    );

    // Instantiate the datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out),
        .instr_in(instr_in),
        .instr_out(instr_out),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .alu_out(alu_out),
        .mem_out(mem_out),
        .wb_data(wb_data),
        .addr(addr)
    );

    // Instantiate the controller
    controller ctrl (
        .instr_in(instr_in),
        .alu_control(alu_control),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump)
    );

    // Instantiate the hazard unit
    hazard_unit hazard (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .stall_out(stall),
        .flush_out(flush)
    );

    // Instantiate the forwarding unit
    forwarding_unit forward (
        .mem_write(mem_write),
        .reg_write(reg_write),
        .mem_out(mem_out),
        .alu_out(alu_out),
        .reg_dest(reg_dest)
    );

endmodule
