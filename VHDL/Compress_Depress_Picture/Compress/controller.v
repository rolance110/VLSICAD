module controller(
  input                 clk,
  input                 rst,
  //input   [1:0]         mode,
  //input   [24*64 - 1:0] weight,
  //input   [2:0]         winner_VEP_x,
  //input   [2:0]         winner_VEP_y,
  output reg               RAM_IF_OE, //F
  output reg               RAM_IF_WE, //always zero F
  output reg [17:0]        RAM_IF_A, //F
  output reg [23:0]        RAM_IF_D, //always zero F
  output reg               RAM_W_OE, //F
  output reg               RAM_W_WE, //always zero F
  output reg [17:0]        RAM_W_A,//F
  output reg [23:0]        RAM_W_D, //always zero  F
  output reg               RAM_TAG_OE,//F
  output reg               RAM_TAG_WE,//F
  output reg [17:0]        RAM_TAG_A,//F

  output reg [63:0]        write_vep,
  output reg               done//F
);

parameter INIT=3'd0;    
parameter SAVE_CODEOOK=3'd1;  
parameter READ_PIXEL=3'd2;  
parameter FIND_MIN=3'd3;
parameter WRITE_TAG=3'd4;
parameter FINISH=3'd5 ; 

reg [2:0] ns,cs;
always@(posedge clk or posedge rst)begin
	if(rst)
		cs <= INIT;
	else
		cs <= ns;
end
always@(*)begin
	case(cs)
		INIT:
			ns = SAVE_CODEOOK;
		SAVE_CODEOOK:begin
			if(RAM_W_A == 18'd64)
				ns = READ_PIXEL;
			else
				ns = SAVE_CODEOOK;
		end
		READ_PIXEL:begin
			ns = FIND_MIN;
		end
		FIND_MIN:begin
			ns = WRITE_TAG;	
		end
		WRITE_TAG:begin
			if(RAM_TAG_A==18'd4095)
				ns = FINISH;
			else
				ns = READ_PIXEL;
		end
		FINISH:begin
			ns = FINISH;
		end
		default:
			ns = INIT;
	endcase		
end
/*not important============================*/
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_IF_WE <= 1'b0;
	else
		RAM_IF_WE <= 1'b0;
end
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_IF_D <= 24'd0;
	else
		RAM_IF_D <= 24'd0;
end
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_W_D <= 24'd0;
	else
		RAM_W_D <= 24'd0;
end
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_W_WE <= 1'b0;
	else
		RAM_W_WE <= 1'b0;
end
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_TAG_OE <= 1'b0;
	else
		RAM_TAG_OE <= 1'b0;
end
/*=========================================*/

//RAM_TAG_A
always@(posedge clk or posedge rst)begin
	if(rst)
	    RAM_TAG_A <= 18'd262143;
	else if(ns == WRITE_TAG)
	    RAM_TAG_A <= RAM_TAG_A + 18'd1;
end
//RAM_TAG_WE
always@(posedge clk or posedge rst)begin
	if(rst)
	    RAM_TAG_WE <= 1'd0;
	else if(ns == WRITE_TAG)
	    RAM_TAG_WE <= 1'd1;
	else
	    RAM_TAG_WE <= 1'd0;	
end
//done
always@(posedge clk or posedge rst)begin
	if(rst)
	   done<=1'b0;
	else if(ns == FINISH)
	   done<=1'b1; 
end

//RAM_W_OE
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_W_OE <= 1'd0;
	end
	else if(ns == SAVE_CODEOOK)begin
		RAM_W_OE <= 1'd1;
	end
	else
		RAM_W_OE <= 1'b0;
end
//RAM_W_A
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_W_A <= 18'd0;
	end
	else if(ns == SAVE_CODEOOK)begin
		RAM_W_A <= RAM_W_A + 18'd1;
	end
	else
		RAM_W_A <= RAM_W_A;
end

//RAM_IF_OE
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_IF_OE <= 1'b0;
	end
	else if(ns == FIND_MIN)begin
		RAM_IF_OE <= 1'b1;
	end
	else
		RAM_IF_OE <= 1'b0;
end
//RAM_IF_A
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_IF_A <= 18'd0;
	end
	else if(ns == FIND_MIN)begin
		RAM_IF_A <= RAM_IF_A + 18'd1;
	end
	else
		RAM_IF_A <= RAM_IF_A;
end




endmodule
