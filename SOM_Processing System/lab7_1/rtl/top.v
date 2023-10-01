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
wire weight_updata_wire;
wire [10*64 - 1:0] VEPs_MD_wire;
wire [2:0] winner_x_wire;
wire [2:0] winner_y_wire;
wire [24*64 - 1:0] VEPs_WEI_wire;
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
  .done				(done)
);
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
			.weight_updata			(weight_updata_wire),
			.weight					(VEPs_WEI_wire[(24*i)+:24]),
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
