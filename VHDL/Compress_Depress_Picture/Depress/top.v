
module top(
	input clk,
	input rst,
	//RAM codebook
	input [23:0] RAM_W_Q,
	output reg [23:0] RAM_W_D,
	output reg [19:0] RAM_W_A,
	output reg RAM_W_WE,
	output reg RAM_W_OE,
	//RAM TAG
	input [23:0] RAM_TAG_Q,
	output reg [23:0] RAM_TAG_D,
	output reg [19:0] RAM_TAG_A,
	output reg RAM_TAG_WE,
	output reg RAM_TAG_OE,
	//RAM Result picture
	input [23:0] RAM_PIC_Q,
	output reg [23:0] RAM_PIC_D,
	output reg [19:0] RAM_PIC_A,
	output reg RAM_PIC_WE,
	output reg RAM_PIC_OE,
	//controller
	output reg done
);

always@(*) begin
	RAM_W_D = 24'd0;
end
always@(*) begin
	RAM_W_WE = 1'd0;
end
always@(*) begin
	RAM_TAG_D = 24'd0;
end
always@(*) begin
	RAM_TAG_WE = 1'd0;
end

always@(*) begin
	RAM_PIC_OE = 1'd0;
end

//finit state machine
reg [2:0] ns,cs;// ns:nextstate  cs:currentstate
parameter INIT = 3'd0;//initial
parameter READ_TAG = 3'd1;
parameter COMPUTE = 3'd2;
parameter SAVE = 3'd3;
parameter FINISH = 3'd4;
parameter WAIT1 = 3'd5;
//set currentstate
always@(posedge clk or posedge rst)
begin
	if(rst)
		cs <= INIT ;
	else
		cs <= ns ;
end

//set nextstate from currentstate
always@(*)
begin
	case(cs)
		INIT:          
			ns = READ_TAG;
		READ_TAG:
			ns = COMPUTE;
		COMPUTE:
			ns = WAIT1;
		WAIT1:
			ns = SAVE;
		SAVE:
			if(RAM_TAG_A == 20'd4096)
				ns = FINISH;
			else
				ns = READ_TAG;
		FINISH:
			ns = FINISH;
		default:
			ns = INIT;
	endcase
end

//RAM_TAR_A
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_TAG_A <= 20'd0;//20bits
	end
	else if(ns == COMPUTE)begin
		RAM_TAG_A <= RAM_TAG_A + 20'd1;
	end
end
//RAM_TAG_OE
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_TAG_OE <= 1'd0;
	end
	else if(ns == READ_TAG)begin
		RAM_TAG_OE <= 1'd1;
	end
	else
		RAM_TAG_OE <= 1'd0;
end

//RAM_W_A
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_W_A <= 20'd0;//20bits
	end
	else if(ns == COMPUTE)begin
		RAM_W_A <= RAM_TAG_Q[19:0]; 
	end
end
//RAM_W_OE
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_W_OE <= 1'd0;
	end
	else if(ns == WAIT1)begin
		RAM_W_OE <= 1'd1;
	end
	else
		RAM_W_OE <= 1'd0;
end
//RAM_PIC_A
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_PIC_A <= 20'd0;//20bits
	end
	else if(ns == READ_TAG)
		RAM_PIC_A <= RAM_TAG_A;
end
//RAM_PIC_D
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_PIC_D <= 24'd0;
	end
	else if(ns == SAVE)begin
		RAM_PIC_D <= RAM_W_Q;
	end
end
//RAM_PIC_WE
always@(posedge rst or posedge clk) begin
	if (rst)begin
		RAM_PIC_WE <= 1'b0;
	end
	else if(ns == SAVE)begin
		RAM_PIC_WE <= 1'b1;
	end
	else
		RAM_PIC_WE <= 1'b0;
end
//done
always@(posedge rst or posedge clk) begin
	if (rst)begin
		done <= 1'd0;
	end
	else if(ns == FINISH)begin
		done <= 1'd1;
	end
end
	
endmodule
