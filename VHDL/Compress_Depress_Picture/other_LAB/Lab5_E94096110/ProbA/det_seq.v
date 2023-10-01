/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- det_1100          ---------------------- // 
/////////////////////////////////////////////////////////////////////
module det_seq(clk, rst, d, q, num);


input clk, rst;
input d;
output reg q;
output reg [2:0] num;


parameter s0=3'd0;
parameter s1=3'd1;
parameter s2=3'd2;
parameter s3=3'd3;
parameter s4=3'd4;
parameter s5=3'd5;

reg [2:0] ns,cs;
always@(posedge clk or posedge rst)begin
	if(rst)
		cs <= s0;
	else
		cs <= ns;
end
always@(cs or d)begin
	case(cs)
		/*
		s0 0xxxx
		s1 1xxxx
		s2 11xxx
		s3 110xx
		s4 1100x
		*/
		s0:	ns=d? s1: s0;//1
		s1:	ns=d? s2: s0;//1
		s2:	ns=d? s2: s3;//0
		s3:	ns=d? s1: s4;//0
		s4:	ns=d? s5: s0;//1
		s5:	ns=d? s2: s0;
		default:
			ns = s0;
	endcase
end

always@(cs)begin
	case(cs)
		s5: q = 1'b1;
		default:
			q = 1'b0;
	endcase
end

always@(posedge clk)
	if(rst)
		num <= 3'd0;
	else if(cs == s5)
		num <= num +3'd1;

endmodule






















