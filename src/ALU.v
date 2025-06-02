`timescale 1ns / 1ps

module ALU_simple (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [1:0] shiftdesp,
    input  wire [2:0] ALUControl, // 000: suma, 001: resta, 010: AND, 011: OR, 100: <<, 101: >>
    output reg  [7:0] Result,
    output wire       Zero,
    output wire       Negative,
    output reg        Carry,
    output reg        Overflow
);
    wire [7:0] B_inv = ~B;
    wire [7:0] B_mux = (ALUControl == 3'b001) ? B_inv : B;
    wire       cin   = (ALUControl == 3'b001); // 1 para resta
    wire [8:0] sum_result = {1'b0, A} + {1'b0, B_mux} + cin;

    wire [7:0] and_result = A & B;
    wire [7:0] or_result  = A | B;
    wire [7:0] shl_result = A << shiftdesp;
    wire [7:0] shr_result = A >> shiftdesp;

    always @(*) begin
        case (ALUControl)
            3'b000: begin // suma
                Result   = sum_result[7:0];
                Carry    = sum_result[8];
                Overflow = (A[7] == B[7]) && (Result[7] != A[7]);
            end
            3'b001: begin // resta
                Result   = sum_result[7:0];
                Carry    = ~sum_result[8]; // borrow
                Overflow = (A[7] != B[7]) && (Result[7] != A[7]);
            end
            3'b010: begin // AND
                Result   = and_result;
                Carry    = 1'b0;
                Overflow = 1'b0;
            end
            3'b011: begin // OR
                Result   = or_result;
                Carry    = 1'b0;
                Overflow = 1'b0;
            end
            3'b100: begin // shift left
                Result   = shl_result;
                Carry    = A[7 - shiftdesp];
                Overflow = 1'b0;
            end
            3'b101: begin // shift right
                Result   = shr_result;
                Carry    = A[shiftdesp - 1];
                Overflow = 1'b0;
            end
            default: begin
                Result   = 8'b0;
                Carry    = 1'b0;
                Overflow = 1'b0;
            end
        endcase
    end

    assign Zero     = (Result == 8'b0);
    assign Negative = Result[7];

endmodule
