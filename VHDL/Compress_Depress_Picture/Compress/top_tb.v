`timescale 1ns/10ps
`define PERIOD 10.0
`define MAX 50700 // Max cycle number
/*
`ifdef _512
`define INPUT_PIC "lena_512_512.bmp"
`define WEIGHT "codebook_512.bmp"
`define GOLDEN "data_tag_512.hex"  
`define size_pic 512*512
`define offset 138
`define offset2 54
`else
*/
`define INPUT_PIC "input_64_64.bmp"
`define WEIGHT "codebook_64.bmp"
`define GOLDEN "data_tag_64_inv.hex"  
`define size_pic 64*64
`define offset 138
`define offset2 54
//`endif

`define size_weight 8*8
`define width 256


`include "RAM.v"

`ifdef syn
`include "/usr/cad/CBDK/SAED14_EDK_rvt/verilog/saed14nm_rvt.v"
`include "top_syn.v"
`else
`include "top.v"
`endif

module top_tb;
	integer size= `size_pic;
	reg 		clk;
	reg			rst;
	reg [7:0] data [`size_pic*3+`offset:0];
	reg [7:0] codebook [`size_weight*3+`offset2:0];
	reg [23:0] golden [`size_pic-1:0];
	reg [7:0] data2 ;
	reg real_done;
	integer point = 0;
	integer i,j, pointer, pointer2, pointer3, ifile1, ifile2, ifile3, ifile4, ofile1, correct_num=0,err=0;
	
	wire [23:0]   RAM_IF_Q;
	wire [23:0]   RAM_W_Q;
	wire [23:0]   RAM_TAG_Q;
	wire          RAM_IF_OE;
	wire          RAM_IF_WE;
	wire [17:0]   RAM_IF_A;
	wire [23:0]   RAM_IF_D;
	wire          RAM_W_OE;
	wire          RAM_W_WE;
	wire [17:0]   RAM_W_A;
	wire [23:0]   RAM_W_D;
	wire          RAM_TAG_OE;
	wire          RAM_TAG_WE;
	wire [17:0]   RAM_TAG_A;
	wire [23:0]   RAM_TAG_D;
	
	wire done;
	
	reg [23:0] tmp;
			
	//top
	top TOP(
		.clk           (clk),
		.rst           (rst),
		.RAM_IF_Q      (RAM_IF_Q),
		.RAM_W_Q       (RAM_W_Q),
		.RAM_TAG_Q     (RAM_TAG_Q),
		.RAM_IF_OE     (RAM_IF_OE),
		.RAM_IF_WE     (RAM_IF_WE),
		.RAM_IF_A      (RAM_IF_A),
		.RAM_IF_D      (RAM_IF_D),
		.RAM_W_OE      (RAM_W_OE),
		.RAM_W_WE      (RAM_W_WE),
		.RAM_W_A       (RAM_W_A),
		.RAM_W_D       (RAM_W_D),
		.RAM_TAG_OE    (RAM_TAT_OE),
		.RAM_TAG_WE    (RAM_TAG_WE),
		.RAM_TAG_A     (RAM_TAG_A),
		.RAM_TAG_D     (RAM_TAG_D),
		.done          (done)
	);
	
	//RAM
	RAM RAM_IF(
		.CK (clk), 
		.A  (RAM_IF_A), 
		.WE (RAM_IF_WE), 
		.OE (RAM_IF_OE), 
		.D  (RAM_IF_D), 
		.Q  (RAM_IF_Q)
	);  
	
	RAM RAM_W(
		.CK (clk), 
		.A  (RAM_W_A), 
		.WE (RAM_W_WE), 
		.OE (RAM_W_OE), 
		.D  (RAM_W_D), 
		.Q  (RAM_W_Q)
	);
	
	RAM RAM_TAG(
		.CK (clk), 
		.A  (RAM_TAG_A), 
		.WE (RAM_TAG_WE), 
		.OE (RAM_TAG_OE), 
		.D  (RAM_TAG_D), 
		.Q  (RAM_TAG_Q)
	); 
	
	always #(`PERIOD/2) clk = ~clk;
	always @(posedge clk) real_done <= done;
	initial begin
       clk = 0; rst = 0;
		#(`PERIOD) rst = 1;
		#(`PERIOD) rst = 0;
	end
	
	`ifdef syn
		initial $sdf_annotate("top_syn.sdf", TOP);
	`endif
	
	initial
	begin
		`ifdef FSDB
			$fsdbDumpfile("top.fsdb");
			$fsdbDumpvars("+struct", "+mda",TOP);
			//$fsdbDumpvars("+struct", "+mda",RAM_IF);
			//$fsdbDumpvars("+struct", "+mda",RAM_W);
		`endif
		
		#(`PERIOD*`MAX)
		for (j = 0; j < `size_pic; j=j+1)
		begin
			if(RAM_TAG.memory[j][7:0] !== golden[j]) begin
				err=err+1;
				$display("RAM_TAG[%4d] = %6h, expect = %6h", j, RAM_TAG.memory[j][7:0], golden[j]);
			end
			else begin
				$display("RAM_TAG[%4d] = %6h, pass", j, RAM_TAG.memory[j][7:0]);
			end
		end
		$display("timeout!! no finish\n");
		$display("error = %4d", err);
		$finish;
	end
	
	initial begin
		ifile1 = $fopen(`INPUT_PIC, "rb");
		ifile3 = $fopen(`WEIGHT, "rb");
		pointer = $fread(data, ifile1);		//read picture
		pointer2= $fread(codebook, ifile3);	//read codebook 
		$readmemh(`GOLDEN, golden);
		begin: loop
			for(i=0;i<`size_weight;i=i+1)begin //write codebook into RMA_W
				RAM_W.memory[i] = {codebook[3*i+`offset2+2],codebook[3*i+`offset2+1],codebook[3*i+`offset2]};
				//TOP.VEP_array[i].VEP.weight = {codebook[3*i+`offset2+2],codebook[3*i+`offset2+1],codebook[3*i+`offset2]};
			end
			for(i=0;i<`size_pic;i=i+1) begin //write picture into RMA_IF
				RAM_IF.memory[i] = {data[3*i+`offset+2],data[3*i+`offset+1],data[3*i+`offset]};
			end
		end
		
		//if(correct_num == size * 3) $display("read success\n");
		$display(data[10]);
		$display(data[11]);
		$display(data[12]);
		$display(data[13]);
		$fclose(ifile1);
		$fclose(ifile3);
		$fclose(ifile4);
		wait (real_done)
		
		for(i=0;i<`size_pic;i=i+1) begin
			tmp = RAM_TAG.memory[i];
			if(RAM_TAG.memory[i][7:0] !== golden[i]) begin
				err=err+1;
				$display("RAM_TAG[%4d] = %6h, expect = %h", i, RAM_TAG.memory[i][7:0], golden[i]);
			end
			else begin
				$display("RAM_TAG[%4d] = %6h, pass", i, RAM_TAG.memory[i][7:0]);
			end
		end	
		
		if (err === 0)
        begin
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
        else
        begin
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
		$finish;
	end
	
	`ifdef FSDB
	initial begin
		$fsdbDumpfile("top.fsdb");
		$fsdbDumpvars("+struct", "+mda",TOP);
		//$fsdbDumpvars("+struct", "+mda",RAM_IF);
		//$fsdbDumpvars("+struct", "+mda",RAM_W);
	end
	`endif
endmodule