/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.03    ---------------------- //
// ---------------------- mini_vending      ---------------------- // 
/////////////////////////////////////////////////////////////////////

module mini_vending(clk, rst, en, money, beverage, change, finish);

input             clk, rst;
input             en;
input       [5:0] money, beverage;
output      reg [5:0] change;
output     reg  finish;
  
parameter PHASE0=2'd0;
parameter PHASE1=2'd1;
parameter PHASE2=2'd2;

reg [1:0] ns,cs;
always@(posedge clk or posedge rst)begin
	if(rst)
		cs <= PHASE0;
	else
		cs <= ns;
end
always@(cs or en)begin
	case(cs)
		/*
		PHASE0 wait money
		PHASE1 choose beverage
		PHASE2 get change
		*/
		PHASE0:	ns=en? PHASE1: PHASE0;//1
		PHASE1:	ns=PHASE2;//1
		PHASE2:	ns=PHASE0;//0
		default:
			ns=PHASE0;
	endcase
end
//money_s
reg [5:0] money_s;
always@(posedge clk)begin
	case(cs)
		PHASE0: money_s <= money;
		PHASE1: money_s <= money_s - beverage;
		default:
			money_s <= money_s;
	endcase
end
//change
always@(cs)begin
	case(cs)
		PHASE2:	change = money_s;
		default:
			change = 6'd0;
	endcase
end
//finish
always@(cs)begin
	case(cs)
		PHASE2: finish = 1'b1;
		default:
			finish = 1'b0;
	endcase
end

endmodule
