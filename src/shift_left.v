module shift_left (
    input [7:0] A,
    input [1:0] desp,
    output [7:0] Result
);
    assign Result = A << desp;
endmodule
