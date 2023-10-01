/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- det_1100_tb       ---------------------- // 
/////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`define INTERVAL 10

`ifdef syn
   `include "det_seq_syn.v"
   `include "/usr/cad/CBDK/CBDK_IC_Contest_v2.1/Verilog/tsmc13_neg.v"
`else
   `include "det_seq.v"
`endif


module det_seq_tb();
  reg clk,rst,d;
  wire q;
  wire [2:0] num;

  reg [29:0] golden;
  reg [2:0]  num_golden;
  integer i,err;
 
  det_seq d0(.clk(clk),.rst(rst),.d(d),.q(q), .num(num));

  always begin
    #(`INTERVAL/2) clk = ~clk;
  end

 initial begin
                clk = 1; rst = 1; d = 0;
    #`INTERVAL  rst = 1;
    #(`INTERVAL*0.5)  rst = 0; 
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 0;	
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 1;	
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 1;	
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 1;
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 0;
    #`INTERVAL  d = 1;
	#`INTERVAL  d = 1;
	#`INTERVAL  d = 0;
	#`INTERVAL  d = 0;
	#`INTERVAL  d = 1;
	#`INTERVAL  d = 1;
	#`INTERVAL  d = 0;
	#`INTERVAL  d = 0;
	#`INTERVAL  d = 1;
	#`INTERVAL  d = 0;
	#`INTERVAL  d = 0;
 end

 initial begin
   golden[0] = 0;
   golden[1] = 0;
   golden[2] = 0;
   golden[3] = 0;
   golden[4] = 0;
   golden[5] = 0;
   golden[6] = 0;
   golden[7] = 0;
   golden[8] = 0;
   golden[9] = 0;
   golden[10] = 0;
   golden[11] = 0;
   golden[12] = 1;
   golden[13] = 0;
   golden[14] = 0;
   golden[15] = 0;
   golden[16] = 0;
   golden[17] = 0;
   golden[18] = 0;
   golden[19] = 1;
   golden[20] = 0;
   golden[21] = 0;
   golden[22] = 0;
   golden[23] = 1;
   golden[24] = 0;
   golden[25] = 0;
   golden[26] = 0;
   golden[27] = 1;
   golden[28] = 0;
   golden[29] = 0;
   num_golden = 3'd4;
end


  initial begin
    err = 0;
    #(3*`INTERVAL-1)
    for(i=0;i<30;i=i+1)begin
       if(q === golden[i])
          $display("Result No.%0d is correct.", i+1);
      else begin
          $display("Result No.%0d is not correct. The result is %d, but %d is expected.", i+1, q, golden[i]);
          err = err + 1;
      end
       #`INTERVAL;
    end

    if(num === num_golden)
    	$display("The totoal number of pattern 11001 is %d. Correct!",num);
    else begin
     	$display("The totoal number of pattern 11001 is %d. Not correct, %d is expected!",num, num_golden);       
         err = err + 1;
    end

    if(err===0)begin
          $display("\n");
		  $display("\n");
			$display("        **************************               ");
			$display("        *                        *       |\__||  ");
			$display("        *  Congratulations !!    *      / O.O  | ");
			$display("        *                        *    /_____   | ");
			$display("        *  Simulation PASS!!     *   /^ ^ ^ \\  |");
			$display("        *                        *  |^ ^ ^ ^ |w| ");
			$display("        **************************   \\m___m__|_|");
			$display("\n");
    end
    else begin
          $display("\n");
		  $display("\n");
			$display("        **************************               ");
			$display("        *                        *       |\__||  ");
			$display("        *  OOPS!!                *      / X,X  | ");
			$display("        *                        *    /_____   | ");
			$display("        *  Simulation Failed!!   *   /^ ^ ^ \\  |");
			$display("        *                        *  |^ ^ ^ ^ |w| ");
			$display("        **************************   \\m___m__|_|");
			$display("\n");
    end

    $finish;
  end

  `ifdef FSDB
  initial begin
       $fsdbDumpfile("det_seq_tb.fsdb");
       $fsdbDumpvars;
   end
  `endif

 `ifdef syn
    initial $sdf_annotate("det_seq_syn.sdf",d0);
 `endif

endmodule

