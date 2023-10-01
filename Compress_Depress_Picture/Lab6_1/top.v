/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring   -------------------- //
// ---------------------   Editor : Anson     ---------------------//
// --------------------    Date : 2023.03     -------------------- //
// -------------------- Lab6_1 Image Compress -------------------- // 
/////////////////////////////////////////////////////////////////////

`include "VEP.v"
`include "WSC.v"
`include "controller.v"

module top(
  input          clk,
  input          rst,
  input  [23:0]  RAM_IF_Q,   //original pixel
  input  [23:0]  RAM_W_Q,
  input  [23:0]  RAM_TAG_Q,
  output wire     RAM_IF_OE,
  output wire     RAM_IF_WE,
  output wire [17:0]  RAM_IF_A,
  output wire [23:0]  RAM_IF_D,
  //codebook
  output wire       RAM_W_OE,
  output wire       RAM_W_WE,
  output wire [17:0]  RAM_W_A,
  output wire [23:0]  RAM_W_D,
  
  output wire        RAM_TAG_OE,
  output wire        RAM_TAG_WE,
  output wire [17:0]  RAM_TAG_A,
  output reg [23:0]  RAM_TAG_D,
  output wire        done
);

reg [23:0] codebook [63:0];
wire [23:0] codebook_wire [63:0];
genvar c;
generate
	for(c=0; c<64; c=c+1)begin : generate_block_11
	    assign codebook_wire[c] = codebook[c] ;
	end
endgenerate

wire [5:0] tag_wire [63:0];
wire [10*64 - 1:0] VEPs_MD_wire;
wire [63:0] write_vep;
wire [2:0] winner_x_wire;
wire [2:0] winner_y_wire;

/*controller=========================================*/
controller controller(
  .clk				(clk),
  .rst				(rst),
  .RAM_IF_OE		(RAM_IF_OE),
  .RAM_IF_WE		(RAM_IF_WE), //always zero
  .RAM_IF_A			(RAM_IF_A),
  .RAM_IF_D			(RAM_IF_D), //always zero
  .RAM_W_OE			(RAM_W_OE),
  .RAM_W_WE			(RAM_W_WE), //always zero
  .RAM_W_A			(RAM_W_A),
  .RAM_W_D			(RAM_W_D), //always zero
  .RAM_TAG_OE		(RAM_TAG_OE),
  .RAM_TAG_WE		(RAM_TAG_WE),
  .RAM_TAG_A		(RAM_TAG_A),
  .write_vep		(write_vep),
  .done				(done)
);
/*===================================================*/
/*include VEP========================================*/
VEP VEP0(	
			.clk					(clk),
			.rst					(rst),
			.VEP_x					(3'd0),
			.VEP_y					(3'd0),
			.pixel					(RAM_IF_Q),
			.weight_initial			(codebook_wire[0]),
			.weight_updata			(~RAM_W_OE),
			.tag					(tag_wire[0]),
			.manhattan_distance		(VEPs_MD_wire[9:0])
		);
VEP VEP1(	
			.clk					(clk),
			.rst					(rst),
			.VEP_x					(tag_wire[0][2:0]),
			.VEP_y					(tag_wire[0][5:3]),
			.pixel					(RAM_IF_Q),
			.weight_initial			(codebook_wire[1]),
			.weight_updata			(~RAM_W_OE),
			.tag					(tag_wire[1]),
			.manhattan_distance		(VEPs_MD_wire[19:10])
		);
genvar i;
generate
	for(i=2; i<64; i=i+1)begin : generate_block_10
		VEP VEP(	
			.clk					(clk),
			.rst					(rst),
			.VEP_x					(tag_wire[i-1][2:0]),
			.VEP_y					(tag_wire[i-1][5:3]),
			.pixel					(RAM_IF_Q),
			.weight_initial			(codebook_wire[i]),
			.weight_updata			(~RAM_W_OE),
			.tag					(tag_wire[i]),
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

always@(*) begin
	if(RAM_TAG_WE)begin
		RAM_TAG_D = {18'd0,winner_y_wire,winner_x_wire};
	end
	else
		RAM_TAG_D = 24'd0;	
end

//codebook
integer y;
always@(posedge clk or posedge rst)begin
	if(rst)begin
		for(y=0;y<64;y=y+1)
			codebook[y] <= 24'd0;
	end
	else if(RAM_W_OE)begin
		codebook[RAM_W_A-18'd1] <= RAM_W_Q;
	end
end

endmodule

