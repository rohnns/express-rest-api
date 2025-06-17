module processing(
    input clk,
    input rst,
    input [31:0] instruction,
  output [7:0] tb_alu_result, // to check in tb
    output tb_zeroflag,
    output tb_overflow_flag,
    output tb_cout_flag,
    output tb_carryflag,
    output [7:0] tb_reg_rs1_data,
    output [7:0] tb_reg_rs2_data
);
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [4:0] rd_addr;
    wire [3:0] opcode;

    wire [7:0] rs1_data;
    wire [7:0] rs2_data;

    wire [7:0] alu_result;
    wire alu_cout_flag;
    wire alu_overflow_flag;
    wire alu_zeroflag;
    wire alu_carryflag;

    reg we;

    execution_unit EX (
        .instruction(instruction),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .rd(rd_addr),
        .opcode(opcode)
    );

    regfile RF (
        .clk(clk),
        .rst(rst),
        .we(we),
        .ra1(rs1_addr),
        .ra2(rs2_addr),
        .wa(rd_addr),
        .data(alu_result),
        .rd1(rs1_data),
        .rd2(rs2_data)
    );

    alu_8bit ALU (
        .op_code(opcode),
        .a(rs1_data),
        .b(rs2_data),
        .cin(1'b0),
        .result(alu_result),
        .cout_flag(alu_cout_flag),
        .overflow_flag(alu_overflow_flag),
        .zeroflag(alu_zeroflag),
        .carryflag(alu_carryflag)
    );

    assign tb_alu_result = alu_result;
    assign tb_zeroflag = alu_zeroflag;
    assign tb_overflow_flag = alu_overflow_flag;
    assign tb_cout_flag = alu_cout_flag;
    assign tb_carryflag = alu_carryflag;
    assign tb_reg_rs1_data = rs1_data;
    assign tb_reg_rs2_data = rs2_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            we <= 1'b0;
        end else begin
            we <= 1'b1;
        end
    end

endmodule