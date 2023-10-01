/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- Full Adder        ---------------------- // 
/////////////////////////////////////////////////////////////////////

module FA(a_in, b_in, c_in, sum_o, c_out);

input a_in;
input b_in;
input c_in;
output sum_o;
output c_out;

/* write your code here */
wire w1,w2,w3;

xor s(sum_o,a_in,b_in,c_in);

and g1(w1,a_in,b_in);
and g2(w2,b_in,c_in);
and g3(w3,a_in,c_in);
or co(c_out,w1,w2,w3);

endmodule