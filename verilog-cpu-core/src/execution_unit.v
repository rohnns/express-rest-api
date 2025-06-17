module execution_unit(
    input [31:0] instruction,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [3:0] opcode
);
    assign opcode = instruction[31:28];
    assign rs1    = instruction[27:23];
    assign rs2    = instruction[22:18];
    assign rd     = instruction[17:13];

endmodule