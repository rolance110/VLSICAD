module top(
	input clk,
	input rst,
	input set_reg,
	input color_val,
	input data_val,
	input [23:0] color,
	input [23:0] data,
	output reg [9:0] d,
	output reg [2:0] index
);

reg [2:0] d_min_index;
reg [9:0] d_min;

reg [23:0] register [7:0];


integer i;

reg [2:0] cnt_c;
reg [2:0] cnt;

reg data_val_flag;

reg [7:0] blue_d;
reg [7:0] green_d;
reg [7:0] red_d;
reg [7:0] blue_d_next;
reg [7:0] green_d_next;
reg [7:0] red_d_next;

reg [9:0] sum;
reg [9:0] sum_next;

reg [23:0] data_s;
//d_min : data vs register[cnt]
always@(posedge clk or posedge rst)begin
	if(rst)
		data_s <= 24'd0;
	else if(data_val)
		data_s <= data;
end
//distance
always@(*)begin
	if(data_s[23:16] < register[cnt_c][23:16])
		blue_d = register[cnt_c][23:16] - data_s[23:16];
	else
		blue_d = data_s[23:16] - register[cnt_c][23:16];
end
always@(*)begin
	if(data_s[15:8] < register[cnt_c][15:8])
		green_d = register[cnt_c][15:8] - data_s[15:8];
	else
		green_d = data_s[15:8] - register[cnt_c][15:8];
end
always@(*)begin
	if(data_s[7:0] < register[cnt_c][7:0])
		red_d = register[cnt_c][7:0] - data_s[7:0];
	else
		red_d = data_s[7:0] - register[cnt_c][7:0];
end
//next_distance
always@(*)begin
	if(data_s[23:16] < register[cnt_c+1][23:16] && cnt_c < 3'd7)
		blue_d_next = register[cnt_c+1][23:16] - data_s[23:16];
	else if(cnt_c < 3'd7)
		blue_d_next = data_s[23:16] - register[cnt_c+1][23:16];
	else 
		blue_d_next = 8'd0;
end
always@(*)begin
	if(data_s[15:8] < register[cnt_c+1][15:8] && cnt_c < 3'd7)
		green_d_next = register[cnt_c+1][15:8] - data_s[15:8];
	else if(cnt_c < 3'd7)
		green_d_next = data_s[15:8] - register[cnt_c+1][15:8];
	else 
		green_d_next = 8'd0;
end
always@(*)begin
	if(data_s[7:0] < register[cnt_c+1][7:0] && cnt_c < 3'd7)
		red_d_next = register[cnt_c+1][7:0] - data_s[7:0];
	else if(cnt_c < 3'd7)
		red_d_next = data_s[7:0] - register[cnt_c+1][7:0];
	else 
		red_d_next = 8'd0;
end
always@(*) begin
	sum = blue_d + green_d + red_d;
end
always@(*) begin
	sum_next = blue_d_next + green_d_next + red_d_next;
end


always@(posedge clk or posedge rst)begin
	if(rst)begin
		d <= 10'd0;
		index <= 3'd0;
	end
	else if(cnt_c == 3'd0 && (sum_next>sum))begin
		d <= sum;
		index <= 3'd0;
	end
	else if(cnt_c == 3'd0)begin
		d <= sum_next;
		index <= 3'd1;
	end
	else if(sum_next < d)begin
		d <= sum_next;
		index <= index + 3'd1;
	end
end
//data_val_flag
always@(posedge clk or posedge rst)begin
	if(rst)
		data_val_flag <= 1'd0;
	else if(cnt_c == 3'd7)
		data_val_flag <= 1'd0;
	else if(data_val)
		data_val_flag <= 1'd1;
end
always@(posedge clk or posedge rst)begin
	if(rst)
		cnt_c <= 3'd0;
	else if(data_val_flag)
		cnt_c <= cnt_c + 3'd1;
	else 
		cnt_c <= 3'd0;
end

//cnt
always@(posedge clk or posedge rst)begin
	if(rst)
		cnt <= 3'd0;
	else if(set_reg & color_val)
		cnt <= cnt + 3'd1;
end
//initial regiser
always@(posedge clk or posedge rst)begin
	if(rst) begin
		for(i=0;i<8;i=i+1)
			register[i][23:0] <= 24'd0;
	end
	else if(set_reg & color_val)begin
		register[cnt][23:0] <= color;
	end
end

endmodule
