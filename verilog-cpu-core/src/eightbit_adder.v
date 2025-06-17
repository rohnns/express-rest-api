module eightbit_adder(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] s,
    output cout,
    output overflow
);
    wire c1,c2,c3,c4,c5,c6,c7;

    fulladder FA1 (.a(a[0]), .b(b[0]), .cin(cin),  .s(s[0]), .cout(c1));
    fulladder FA2 (.a(a[1]), .b(b[1]), .cin(c1),   .s(s[1]), .cout(c2));
    fulladder FA3 (.a(a[2]), .b(b[2]), .cin(c2),   .s(s[2]), .cout(c3));
    fulladder FA4 (.a(a[3]), .b(b[3]), .cin(c3),   .s(s[3]), .cout(c4));
    fulladder FA5 (.a(a[4]), .b(b[4]), .cin(c4),   .s(s[4]), .cout(c5));
    fulladder FA6 (.a(a[5]), .b(b[5]), .cin(c5),   .s(s[5]), .cout(c6));
    fulladder FA7 (.a(a[6]), .b(b[6]), .cin(c6),   .s(s[6]), .cout(c7));
    fulladder FA8 (.a(a[7]), .b(b[7]), .cin(c7),   .s(s[7]), .cout(cout));

    assign overflow = cout ^ c7;
  
endmodule
