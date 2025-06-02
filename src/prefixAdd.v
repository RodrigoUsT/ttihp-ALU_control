module and2 (input i0, i1, output o);
 assign o = i0 & i1;
endmodule

module or2 (input i0, i1, output o);
 assign o = i0 | i1;
endmodule

module xor2 (input i0, i1, output o);
 assign o = i0 ^ i1;
endmodule

module xor3 (input i0, i1, i2, output o);
 wire temp;
 xor2 xor2_0 (i0, i1, temp);
 xor2 xor2_1 (i2, temp, o);
endmodule

module prop_gen(input x,y, output p,g);
 or2 o(x,y,p);
 and2 a(x,y,g);
endmodule

module carry(input p1,p0,g1,g0, output p, g);
 wire t;
 and2 a1(p1,p0,p);
 and2 a2(p1,g0,t);
 or2 o2(t,g1,g);
endmodule

module sum(input x, y, g, output s);
 xor3 x3(x,y,g,s);
endmodule

module prefixAdd(input [7:0] a,b, input cin, output [7:0] S, output Cout, output V);
 wire [7:0] p, g, cp, cg;
 wire cp21,cg21,cp43,cg43,cp54,cg54,cp65,cg65,cp64,cg64;

 genvar i;
 generate
     for (i = 0; i < 8; i = i + 1) begin: gen_pg
         prop_gen pgen (a[i], b[i], p[i], g[i]);
     end
 endgenerate

 assign cp[0] = 1'b0;
 assign cg[0] = 1'b0;

 carry c1(p[0],1'b0,g[0],cin,cp[1],cg[1]);
 carry c3_0(p[2],p[1],g[2],g[1],cp21,cg21);
 carry c5_0(p[4],p[3],g[4],g[3],cp43,cg43);
 carry c7_0(p[6],p[5],g[6],g[5],cp65,cg65);

 carry c2(p[1],cp[1],g[1],cg[1],cp[2],cg[2]);
 carry c3_1(cp21,cp[1],cg21,cg[1],cp[3],cg[3]);
 carry c6_0(p[5],cp43,g[5],cg43,cp54,cg54);
 carry c7_1(cp65,cp43,cg65,cg43,cp64,cg64);

 carry c4(p[3],cp[3],g[3],cg[3],cp[4],cg[4]);
 carry c5_1(cp43,cp[3],cg43,cg[3],cp[5],cg[5]);
 carry c6_1(cp54,cp[3],cg54,cg[3],cp[6],cg[6]);
 carry c7_2(cp64,cp[3],cg64,cg[3],cp[7],cg[7]);

 generate
     for (i = 0; i < 8; i = i + 1) begin: gen_sum
         if (i == 0) sum s0 (a[0], b[0], cin, S[0]);
         else        sum sN (a[i], b[i], cg[i], S[i]);
     end
 endgenerate

 assign Cout = g[7] | (p[7] & cg[7]);
 assign V = cg[7] ^ Cout;
endmodule
