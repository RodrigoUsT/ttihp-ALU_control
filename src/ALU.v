module ALU (
    input [7:0] A,
    input [7:0] B,
    input [1:0] shiftdesp,
    input [2:0] ALUControl,
    output reg [7:0] Result,
    output Zero,
    output Negative,
    output Carry,
    output Overflow
);
    wire [7:0] res_sum, res_shl, res_shr, res_and, res_or;
    wire c_out, ovf;
    wire isSub;

    assign isSub = (ALUControl == 3'b001);

    sumador_condicional_prefix u_sum (
        .A(A),
        .B(B),
        .isSub(isSub),
        .S(res_sum),
        .Cout(c_out),
        .V(ovf)
    );

    shift_left u_shl (.A(A), .desp(shiftdesp), .Result(res_shl));
    shift_right u_shr (.A(A), .desp(shiftdesp), .Result(res_shr));

    assign res_and = A & B;
    assign res_or = A | B;

    always @(*) begin
        case (ALUControl)
            3'b000: Result = res_sum;
            3'b001: Result = res_sum;
            3'b010: Result = res_and;
            3'b011: Result = res_or;
            3'b100: Result = res_shl;
            3'b101: Result = res_shr;
            default: Result = 8'b0;
        endcase
    end

    assign Zero = (Result == 8'b0);
    assign Negative = Result[7];
    assign Carry = (ALUControl == 3'b000 || ALUControl == 3'b001) ? c_out : 1'b0;
    assign Overflow = (ALUControl == 3'b000 || ALUControl == 3'b001) ? ovf : 1'b0;
endmodule

