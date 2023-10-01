//`include "LFSR.v"
`include "../rtl/VEP.v"
`include "../rtl/WSC.v"
`include "../rtl/controller.v"

module top(
  input          clk,
  input          rst,
  input  [ 1:0]  mode,

  input  [23:0]  RAM_IF_Q,
  input  [23:0]  RAM_W_Q,
  input  [23:0]  RAM_PIC_Q,
  
  output wire        RAM_IF_OE,
  output wire        RAM_IF_WE,
  output wire [17:0]  RAM_IF_A,
  output wire [23:0]  RAM_IF_D,
  
  output wire         RAM_W_OE,
  output wire        RAM_W_WE,
  output wire [17:0]  RAM_W_A,
  output wire [23:0]  RAM_W_D,
  
  output wire        RAM_PIC_OE,
  output wire        RAM_PIC_WE,
  output wire [17:0]  RAM_PIC_A,
  output wire [23:0]  RAM_PIC_D,
  output wire         done
);

reg [7:0] wei_init [191:0];
reg [7:0] cnt_init;

wire [10*64 - 1:0] VEPs_MD_wire;
wire [2:0] winner_x_wire;
wire [2:0] winner_y_wire;
wire [24*64 - 1:0] VEPs_WEI_wire;

wire init_flag;
wire rst_flag;
/*controller=========================================*/
controller controller(
  .clk				(clk),
  .rst				(rst),
  .mode				(mode),
  .weight  	        (VEPs_WEI_wire),
  .winner_VEP_x		(winner_x_wire),
  .winner_VEP_y		(winner_y_wire),
  .RAM_IF_OE		(RAM_IF_OE),
  .RAM_IF_WE		(RAM_IF_WE),
  .RAM_IF_A			(RAM_IF_A),
  .RAM_IF_D			(RAM_IF_D),
  .RAM_W_OE			(RAM_W_OE),
  .RAM_W_WE			(RAM_W_WE),
  .RAM_W_A			(RAM_W_A),
  .RAM_W_D			(RAM_W_D),
  .RAM_PIC_OE		(RAM_PIC_OE),
  .RAM_PIC_WE		(RAM_PIC_WE),
  .RAM_PIC_A		(RAM_PIC_A),
  .RAM_PIC_D		(RAM_PIC_D),
  .weight_updata	(weight_updata_wire),
  .done				(done),
  .rst_flag        (rst_flag),
  .init_flag        (init_flag)
);
/*===================================================*/
/*LFSR===============================================*/
//cnt_init
always@(posedge clk or posedge rst)begin
	if(rst)
		cnt_init <= 8'd0;
	else if(rst_flag)begin
    cnt_init <= 8'd0;
  end
  else
		cnt_init <= cnt_init + 8'd1;
end

wire random_bit;
wire [7:0] n_LFSR;
reg [7:0] r_LFSR;

assign n_LFSR = {r_LFSR[6:0], random_bit};
assign random_bit = (r_LFSR[7]^~r_LFSR[5]) ^ (r_LFSR[4] ^ ~r_LFSR[3]);

always@(posedge rst or posedge clk) begin
	if(rst)begin
    r_LFSR <= 8'd0;
  end
  else if(rst_flag)begin
	r_LFSR <= 8'd7;
  end
	else begin
	r_LFSR <= n_LFSR;
	end
end
integer j;
always@(posedge rst or posedge clk) begin
	if(rst)begin
    for(j=0; j<192; j=j+1)begin
      wei_init[j] <= 8'd0;
    end
  end
  else if(rst_flag)begin
    wei_init[0] <= 8'd7;
  end
	else begin
    wei_init[cnt_init+8'd1] <= n_LFSR;
	end
end
wire [7:0] wei_init_wire [191:0];
genvar k;
generate
	for(k=0; k<192; k=k+1)begin : generate_block_init
    assign wei_init_wire[k] = wei_init[k];
  end
endgenerate
/*===================================================*/
/*include VEP========================================*/
genvar i;
generate
	for(i=0; i<64; i=i+1)begin : generate_block_10
			VEP VEP(	
			.clk					(clk),
			.rst					(rst),
			.VEP_x					(i[2:0]),
			.VEP_y					(i[5:3]),
			.winner_VEP_x			(winner_x_wire),
			.winner_VEP_y			(winner_y_wire),
			.pixel					(RAM_IF_Q),
			.weight_initial			({wei_init_wire[i*3],wei_init_wire[i*3+1],wei_init_wire[i*3+2]}),//initial weight
			.weight_updata			(weight_updata_wire),
			.weight					(VEPs_WEI_wire[(24*i)+:24]),
      .init_flag        (init_flag),
			.manhattan_distance		(VEPs_MD_wire[(10*i)+:10])
		);
	end 
endgenerate
/*===================================================*/
/*include WSC========================================*/
WSC WSC(
	.VEPs_manhattan_distance(VEPs_MD_wire),
	.winner_x(winner_x_wire),
	.winner_y(winner_y_wire)
);
/*===================================================*/
endmodule
