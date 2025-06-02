`timescale 1ns / 1ps

module tt_um_top (
    input  wire [7:0] ui_in,     // Entradas de usuario
    output wire [7:0] uo_out,    // Salidas de usuario
    input  wire       clk,       // Reloj (100 MHz declarado en info.yaml)
    input  wire       rst_n,     // Reset activo bajo
    input  wire       ena,       // Enable
    output wire [7:0] uio_oe,    // No usado
    input  wire [7:0] uio_in,    // No usado
    output wire [7:0] uio_out    // No usado
);

    wire [7:0] A         = ui_in;
    wire [7:0] B         = 8'h0A;           // Valor fijo para pruebas (puedes cambiarlo)
    wire [1:0] shift_amt = 2'b01;           // Desplazamiento fijo (puedes adaptarlo)
    wire [2:0] ALUCtrl   = ui_in[2:0];      // Control de operación ALU (desde switches inferiores)

    wire [7:0] Result;
    wire       Zero, Negative, Carry, Overflow;

    ALU_simple alu (
        .A(A),
        .B(B),
        .shiftdesp(shift_amt),
        .ALUControl(ALUCtrl),
        .Result(Result),
        .Zero(Zero),
        .Negative(Negative),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    assign uo_out = Result; // Se puede cambiar para mostrar flags en leds altos

    assign uio_oe  = 8'b0;
    assign uio_out = 8'b0;

endmodule
