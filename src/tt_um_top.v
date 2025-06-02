module tt_um_top (
    input  wire [7:0] ui,   // ui[3:0] = A[3:0], ui[7:4] = B[3:0]
    output wire [7:0] uo,
    inout  wire [7:0] uio
);
    wire [3:0] A = ui[3:0];
    wire [3:0] B = ui[7:4];

    wire [7:0] Result_full;
    wire       Zero, Negative, Carry, Overflow;

    // ALU instanciada con operación fija: suma (ALUControl = 3'b000)
    ALU alu_inst (
        .A({4'b0000, A}),
        .B({4'b0000, B}),
        .shiftdesp(2'b01),
        .ALUControl(3'b000),
        .Result(Result_full),
        .Zero(Zero),
        .Negative(Negative),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    assign uo[3:0] = Result_full[3:0];
    assign uo[4] = Zero;
    assign uo[5] = Negative;
    assign uo[6] = Carry;
    assign uo[7] = Overflow;

    assign uio = 8'bz;  // Tri-state (no usado)

endmodule
