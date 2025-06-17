module processing_tb;

    reg clk = 0;
    reg rst;
    reg [31:0] instruction;

    wire [7:0] tb_alu_result;
    wire tb_zeroflag;
    wire tb_overflow_flag;
    wire tb_cout_flag;
    wire tb_carryflag;
    wire [7:0] tb_reg_rs1_data;
    wire [7:0] tb_reg_rs2_data;

    processing DUT (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .tb_alu_result(tb_alu_result),
        .tb_zeroflag(tb_zeroflag),
        .tb_overflow_flag(tb_overflow_flag),
        .tb_cout_flag(tb_cout_flag),
        .tb_carryflag(tb_carryflag),
        .tb_reg_rs1_data(tb_reg_rs1_data),
        .tb_reg_rs2_data(tb_reg_rs2_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, processing_tb);

        rst = 1;
        instruction = 32'b0;
        #10;
        rst = 0;
        #10;

        // Test Sequence

        // Initialize R1 with 1 (INC R0 -> R1)
        // Opcode: INC (4'b1000)
        // rs1: R0 (5'd0)
        // rs2: R0 (5'd0)
        // rd: R1 (5'd1)
        instruction = {4'b1000, 5'd0, 5'd0, 5'd1, 13'd0};
        #10;
        $display("Time: %0t, Instruction: INC R1, R1_data: %0d, ALU_Result: %0d, ZeroFlag: %0b", $time, tb_reg_rs1_data, tb_alu_result, tb_zeroflag);

        // Initialize R2 with 2 (INC R1 -> R2)
        // rs1: R1 (5'd1)
        // rs2: R0 (5'd0)
        // rd: R2 (5'd2)
        instruction = {4'b1000, 5'd1, 5'd0, 5'd2, 13'd0};
        #10;
        $display("Time: %0t, Instruction: INC R2, R2_data: %0d, ALU_Result: %0d, ZeroFlag: %0b", $time, tb_reg_rs2_data, tb_alu_result, tb_zeroflag);

        //Add R1 and R2, store in R3
        // rs1: R1 (5'd1)
        // rs2: R2 (5'd2)
        // rd: R3 (5'd3)
        instruction = {4'b0000, 5'd1, 5'd2, 5'd3, 13'd0};
        #10;
        $display("Time: %0t, Instruction: ADD R1, R2 -> R3, R1_val: %0d, R2_val: %0d, ALU_Result: %0d, cout: %0b, overflow: %0b, zeroflag: %0b",
                 $time, tb_reg_rs1_data, tb_reg_rs2_data, tb_alu_result, tb_cout_flag, tb_overflow_flag, tb_zeroflag);

        //Subtract R1 from R2, store wd - R2 -> R4)
        //Subtract R1 from R2, store in R4 
        // rs1: R1 (5'd1)
        // rs2: R2 (5'd2)
        // rd: R4 (5'd4)
        instruction = {4'b0001, 5'd1, 5'd2, 5'd4, 13'd0};
        #10;
        $display("Time: %0t, Instruction: SUB R1, R2 -> R4, R1_val: %0d, R2_val: %0d, ALU_Result: %0d, cout: %0b, overflow: %0b, zeroflag: %0b",
                 $time, tb_reg_rs1_data, tb_reg_rs2_data, tb_alu_result, tb_cout_flag, tb_overflow_flag, tb_zeroflag);


        //AND R1 and R2, store in R5
        // rs1: R1 (5'd1)
        // rs2: R2 (5'd2)
        // rd: R5 (5'd5)
        instruction = {4'b0010, 5'd1, 5'd2, 5'd5, 13'd0};
        #10;
        $display("Time: %0t, Instruction: AND R1, R2 -> R5, R1_val: %0d, R2_val: %0d, ALU_Result: %0d, zeroflag: %0b",
                 $time, tb_reg_rs1_data, tb_reg_rs2_data, tb_alu_result, tb_zeroflag);

        //Subtract R1 from R1, store in R6
        // rs1: R1 (5'd1)
        // rs2: R1 (5'd1)
        // rd: R6 (5'd6)
        instruction = {4'b0001, 5'd1, 5'd1, 5'd6, 13'd0};
        #10;
        $display("Time: %0t, Instruction: SUB R1, R1 -> R6, R1_val: %0d, ALU_Result: %0d, zeroflag: %0b",
                 $time, tb_reg_rs1_data, tb_alu_result, tb_zeroflag);


        $finish;
    end

endmodule