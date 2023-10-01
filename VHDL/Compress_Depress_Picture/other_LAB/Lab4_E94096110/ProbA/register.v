module register(
	input clk,
	input rst,
	input reg_write,
	input [5:0] src1_addr,
	input [5:0] src2_addr,
	input [5:0] write_addr,   //0 
	input [31:0] write_data,
	output reg [31:0] src1,
	output reg [31:0] src2
);

reg [31:0] REG_FILE [63:0]; //32 bits 64 reg
integer i,j;

//REG
always@(posedge clk	or posedge rst)begin
	if(rst)begin
		for(i=0;i<64;i=i+1)begin
			REG_FILE[i] <= 32'd0;
		end
	end
	else if(reg_write == 1'd1)begin
		REG_FILE[write_addr] <= write_data ;
	end
	else begin
		for(j=0;j<64;j=j+1)begin
			REG_FILE[j] <= REG_FILE[j];
		end
	end
end
//src1
always@(posedge clk	or posedge rst)begin
	if(rst)begin
		src1 <= 32'd0;
	end
	else if(reg_write == 1'd0)begin
		src1 <= REG_FILE[src1_addr];
	end
	else begin
		src1 <= src1;
	end
end
//src2
always@(posedge clk	or posedge rst)begin
	if(rst)begin
		src2 <= 32'd0;
	end
	else if(reg_write == 1'd0)begin
		src2 <= REG_FILE[src2_addr];
	end
	else begin
		src2 <= src2;
	end
end 

endmodule
