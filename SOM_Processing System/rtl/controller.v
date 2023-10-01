module controller(
  input                 clk,
  input                 rst,
  input   [1:0]         mode,
  input   [24*64 - 1:0] weight,
  input   [2:0]         winner_VEP_x,
  input   [2:0]         winner_VEP_y,
  //IF original picture
  output  reg              RAM_IF_OE,
  output  reg               RAM_IF_WE,
  output  reg [17:0]        RAM_IF_A,
  output  reg [23:0]        RAM_IF_D,
  //W codebook
  output  reg              RAM_W_OE,
  output  reg              RAM_W_WE,
  output  reg [17:0]        RAM_W_A,
  output  reg [23:0]        RAM_W_D,
  //PIC output picture
  output  reg              RAM_PIC_OE,
  output  reg              RAM_PIC_WE,
  output  reg[17:0]        RAM_PIC_A,
  output  reg [23:0]        RAM_PIC_D,
  
  output reg init_flag,
  output reg rst_flag,
  output  reg               weight_updata,
  output  reg               done
);
reg [7:0] cnt_init;
reg [5:0] RAM_IF_A_x;
reg [5:0] RAM_IF_A_y;
reg [11:0] after_IF_A;


parameter INIT=4'd0;
parameter IDLE=4'd7;        
parameter FIND_WIN1=4'd1;
parameter UPDATA_CB=4'd2;
parameter FIND_WIN2=4'd3;
parameter WRITE_PIC=4'd4;
parameter OUTPUT_CB=4'd5;
parameter FINISH=4'd6;
parameter RST=4'd8; 

reg [3:0] ns,cs;
always@(posedge clk or posedge rst)begin
	if(rst)
		cs <= INIT;
	else
		cs <= ns;
end
always@(*)begin
	case(cs)
		INIT:
			ns = RST;
		RST:
			ns = IDLE;
		IDLE:
			if(cnt_init==8'd192)
				ns = FIND_WIN1;
			else
				ns = IDLE;
		FIND_WIN1:begin
			ns = UPDATA_CB;	
		end
		UPDATA_CB:begin
			if(mode==2'd3 && after_IF_A ==12'd4095)//input picture
				ns = FIND_WIN2;
			else if(mode==2'd2 && after_IF_A ==12'd63)//input picture
				ns = FIND_WIN2;
			else if(mode==2'd1 && after_IF_A ==12'd4032)//input picture
				ns = FIND_WIN2;
			else if(mode==2'd0 && after_IF_A ==12'd0)//input picture
				ns = FIND_WIN2;
			else
				ns = FIND_WIN1;
		end
		FIND_WIN2:begin
			ns = WRITE_PIC;	
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
				ns = FIND_WIN2;
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
always@(posedge rst or posedge clk) begin
	if (rst)begin
		rst_flag <= 1'b0;
	end
	else if(cs==INIT)begin
		rst_flag <= 1'b1;
	end
	else
		rst_flag <= 1'b0;
end
//cnt_init
always@(posedge clk or posedge rst)begin
	if(rst)
		cnt_init <= 8'd0;
	else if(ns == IDLE)
		cnt_init <= cnt_init + 8'd1;
	else
		cnt_init <= 8'd0;
end
//init_flag
always@(posedge rst or posedge clk) begin
	if (rst)begin
		init_flag <= 1'b0;
	end
	else if(ns==IDLE)begin
		init_flag <= 1'b1;
	end
	else
		init_flag <= 1'b0;
end


always@(posedge clk or posedge rst)begin
	if(rst)
		after_IF_A <= 12'd0;
	else if(ns== FIND_WIN1 || ns==FIND_WIN2)
		after_IF_A <= RAM_IF_A[11:0];
end

//weight_updata
always@(posedge clk or posedge rst)begin
	if(rst)
		weight_updata <= 1'b0;
	else if(ns == FIND_WIN1)
		weight_updata <= 1'b1;
	else
		weight_updata <= 1'b0;
end

/*not important=====================================*/
//RAM_IF_WE not use
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_IF_WE <= 1'b0;
end
//RAM_IF_D not use
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_IF_D <= 24'd0;
end
//RAM_W_OE not use
always@(posedge clk or posedge rst) begin
	if(rst)
		RAM_W_OE <= 1'b0;
end
//RAM_PIC_OE not use
always@(posedge clk or posedge rst) begin
	if(rst)
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
	    RAM_PIC_A <= 18'd262142;//18'd262142
	else if(ns == WRITE_PIC)
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
	else if(ns == FIND_WIN1 || ns== FIND_WIN2)begin
		RAM_IF_OE <= 1'b1;
	end
	else
		RAM_IF_OE <= 1'b0;
end
//RAM_IF_A
always @(*) begin
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
	else if(ns == FIND_WIN1 || ns== FIND_WIN2)begin
		case (mode)
			2'd0:begin
				if(RAM_IF_A_x == 6'd0)begin
					RAM_IF_A_x <= 6'd63;
					RAM_IF_A_y <= RAM_IF_A_y - 6'd1;
				end
				else if(ns == FIND_WIN2 && after_IF_A ==12'd0)begin
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
				else if(ns == FIND_WIN2 && after_IF_A ==12'd4032)begin
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
				else if(ns == FIND_WIN2 && after_IF_A ==12'd63)begin
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
				else if(ns == FIND_WIN2 && after_IF_A ==12'd4095)begin
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
