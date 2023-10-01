`timescale 1ns/10ps
`define PERIOD 10.0
`define MAX	50000

`define WEIGHT "codebook_64.bmp"
`define TAG "data_tag_64_inv.hex" 
`define GOLDEN "golden.hex"
//`define RESULT "golden.hex"
`define RESULT "reconstructed_64.bmp"
`define ORIGINAL "input_64_64.bmp" 

`define size_pic 64*64
`define offset 138
`define offset2 54
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
	integer size = `size_pic;
	reg 		clk;
	reg			rst;
	reg [7:0] golden [`size_pic*3-1:0];
	reg [7:0] result [`size_pic*3+`offset:0];
	reg [7:0] data [`size_pic*3+`offset:0];
	reg [7:0] codebook [`size_weight*3+`offset2:0];
	reg [23:0] tags [`size_pic:0];
	
	reg [23:0] tmp;
	reg [7:0] data2;
	reg real_done;
	integer point = 0,sum=0,psnr;
	integer i, pointer, pointer2, pointer3, ifile1, ifile2, ifile3, ofile4, ofile5, correct_num=0,err=0;
	reg[7:0] r1,g1,b1,r2,g2,b2;
	reg signed[8:0] dr,dg,db;
	
	wire [23:0] RAM1_Q,RAM2_Q,RAM3_Q;
	wire [23:0] RAM1_D,RAM2_D,RAM3_D;
	wire [19:0] RAM1_A,RAM2_A,RAM3_A;
	wire RAM1_WE,RAM2_WE,RAM3_WE;
	wire RAM1_OE,RAM2_OE,RAM3_OE;
	wire done;
	
	RAM ram1(.CK(clk), .A(RAM1_A), .WE(RAM1_WE), .OE(RAM1_OE), .D(RAM1_D), .Q(RAM1_Q));
	RAM ram2(.CK(clk), .A(RAM2_A), .WE(RAM2_WE), .OE(RAM2_OE), .D(RAM2_D), .Q(RAM2_Q));
	RAM ram3(.CK(clk), .A(RAM3_A), .WE(RAM3_WE), .OE(RAM3_OE), .D(RAM3_D), .Q(RAM3_Q));
	
	top TOP(
		.clk(clk),
		.rst(rst),
		//RAM codebook
		.RAM_W_Q(RAM1_Q),
		.RAM_W_D(RAM1_D),
		.RAM_W_A(RAM1_A),
		.RAM_W_WE(RAM1_WE),
		.RAM_W_OE(RAM1_OE),
		//RAM TAG
		.RAM_TAG_Q(RAM2_Q),
		.RAM_TAG_D(RAM2_D),
		.RAM_TAG_A(RAM2_A),
		.RAM_TAG_WE(RAM2_WE),
		.RAM_TAG_OE(RAM2_OE),
		//RAM Result picture
		.RAM_PIC_Q(RAM3_Q),
		.RAM_PIC_D(RAM3_D),
		.RAM_PIC_A(RAM3_A),
		.RAM_PIC_WE(RAM3_WE),
		.RAM_PIC_OE(RAM3_OE),
		//controller
		.done(done)
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
	
	initial begin
		#(`PERIOD*`MAX)
		for(i=0;i<`size_pic;i=i+1) begin			
			if(ram3.memory[i] !== {golden[i*3+2],golden[i*3+1],golden[i*3]}) begin
				err=err+1;
				$display("RAM3[%4d] = %h, expect = %h", i, ram3.memory[i], {golden[i*3+2],golden[i*3+1],golden[i*3]});
			end
			else begin
				$display("RAM3[%4d] = %h, pass", i, ram3.memory[i]);
			end
		end
		$display("run time error!!\n");
		$display("error = %4d", err);
		$finish;
	end
	
	initial begin
		//ifile1 = $fopen(`INPUT_PIC, "rb");
		ifile2 = $fopen(`ORIGINAL, "rb");
		ifile3 = $fopen(`WEIGHT, "rb");
		//ofile4 = $fopen(`GOLDEN, "wb");
		ofile5 = $fopen(`RESULT, "wb");
		pointer = $fread(data, ifile2);			//read origin picture
		pointer2= $fread(codebook, ifile3);		//read codebook
		$readmemh(`TAG, tags);					//read tag
		$readmemh(`GOLDEN, golden);				//read golden
		
		begin: loop
			for(i=0;i<`size_weight;i=i+1)begin
				/*$fwrite(o2file,"%d\n",codebook[offset2+i]);
				$fscanf(ifile2,"%d",data2);
				if(data[offset+i] == data2)
					correct_num = correct_num + 1;
				*/
				ram1.memory[i] = {codebook[3*i+`offset2+2],codebook[3*i+`offset2+1],codebook[3*i+`offset2]};
				
			end
			for(i=0;i<`size_pic;i=i+1)
				ram2.memory[i] = tags[i];
		end
		
		wait (real_done)
		
		for(i=0;i<`offset;i=i+1) begin
			$fwrite(ofile5, "%c", data[i]);
		end
		
		for(i=0;i<`size_pic;i=i+1) begin
			//generate golden
			/*if(ram3.memory[i] !== {golden[i*3+`offset2+2],golden[i*3+`offset2+1],golden[i*3+`offset2]}) begin
				err=err+1;
				$display("RAM3[%4d] = %h, expect = %h", i, ram3.memory[i], {golden[i*3+`offset2+2],golden[i*3+`offset2+1],golden[i*3+`offset2]});
			end
			else begin
				$display("RAM3[%4d] = %h, pass", i, ram3.memory[i]);
			end
			tmp = ram3.memory[i];
			$fwrite(ofile4,"%h\n",tmp[7:0]);
			$fwrite(ofile4,"%h\n",tmp[15:8]);
			$fwrite(ofile4,"%h\n",tmp[23:16]);*/
			
			if(ram3.memory[i] !== {golden[i*3+2],golden[i*3+1],golden[i*3]}) begin
				err=err+1;
				$display("RAM3[%4d] = %h, expect = %h", i, ram3.memory[i], {golden[i*3+2],golden[i*3+1],golden[i*3]});
			end
			else begin
				$display("RAM3[%4d] = %h, pass", i, ram3.memory[i]);
			end
			tmp = ram3.memory[i];
			$fwrite(ofile5, "%c", tmp[7:0]);
			$fwrite(ofile5, "%c", tmp[15:8]);
			$fwrite(ofile5, "%c", tmp[23:16]);
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
		//$fsdbDumpvars("+struct", "+mda",ram1);
		//$fsdbDumpvars("+struct",ram2);
		//$fsdbDumpvars("+struct","+mda",ram3);
	end
	`endif
endmodule