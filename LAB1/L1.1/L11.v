// 1-bit Comparator



module L11 (
    input wire A,
    input wire B,
    output wire o1, // A > B
    output wire o2, // A == B
    output wire o3  // A < B
);

    assign o1 = A & ~B;              // A > B
    assign o2 = (A & B) | (~A & ~B); // A == B
    assign o3 = ~A & B;              // A < B

endmodule