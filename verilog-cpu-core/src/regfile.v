module regfile(
    input clk,
    input rst,
    input we,
    input [4:0] ra1,
    input [4:0] ra2,
    input [4:0] wa,
    input [7:0] data,
    output [7:0] rd1,
    output [7:0] rd2
);

    reg [7:0] registers [31:0];

    assign rd1 = (ra1 == 5'd0 && !rst) ? 8'd0 : registers[ra1];
    assign rd2 = (ra2 == 5'd0 && !rst) ? 8'd0 : registers[ra2];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i = i + 1) begin
                registers[i] <= 8'd0;
            end
        end else if (we) begin
            if (wa != 5'd0) begin
                registers[wa] <= data;
            end
        end
    end

endmodule
