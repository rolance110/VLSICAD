/*
* Hint
sigal explanation:
1.  clk                	: This is a positive edge-triggered clock signal.
2.  rst                	: This is a reset signal.
3.  VEP_x              	: The x-coordinate of this VEP.
4.  VEP_y              	: The y-coordinate of this VEP.
5.  pixel              	: Same as RAM_IF_Q, includes {R, G, B} channels with 8 bits in each channel.
6.  weight_initial    	: The initial codebook value read from RAM_W.
7.  weight_update     	: A write enable signal from the controller that tells the read data(codebook) from RAM_W for which VEP should write.
8.  tag					: output the tag of the codebook(weight) stored in this VEP (tag = {y, x})
9.  manhattan_distance 	: For example, the Manhattan distance between (125, 80, 27) and (110, 70, 34) is |125-110|+|80-70|+|27-34|=32.

*/

module VEP(
  input              clk,
  input              rst,
  input  [      2:0] VEP_x,
  input  [      2:0] VEP_y,
  input  [8*3 - 1:0] pixel,
  input  [8*3 - 1:0] weight_initial,
  input              weight_updata,
  output reg [		5:0] tag,
  output reg [      9:0] manhattan_distance//manhattan distance, add 2 extension bits to prevent overflow
);

reg [7:0] blue_d;
reg [7:0] green_d;
reg [7:0] red_d;
//distance
wire [7:0] b_sub;
assign b_sub = (pixel[23:16] < weight_initial[23:16])? pixel[23:16]: weight_initial[23:16];
wire [7:0] g_sub;
assign g_sub = (pixel[15:8] < weight_initial[15:8])? pixel[15:8]: weight_initial[15:8];
wire [7:0] r_sub;
assign r_sub = (pixel[7:0] < weight_initial[7:0])? pixel[7:0]: weight_initial[7:0];

wire [7:0] b_subed;
assign b_subed = (pixel[23:16] < weight_initial[23:16])? weight_initial[23:16]: pixel[23:16];
wire [7:0] g_subed;
assign g_subed = (pixel[15:8] < weight_initial[15:8])? weight_initial[15:8]: pixel[15:8];
wire [7:0] r_subed;
assign r_subed = (pixel[7:0] < weight_initial[7:0])? weight_initial[7:0]: pixel[7:0];

always@(*)begin
	blue_d = b_subed - b_sub;
end
always@(*)begin
	green_d = g_subed - g_sub;
end
always@(*)begin
	red_d = r_subed - r_sub;
end
always@(posedge clk or posedge rst) begin
	if(rst)
		manhattan_distance <= 10'd0;
	else if(weight_updata)
		manhattan_distance <= blue_d + green_d + red_d;
end

reg [2:0] VEP_x_r;
reg [2:0] VEP_y_r;
reg [2:0] VEP_y_1_r;

always@(*) begin
	VEP_x_r = VEP_x + 3'd1;
end
always@(*) begin
	VEP_y_r = VEP_y;
end
always@(*) begin
	VEP_y_1_r = VEP_y + 3'd1;
end

always@(posedge clk or posedge rst) begin
	if(rst)
		tag <= 6'd0;
	else if(weight_updata && VEP_x==3'd7)
		tag <= {VEP_y_1_r,VEP_x_r};
	else if(weight_updata)
		tag <= {VEP_y_r,VEP_x_r};
end





endmodule
