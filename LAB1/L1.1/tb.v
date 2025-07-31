// Testbench for 1-bit comparator

module tb;
    reg A, B;
    wire o1, o2, o3;

    L11 uut (
        .A(A),
        .B(B),
        .o1(o1),
        .o2(o2),
        .o3(o3)
    );

    initial begin
        $display("A B | o1(A>B) o2(A=B) o3(A<B)");
        $monitor("%b %b |    %b      %b      %b", A, B, o1, o2, o3);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end
endmodule
