module sumador_condicional_prefix (
    input [7:0] A,
    input [7:0] B,
    input isSub,
    output [7:0] S,
    output Cout,
    output V
);
    wire [7:0] B_mux;
    wire cin;

    assign B_mux = isSub ? ~B : B;
    assign cin = isSub;

    prefixAdd u_prefix (
        .a(A),
        .b(B_mux),
        .cin(cin),
        .S(S),
        .Cout(Cout),
        .V(V)
    );
endmodule
