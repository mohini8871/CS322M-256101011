//sequence dectector using Mealy FSM fo
//posedege clk, active high reset
module seq_detect_mealy(
  input  wire clk,
  input  wire rst,
  input  wire din,
  output wire y
);
  // state encoding
  parameter S0   = 2'b00;
  parameter S1   = 2'b01;
  parameter S11  = 2'b10;
parameter S110 = 2'b11;
  reg [1:0] s, ns; // current state, next state


  // Mealy output: only when in S110 and din==1 (completes 1101)
  assign y = (s==S110) && din;

  always @ (posedge clk) begin
    if (rst) s <= S0;
    else     s <= ns;
  end

  always @* begin
    ns = s;
    case (s)
      S0:    ns = din ? S1   : S0;     // 
      S1:    ns = din ? S11  : S0;     // 
      S11:   ns = din ? S11  : S110;   // "110" if 0; if 1 stay in "11" (overlap)
      S110:  ns = din ? S1   : S0;     // 
      default: ns = S0;
    endcase
  end
endmodule
