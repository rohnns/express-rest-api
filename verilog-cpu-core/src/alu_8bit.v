module alu_8bit(
    input [3:0] op_code,
    input [7:0] a,
    input [7:0] b,
    input cin,
    output reg [7:0] result,
    output reg cout_flag,
    output reg overflow_flag,
    output reg zeroflag,
    output reg carryflag
);

    wire [7:0] sum, difference, and_op, or_op, xor_op, ls, rs, ars, inc, dec;
    wire [15:0] product_full;
    wire cout_add, of1, bal_sub;

    wire lt_compare;
    wire eq_compare;
    wire even_parity_raw;

    eightbit_adder ADD (
        .a(a),
        .b(b),
        .cin(cin),
        .s(sum),
        .cout(cout_add),
        .overflow(of1)
    );

    eightbit_subtractor SUB (
        .a(a),
        .b(b),
        .diff(difference),
        .bal(bal_sub)
    );

    assign and_op = a & b;
    assign or_op   = a | b;
    assign xor_op = a ^ b;

    assign ls  = a << b;
    assign rs  = a >> b;
    assign ars = $signed(a) >>> b;

    assign product_full = a * b;

    assign inc = a + 8'd1;
    assign dec = a - 8'd1;

    assign lt_compare = a < b;
    assign eq_compare = (a == b);

    assign even_parity_raw = ~^a;

    always @(*) begin
        case (op_code)
            4'b0000: result = sum;
            4'b0001: result = difference;
            4'b0010: result = and_op;
            4'b0011: result = or_op;
            4'b0100: result = xor_op;
            4'b0101: result = ls;
            4'b0110: result = ars;
            4'b0111: result = rs;
            4'b1000: result = inc;
            4'b1001: result = dec;
            4'b1010: result = lt_compare ? 8'd1 : 8'd0;
            4'b1011: result = eq_compare ? 8'd1 : 8'd0;
            4'b1100: result = product_full[7:0];
            4'b1101: result = {7'b0, even_parity_raw};
            default: result = 8'd0;
        endcase
    end

    always @(*) begin
        case (op_code)
            4'b0000: cout_flag = cout_add;
            4'b0001: cout_flag = bal_sub;
            default: cout_flag = 1'b0;
        endcase

        case (op_code)
            4'b0000: overflow_flag = of1;
            4'b0001: overflow_flag = of1;
            default: overflow_flag = 1'b0;
        endcase

        zeroflag = (result == 8'd0) ? 1'b1 : 1'b0;

        carryflag = cout_flag;
    end

endmodule