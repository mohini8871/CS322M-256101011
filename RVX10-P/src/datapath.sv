// Datapath
module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_in,
    input  logic [31:0] instr_in,
    output logic [31:0] pc_out,
    output logic [31:0] instr_out,
    output logic [31:0] reg_data1,
    output logic [31:0] reg_data2,
    output logic [31:0] alu_out,
    output logic [31:0] mem_out,
    output logic [31:0] wb_data,
    output logic [31:0] addr
);
    assign pc_out   = pc_in;
    assign instr_out = instr_in;

    // Register file (minimal)
    regfile rf (
        .clk(clk),
        .reset(reset),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2)
    );

    // ALU (tie control to ADD for now)
    alu alu_unit (
        .operand1(reg_data1),
        .operand2(reg_data2),
        .alu_control(4'b0000),
        .alu_result(alu_out)
    );

    // Memory adapter
    memory mem_unit (
        .alu_result(alu_out),
        .mem_out(mem_out),
        .addr(addr)
    );

    assign wb_data = mem_out;
endmodule
