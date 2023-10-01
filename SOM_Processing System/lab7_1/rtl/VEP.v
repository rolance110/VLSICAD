/*
* Hint
sigal explanation:
1.  clk                : This is a positive edge-triggered clock signal.
2.  rst                : This is a reset signal.
3.  VEP_x              : The x-coordinate of this VEP.
4.  VEP_y              : The y-coordinate of this VEP.
5.  winner_VEP_x       : The VEP_x value with the minimum Manhattan distance.
6.  winner_VEP_y       : The VEP_y value with the minimum Manhattan distance.
7.  pixel              : Same as RAM_IF_Q, includes {R, G, B} channels with 8 bits in each channel.
8.  weight_initial    : The initial value given by LFSR, contained {R, G, B} channels.
9.  weight_update     : An enable signal from the controller that tells the weight in each VEP to be updated.
10. weight            : The value of the VEP's weight register.
11. manhattan_distance : For example, the Manhattan distance between (125, 80, 27) and (110, 70, 34) is |125-110|+|80-70|+|27-34|=32.

In short, there are 2 phases in SOM operation, 
the first phase is the training phase, //!which updating the weight through unsupervised training.
Second phase is recall phase, in the phase we need to select the weight closest to input pixel
as the winner weight. Be careful not to update the weights at this phase.

<TRAINING PHASE>
step1 : Split each pixel into 3 channels,so does the weight.
step2 : Calculate manhattan distance of each VEP.
step3 : Use WSC.v to find the x,y-coordinate with minimum manhattan distance,in other words,WSC.v is used to find the winner_VEP_x,y. 
step4 : Use VEP_x, VEP_y, winner_VEP_x and winner_VEP_y to //!select corresponding neighbor function.
step5 : Update the weight by setting weight_update to high.
step6 : repeat step1 to step 5 until all pixels of image are traversed.

<RECALL PHASE>
step1 : Split each pixel into 3 channels, so does the weight.
step2 : Traversed all VEP's and find the VEP closest(manhattan distance) to input pixel.
step3 : Output winner VEP's weight(RAM_W_D) to testbench.
step4 : Repeat step1 to step4 until all pixels of image are traversed.
*/

//VEP is to compare neighbor function value 
module VEP(
  input              clk,
  input              rst,
  input  [      2:0] VEP_x,
  input  [      2:0] VEP_y,
  input  [      2:0] winner_VEP_x,
  input  [      2:0] winner_VEP_y,
  input  [8*3 - 1:0] pixel,

  input              weight_updata,
  output reg [8*3 - 1:0] weight,       //used to return newer weight of VEP 
  output reg [      9:0] manhattan_distance//manhattan distance, add 2 extension bits to prevent overflow
);
wire signed [8:0] pix_blue_s = {1'b0, pixel[23:16]};
wire signed [8:0] pix_green_s = {1'b0, pixel[15:8]};
wire signed [8:0] pix_red_s = {1'b0, pixel[7:0]};

wire signed [8:0] wei_blue_s = {1'b0, weight[23:16]};
wire signed [8:0] wei_green_s = {1'b0, weight[15:8]};
wire signed [8:0] wei_red_s = {1'b0, weight[7:0]};

wire signed [8:0] blue_d_s;
assign blue_d_s = pix_blue_s - wei_blue_s;
wire signed [8:0] green_d_s;
assign green_d_s = pix_green_s - wei_green_s;
wire signed [8:0] red_d_s;
assign red_d_s = pix_red_s - wei_red_s;

wire [7:0] blue_d;
assign blue_d = (blue_d_s[8])? ~blue_d_s[7:0]+8'd1: blue_d_s[7:0];
wire [7:0] green_d;
assign green_d = (green_d_s[8])? ~green_d_s[7:0]+8'd1: green_d_s[7:0];
wire [7:0] red_d;
assign red_d = (red_d_s[8])? ~red_d_s[7:0]+8'd1: red_d_s[7:0];

always@(*) begin
		manhattan_distance = blue_d + green_d + red_d;
end

wire [2:0] xsubed;
assign xsubed = winner_VEP_x > VEP_x? winner_VEP_x: VEP_x;
wire [2:0] xsub;
assign xsub = winner_VEP_x > VEP_x? VEP_x: winner_VEP_x;
wire [2:0] ysubed;
assign ysubed = winner_VEP_y > VEP_y? winner_VEP_y: VEP_y;
wire [2:0] ysub;
assign ysub = winner_VEP_y > VEP_y? VEP_y: winner_VEP_y;

wire [2:0] VEP_x_dis;
wire [2:0] VEP_y_dis;
assign VEP_x_dis = xsubed - xsub;
assign VEP_y_dis = ysubed - ysub;


//neied
reg signed [8:0] nei_b;
reg signed [8:0] nei_g;
reg signed [8:0] nei_r;
always@(*) begin
    case ({VEP_y_dis, VEP_x_dis})
      6'b000_000:begin
        nei_b = blue_d_s >>> 2;//pixel - weight
        nei_g = green_d_s >>> 2;
        nei_r = red_d_s >>> 2;
      end
      6'b000_001:begin
        nei_b = (blue_d_s) >>> 3;
        nei_g = (green_d_s) >>> 3;
        nei_r = (red_d_s) >>> 3;
      end
      6'b001_000: begin
        nei_b = (blue_d_s) >>> 3;
        nei_g = (green_d_s) >>> 3;
        nei_r = (red_d_s) >>> 3;
      end
      6'b001_001:begin
        nei_b = (blue_d_s) >>> 4;
        nei_g = (green_d_s) >>> 4;
        nei_r = (red_d_s) >>> 4;
      end
      6'b010_000:begin
        nei_b = (blue_d_s) >>> 4;
        nei_g = (green_d_s) >>> 4;
        nei_r = (red_d_s) >>> 4;
      end
      6'b000_010:begin
        nei_b = (blue_d_s) >>> 4;
        nei_g = (green_d_s) >>> 4;
        nei_r = (red_d_s) >>> 4;
      end
      default:begin
        nei_b = 9'd0;
        nei_g = 9'd0;
        nei_r = 9'd0;
      end
    endcase
end

wire signed [8:0] nei_b_sub = wei_blue_s + nei_b;
wire signed [8:0] nei_g_sub = wei_green_s + nei_g;
wire signed [8:0] nei_r_sub = wei_red_s + nei_r;
always@(posedge clk or posedge rst) begin
	if(rst)
		weight <= {8'd125,8'd125,8'd125};
	else if(weight_updata==1'd1)begin
    weight <= {nei_b_sub[7:0],nei_g_sub[7:0],nei_r_sub[7:0]};
  end
  else
    weight <= weight;
end
//10000100 01011011 01001011
//10000100 01011010 01001011


endmodule
