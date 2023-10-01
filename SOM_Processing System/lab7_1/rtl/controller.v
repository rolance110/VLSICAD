module controller(
  input                 clk,
  input                 rst,
  input   [1:0]         mode,
  input   [24*64 - 1:0] weight,
  input   [2:0]         winner_VEP_x,
  input   [2:0]         winner_VEP_y,
  //IF original picture
  output  reg               RAM_IF_OE,
  output  wire               RAM_IF_WE,
  output  reg [17:0]        RAM_IF_A,
  output  wire [23:0]        RAM_IF_D,
  //W codebook
  output  wire              RAM_W_OE,
  output  reg              RAM_W_WE,
  output  reg [17:0]        RAM_W_A,
  output  reg [23:0]        RAM_W_D,
  //PIC output picture
  output  wire              RAM_PIC_OE,
  output  reg              RAM_PIC_WE,
  output  reg[17:0]        RAM_PIC_A,
  output  reg [23:0]        RAM_PIC_D,
  
  output  reg               weight_updata,
  output  reg               done
);

reg [5:0] RAM_IF_A_x;
reg [5:0] RAM_IF_A_y;
reg [11:0] after_IF_A;


parameter INIT=3'd0;
parameter IDLE=3'd1;        
parameter UPDATA_CB=3'd2;
parameter WRITE_PIC=3'd3;
parameter OUTPUT_CB=3'd4;
parameter FINISH=3'd5; 

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
			ns = IDLE;
		IDLE:
			ns = UPDATA_CB;
		UPDATA_CB:begin
			if(mode==2'd3 && after_IF_A ==12'd4095)//input picture
				ns = WRITE_PIC;
			else if(mode==2'd2 && after_IF_A ==12'd63)//input picture
				ns = WRITE_PIC;
			else if(mode==2'd1 && after_IF_A ==12'd4032)//input picture
				ns = WRITE_PIC;
			else if(mode==2'd0 && after_IF_A ==12'd0)//input picture
				ns = WRITE_PIC;
			else
				ns = UPDATA_CB;
		end
		WRITE_PIC:begin
			if(mode==2'd3 && RAM_PIC_A==18'd4095)//output picture
				ns = OUTPUT_CB;
			else if(mode==2'd2 && RAM_PIC_A==18'd63)//output picture
				ns = OUTPUT_CB;
			else if(mode==2'd1 && RAM_PIC_A==18'd4032)//output picture
				ns = OUTPUT_CB;
			else if(mode==2'd0 && RAM_PIC_A==18'd0)//output picture
				ns = OUTPUT_CB;
			else
				ns = WRITE_PIC;
		end
		OUTPUT_CB:begin
			if(RAM_W_A==18'd63)//output codebook
				ns = FINISH;
			else
				ns = OUTPUT_CB;
		end
		FINISH:begin
			ns = FINISH;
		end
		default:
			ns = INIT;
	endcase		
end

always@(posedge clk or posedge rst)begin
	if(rst)
		after_IF_A <= 12'd0;
	else if(ns== UPDATA_CB || ns==WRITE_PIC)
		after_IF_A <= RAM_IF_A[11:0];
end

//weight_updata
always@(posedge clk or posedge rst)begin
	if(rst)
		weight_updata <= 1'b0;
	else if(ns == UPDATA_CB)
		weight_updata <= 1'b1;
	else	
		weight_updata <= 1'b0;

end

/*not important=====================================*/
//RAM_IF_WE not use

assign RAM_IF_WE = 1'b0;
assign RAM_IF_D  = 24'd0;
assign RAM_W_OE  = 1'b0;
assign RAM_PIC_OE = 1'b0;
/*
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_IF_WE <= 1'b0;
	else
		RAM_IF_WE <= 1'b0;
end

//RAM_IF_D not use
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_IF_D <= 24'd0;
	else
		RAM_IF_D <= 24'd0;
end
//RAM_W_OE not use
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_W_OE <= 1'b0;
	else 
		RAM_W_OE <= 1'b0;
end
//RAM_PIC_OE not use
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_PIC_OE <= 1'b0;
	else
		RAM_PIC_OE <= 1'b0;
end
/*=========================================*/

//Ram_PIC_D
wire [5:0] position;
assign position = {winner_VEP_y,winner_VEP_x};
always@(posedge clk or posedge rst)begin
	if(rst)
	    RAM_PIC_D <= 24'd0;
	else if(ns == WRITE_PIC)
	    RAM_PIC_D <= weight[(24*position)+:24];
end
	//(10*(i*8+j))+:10
//RAM_PIC_A(0~4095)
always@(posedge clk or posedge rst)begin
	if(rst)
	    RAM_PIC_A <= 18'd262143;//18'd262142
	else if(ns == WRITE_PIC && cs!=UPDATA_CB)
	    RAM_PIC_A <= {6'd0,after_IF_A};
end
//RAM_PIC_WE
always@(posedge clk or posedge rst)begin
	if(rst)
	    RAM_PIC_WE <= 1'd0;
	else if(ns == WRITE_PIC)
	    RAM_PIC_WE <= 1'd1;
	else
	    RAM_PIC_WE <= 1'd0;	
end
//done
always@(posedge clk or posedge rst)begin
	if(rst)
	   done<=1'b0;
	else if(ns == FINISH)
	   done<=1'b1; 
end

//RAM_W_WE
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_W_WE <= 1'd0;
	end
	else if(ns == OUTPUT_CB)begin
		RAM_W_WE <= 1'd1;
	end
	else
		RAM_W_WE <= 1'b0;
end
//RAM_W_A(0~63)
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_W_A <= 18'd262143;
	end
	else if(ns == OUTPUT_CB)begin
		RAM_W_A <= RAM_W_A + 18'd1;
	end
	else
		RAM_W_A <= RAM_W_A;
end
//RAM_W_D
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_W_D <= 24'd0;
	end
	else if(ns == OUTPUT_CB && RAM_W_A==18'd262143)begin
		RAM_W_D <= weight[23:0];
	end
	else if(ns == OUTPUT_CB)begin
		RAM_W_D <= weight[(24*(RAM_W_A+18'd1))+:24];
	end
end

//RAM_IF_OE
always@(posedge clk or posedge rst)begin
	if(rst)begin
		RAM_IF_OE <= 1'b0;
	end
	else begin
		RAM_IF_OE <= 1'b1;
	end
end
//RAM_IF_A
always@(*)begin
	RAM_IF_A = {6'd0,RAM_IF_A_y,RAM_IF_A_x};
end

//{y,x}
always@(posedge rst or posedge clk) begin
	if(rst)begin
		RAM_IF_A_x <= 6'd0;
		RAM_IF_A_y <= 6'd0;
	end
	else if(ns==IDLE)begin	
		case (mode)
			2'd0:begin
				RAM_IF_A_x <= 6'd63;
				RAM_IF_A_y <= 6'd63;
			end
			2'd1:begin
				RAM_IF_A_x <= 6'd63;
				RAM_IF_A_y <= 6'd0;
			end
			2'd2:begin
				RAM_IF_A_x <= 6'd0;
				RAM_IF_A_y <= 6'd63;
			end
			2'd3:begin
				RAM_IF_A_x <= 6'd0;
				RAM_IF_A_y <= 6'd0;
			end  
		endcase
	end
	else if(ns == UPDATA_CB || ns== WRITE_PIC)begin
		case (mode)
			2'd0:begin
				if(RAM_IF_A_x == 6'd0)begin
					RAM_IF_A_x <= 6'd63;
					RAM_IF_A_y <= RAM_IF_A_y - 6'd1;
				end
				else if(ns == WRITE_PIC && after_IF_A ==12'd0)begin
					RAM_IF_A_x <= 6'd63;
					RAM_IF_A_y <= 6'd63;
				end
				else begin
					RAM_IF_A_x <= RAM_IF_A_x - 6'd1;
				end
			end
			2'd1:begin
				if(RAM_IF_A_x == 6'd0)begin
					RAM_IF_A_x <= 6'd63;
					RAM_IF_A_y <= RAM_IF_A_y + 6'd1;
				end
				else if(ns == WRITE_PIC && after_IF_A ==12'd4032)begin
					RAM_IF_A_x <= 6'd63;
					RAM_IF_A_y <= 6'd0;
				end
				else begin
					RAM_IF_A_x <= RAM_IF_A_x - 6'd1;
				end
			end
			2'd2:begin
				if(RAM_IF_A_x == 6'd63)begin
					RAM_IF_A_x <= 6'd0;
					RAM_IF_A_y <= RAM_IF_A_y - 6'd1;
				end
				else if(ns == WRITE_PIC && after_IF_A ==12'd63)begin
					RAM_IF_A_x <= 6'd0;
					RAM_IF_A_y <= 6'd63;
				end
				else begin
					RAM_IF_A_x <= RAM_IF_A_x + 6'd1;
				end
			end
			2'd3:begin
				if(RAM_IF_A_x == 6'd63)begin
					RAM_IF_A_x <= 6'd0;
					RAM_IF_A_y <= RAM_IF_A_y + 6'd1;
				end
				else if(ns == WRITE_PIC && after_IF_A ==12'd4095)begin
					RAM_IF_A_x <= 6'd0;
					RAM_IF_A_y <= 6'd0;
				end
				else begin
					RAM_IF_A_x <= RAM_IF_A_x + 6'd1;
				end
			end
		endcase
	end
end








endmodule
