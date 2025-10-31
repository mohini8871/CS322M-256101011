// Register file 
module regfile (
  input  logic        clk,
  input  logic        reset,
  output logic [31:0] reg_data1,
  output logic [31:0] reg_data2
);
  assign reg_data1 = 32'd0;
  assign reg_data2 = 32'd0;
endmodule
