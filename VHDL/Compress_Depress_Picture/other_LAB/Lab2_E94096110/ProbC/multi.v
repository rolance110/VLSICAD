/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen -------------------- //
// ---------------------- Version : v.2.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- Multiplier        ---------------------- //
/////////////////////////////////////////////////////////////////////

`include "../ProbB/CLA.v"

module multi(A_in, B_in, Result_o);

	input [3:0] A_in;
	input [3:0] B_in;
	output [7:0] Result_o;

	
	
	/* write your code here */
wire [3:0] first1;
wire [3:0] second1,second2,second3;
wire [3:0] third1,third2,third3; 
wire c1,c2;

and r2(first1[0],A_in[1],B_in[0]);
and r3(first1[1],A_in[2],B_in[0]);
and r4(first1[2],A_in[3],B_in[0]);
and r5(first1[3],1'b0,1'b0);

and r6(second1[0],A_in[0],B_in[1]);
and r7(second1[1],A_in[1],B_in[1]);
and r8(second1[2],A_in[2],B_in[1]);
and r9(second1[3],A_in[3],B_in[1]);

and r10(second2[0],A_in[0],B_in[2]);
and r11(second2[1],A_in[1],B_in[2]);
and r12(second2[2],A_in[2],B_in[2]);
and r13(second2[3],A_in[3],B_in[2]);

and r14(second3[0],A_in[0],B_in[3]);
and r15(second3[1],A_in[1],B_in[3]);
and r16(second3[2],A_in[2],B_in[3]);
and r17(second3[3],A_in[3],B_in[3]);

CLA cla1(.A_in(first1),.B_in(second1),.Sum_o(third1),.C_out(c1));
CLA cla2(.A_in({c1,third1[3:1]}),.B_in(second2),.Sum_o(third2),.C_out(c2));
CLA cla3(.A_in({c2,third2[3:1]}),.B_in(second3),.Sum_o(third3),.C_out(c3));


and re0(Result_o[0],A_in[0],B_in[0]); //Result[0]
and re1(Result_o[1],third1[0],1'b1);//Result[1]
and re2(Result_o[2],third2[0],1'b1);//Result[2]
and re3(Result_o[3],third3[0],1'b1);//Result[3]
and re4(Result_o[4],third3[1],1'b1);//Result[4]
and re5(Result_o[5],third3[2],1'b1);//Result[5]
and re6(Result_o[6],third3[3],1'b1);//Result[6]
and re7(Result_o[7],c3,1'b1);//Result[7]


endmodule