/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.03    ---------------------- //
// ---------------------- pattern_gen_tb    ---------------------- // 
/////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define PERIOD 10.0
`ifdef syn
	`include "/usr/cad/CBDK/CBDK_IC_Contest_v2.1/Verilog/tsmc13_neg.v"
	`include "pattern_gen_syn.v"
`else
	`include "pattern_gen.v"
`endif

module pattern_gen_tb;
	reg clk;
	reg	rst;
	reg en;
	reg [1:0] sel;
	wire pattern;
	wire valid;
	integer     i,err=0;
	
	initial begin
		en = 1'b0; sel = 2'd0; clk = 0; rst = 1'b1; 
		#(`PERIOD) rst = 1'b0;
		#(`PERIOD) en = 1'b1; sel = 2'b0;
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end	
		#(`PERIOD) en  = 1'b0;
		
		#(`PERIOD) en  = 1'b1; sel = 2'b01;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`PERIOD) en  = 1'b0;
		
		#(`PERIOD) en  = 1'b1; sel = 2'b10;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`PERIOD) en  = 1'b0;
		
		#(`PERIOD) en  = 1'b1; sel = 2'b11;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			for(i=0; i<4; i=i+1)begin
				@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`PERIOD) en  = 1'b0;
	end
		#(`PERIOD*3);
		if(err!= 0) begin
		  $display("\n");
          $display("\n");
          $display("        ****************************               ");
          $display("        **                        **       |\__||  ");
          $display("        **  OOPS!!                **      / X,X  | ");
          $display("        **                        **    /_____   | ");
          $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
          $display("        **                        **  |^ ^ ^ ^ |w| ");
          $display("        ****************************   \\m___m__|_|");
          $display("         Totally has %d errors                     ", err); 
          $display("\n");
		 end
		else begin
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
		
		$finish;
	end
	
	always #(`PERIOD/2) clk = ~clk;
	
	
	
	
	pattern_gen p1(
	.clk(clk),
	.rst(rst),
	.en(en),
	.sel(sel),
	.pattern(pattern),
	.valid(valid));
	
	`ifdef FSDB
	initial begin
		$fsdbDumpfile("pattern_gen.fsdb");
		$fsdbDumpvars("+struct", "+mda",p1);
	end
	`endif
	
	`ifdef syn
		initial $sdf_annotate("pattern_gen_syn.sdf",p1);
	`endif
endmodule
