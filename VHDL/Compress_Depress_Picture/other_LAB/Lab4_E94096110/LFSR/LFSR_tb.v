`timescale 1ns/10ps
`include "LFSR.v"
`define period 10
module LFSR_tb;

// ----------------------   reg  ---------------------- //
reg  clk;
reg  rst;
reg	 seed_val;
reg [7:0] seed;
// ----------------------  wire  ---------------------- //
wire [7:0] d;

integer i, fp_w, fp_r;

reg [7:0] exp [260:0];


LFSR L1(
	.clk(clk),
	.rst(rst),
	.seed_val(seed_val),
	.seed(seed),
	.d(d)
);

//clock generator
always #(`period/2) clk = ~clk;

initial begin
	fp_r = $fopen("golden.txt", "r");
	i=0;
	while(!$feof(fp_r))begin
		$fscanf(fp_r, "%d\n", exp[i]);
		i = i+1;
	end
	$fclose(fp_r);
	for(i=0; i<259; i=i+1)begin
		#10 
		if(exp[i]!==d)begin
			show_err(1);
			$finish;
		end
	end
	show_err(0);
	$finish;
end

initial begin
	$monitor($time, " output = %d, expect = %d", d, exp[i]);
end

initial begin
	#0	clk=1; rst=1; seed=7; seed_val=0;
	#10 rst=0;
	
	#30 seed_val = 1;
	#10 seed_val = 0;
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
		else begin
			$display("\n");
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  OOPS!!                **      / X,X  | ");
			$display("        **                        **    /_____   | ");
			$display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
	end
endtask

initial begin
  `ifdef FSDB
    $fsdbDumpfile("LFSR.fsdb");
    $fsdbDumpvars("+mda");
  `endif
end
endmodule
