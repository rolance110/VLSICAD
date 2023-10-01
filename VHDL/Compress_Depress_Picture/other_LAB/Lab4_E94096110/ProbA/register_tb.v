`timescale 1ns/10ps

`ifdef SYN
`include "register_syn.v"
`timescale 1ns/10ps
`include "/usr/cad/CBDK/CBDK018_UMC_Faraday_v1.0/orig_lib/fsa0m_a/2009Q2v2.0/GENERIC_CORE/FrontEnd/verilog/fsa0m_a_generic_core_21.lib"
`else
`include "register.v"
`endif
`timescale 1ns/10ps

`define period 10
module register_tb;
	reg clk, rst, reg_write;
	reg [5:0] src1_addr, src2_addr, write_addr;
	reg [31:0] write_data;
	wire [31:0] src1, src2;
	
	integer i;
	
	register R1(
		.clk(clk),
		.rst(rst),
		.reg_write(reg_write),
		.src1_addr(src1_addr),
		.src2_addr(src2_addr),
		.write_addr(write_addr),
		.write_data(write_data),
		.src1(src1),
		.src2(src2)
	);
	
	always #(`period/2) clk = ~clk;
	
	`ifdef SYN
		initial $sdf_annotate("shifter_syn.sdf", S1);
	`endif
	
	initial begin
		clk = 0; rst = 1; src1_addr=6'd0; src2_addr=6'd0;
		#10 rst = 0;
		for(i=0; i<64; i=i+1)begin
			#10	reg_write=1'b1; write_addr=i; write_data=i;
		end
		
		#10
		reg_write=1'b0; write_addr=0;write_data=32'd0;
		
		#10
		for(i=0; i<64; i=i+1)begin
			if(R1.REG_FILE[i] != i)begin
				show_err(1);
			end
		end
		
		#10 reg_write=1; write_addr=33; write_data=1216;
		#10 reg_write=1; write_addr=55; write_data=88;
		#10 reg_write=0;
		#30 src1_addr=55;src2_addr=33;
		
		#10
		if(src1!=88 || src2!=1216)begin
			show_err(2);
		end
		
		#10 src1_addr=0;src2_addr=0;
		
		#100 show_err(0);
	end
	
	initial begin
		`ifdef FSDB
			$fsdbDumpfile("register.fsdb");
			$fsdbDumpvars(0, R1);
		`elsif FSDB_ALL
			$fsdbDumpfile("register.fsdb");
			$fsdbDumpvars("+struct", "+mda", R1);
		`endif
	end
	
	task show_err;
		input integer err;
		begin
			if(err === 0)begin
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
			else if(err===1)begin
				$display("\n");
				$display("\n");
				$display("        ****************************               ");
				$display("        **                        **       |\__||  ");
				$display("        **  OOPS!!                **      / X,X  | ");
				$display("        **  Write Failed!!        **    /_____   | ");
				$display("        **  Check your nWave!!    **   /^ ^ ^ \\  |");
				$display("        **                        **  |^ ^ ^ ^ |w| ");
				$display("        ****************************   \\m___m__|_|");
				$display("\n");
			end
			else if(err===2)begin
				$display("\n");
				$display("\n");
				$display("        ****************************               ");
				$display("        **                        **       |\__||  ");
				$display("        **  OOPS!!                **      / X,X  | ");
				$display("        **  Read Failed!!         **    /_____   | ");
				$display("        **  Check your nWave!!    **   /^ ^ ^ \\  |");
				$display("        **                        **  |^ ^ ^ ^ |w| ");
				$display("        ****************************   \\m___m__|_|");
				$display("\n");
			end
			$finish;
		end
	endtask
	
endmodule
