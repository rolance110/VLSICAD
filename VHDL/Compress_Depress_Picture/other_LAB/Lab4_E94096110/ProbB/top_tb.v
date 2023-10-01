`timescale 1ns/10ps
`include "top.v"
`define period 10
module top_tb;

// ----------------------   reg  ---------------------- //
reg  clk;
reg  rst;
reg  set_reg;
reg  color_val;
reg  data_val;
reg  [23:0] color;
reg  [23:0] data;
// ----------------------  wire  ---------------------- //
wire [9:0] d;
wire [2:0] index;

integer i, j, debug;


top t1(
	.clk(clk),
	.rst(rst),
	.set_reg(set_reg),
	.color_val(color_val),
	.data_val(data_val),
	.color(color),
	.data(data),
	.d(d),
	.index(index)
);

//clock generator
always #(`period/2) clk = ~clk;

//input data check
always@(posedge clk) begin
	if(data_val)begin
		debug=1;
		#80
		show_err(j);
		debug=0;
	end
end

initial begin
	$monitor($time, " data_val = %d, data = %h, d = %h, index = %h", data_val, data, d, index);
end

initial begin
	#0	clk=1; rst=1; set_reg=0; color_val=0; data_val=0; color=24'h0; data=24'h0; debug=0;
	#10 rst=0;
	//set color registers
	#23 set_reg=1;
	#10	color_val=1; color=24'hff8c00;//color[0]
	#10	color_val=0; color=24'h000000;
	#10	color_val=1; color=24'h00ffd9;//color[1]
	#10	color_val=0; color=24'h000000;
	#10	color_val=1; color=24'h0000ff;//color[2]
	for(i=3; i<8; i=i+1)begin//color[3] ~ color[7]
		#10	color_val=1; color=24'h0000ff;
	end
	#10	set_reg=0; color_val=0; color=24'h000000;
	
	//input data
	#10 data_val=1; data=24'h00ffaa; j=1;
	#10 data_val=0; data=24'h0;
	#90 data_val=1; data=24'h0101ff; j=2;
	#10 data_val=0; data=24'h0;
	#200 show_err(0);
	$finish;
end

task show_err;
	input integer check;
	begin
		if(check === 0)begin
			$display("\n");
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  Congratulations !!    **      / O.O  | ");
			$display("        **                        **    /_____   | ");
			$display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
		else if(check===1 && !(d==10'h2f && index==3'd1) )begin
			$display("\n");
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  OOPS!!                **      / X,X  | ");
			$display("        **  1st check Failed!!    **    /_____   | ");
			$display("        **  Check your nWave!!    **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
		else if(check===2 && !(d==10'h2 && index==3'd2) )begin
			$display("\n");
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  OOPS!!                **      / X,X  | ");
			$display("        **  2nd check Failed!!    **    /_____   | ");
			$display("        **  Check your nWave!!    **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
	end
endtask

initial begin
  `ifdef FSDB
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars("+mda");
  `endif
end
endmodule
