/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- K-map simplifier  ---------------------- // 
/////////////////////////////////////////////////////////////////////

module kmap(A,B,C,D,Out);

input A,B,C,D;
output Out;


/* write your code here */
wire nA,nB,nC,nD;
wire w1,w2,w3;

nand n1(nA,A,A);
nand n2(nB,B,B);
nand n3(nC,C,C);
nand n4(nD,D,D);

nand g1(w1,nA,nC);
nand g2(w2,A,C);
nand g3(w3,nB,nD);

nand t(Out,w1,w2,w3);



endmodule