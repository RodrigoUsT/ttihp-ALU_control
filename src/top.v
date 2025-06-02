module top (
    input clk,
    input [15:0] sw,
    input btnU, btnL, btnR, btnD, btnC,
    output [11:0] led
);
    wire slow_clk;
    wire [2:0] ALUControl;
    
    assign ALUControl = btnU ? 3'b001 :
                        btnD ? 3'b010 :
                        btnL ? 3'b011 :
                        btnR ? 3'b100 :
                        btnC ? 3'b101 :
                        3'b000;

    clk_div clkdiv_inst (
        .clk(clk),
        .slow_clk(slow_clk)
    );

    ALU alu_inst (
        .A(sw[7:0]),
        .B(sw[15:8]),
        .shiftdesp(2'b01),
        .ALUControl(ALUControl),
        .Result(led[7:0]),
        .Zero(led[8]),
        .Negative(led[9]),
        .Carry(led[10]),
        .Overflow(led[11])
    );
endmodule
