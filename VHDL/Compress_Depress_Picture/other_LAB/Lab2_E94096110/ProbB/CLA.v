/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- Carry LookAhead Adder------------------- // 
/////////////////////////////////////////////////////////////////////

`include "../ProbB/FA.v"

module CLA(A_in, B_in, Sum_o, C_out);

	input  [3:0] A_in;
	input  [3:0] B_in;
	output [3:0] Sum_o;
	output       C_out;

	/* write your code here */
wire P0,P1,P2,P3;
wire G0,G1,G2,G3;
or p0(P0,A_in[0],B_in[0]);
and  g0(G0,A_in[0],B_in[0]);
or p1(P1,A_in[1],B_in[1]);
and  g1(G1,A_in[1],B_in[1]);
or p2(P2,A_in[2],B_in[2]);
and  g2(G2,A_in[2],B_in[2]);
or p3(P3,A_in[3],B_in[3]);
and  g3(G3,A_in[3],B_in[3]);

wire C0,C1,C2,C3;
wire r11;
wire r21,r22;
wire r31,r32,r33;
wire r41,r42,r43,r44;

and C(C0,1'b0,1'b0);
   
  
and ga1(r11,C0,P0);//C0
or  ga2(C1,r11,G0);

and ga3(r21,C0,P0,P1);//C0
and ga4(r22,G0,P1);
or  ga5(C2,r21,r22,G1);

and ga6(r31,C0,P0,P1,P2);//C0
and ga7(r32,G0,P1,P2);
and ga8(r33,G1,P2);
or  ga9(C3,r31,r32,r33,G2);

and ga10(r41,G2,P3);
and ga11(r42,G1,P2,P3);
and ga12(r43,G0,P1,P2,P3);
and ga13(r44,C0,P0,P1,P2,P3);
or  ga14(C_out,r41,r42,r43,r44,G3);

wire nc0,nc1,nc2,nc3;//non_meaning
FA FA0(.a_in(A_in[0]),.b_in(B_in[0]),.c_in(C0),.sum_o(Sum_o[0]), .c_out(nc0));
FA FA1(.a_in(A_in[1]),.b_in(B_in[1]),.c_in(C1),.sum_o(Sum_o[1]), .c_out(nc1));
FA FA2(.a_in(A_in[2]),.b_in(B_in[2]),.c_in(C2),.sum_o(Sum_o[2]), .c_out(nc2));
FA FA3(.a_in(A_in[3]),.b_in(B_in[3]),.c_in(C3),.sum_o(Sum_o[3]), .c_out(nc3));




endmodule
