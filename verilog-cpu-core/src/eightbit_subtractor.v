module eightbit_subtractor(
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output bal
);
    wire [7:0] bcomp;
    assign bcomp = ~b;

    eightbit_adder SUB (
        .a(a),
        .b(bcomp),
        .cin(1'b1),
        .s(diff),
        .cout(bal),
        .overflow()
    );
endmodule