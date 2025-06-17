module fulladder(
    input a,
    input b,
    input cin,
    output s,
    output cout
);
    assign s = a ^ b ^ cin;
    assign cout = (b & cin) | (a & (b ^ cin));
endmodule
