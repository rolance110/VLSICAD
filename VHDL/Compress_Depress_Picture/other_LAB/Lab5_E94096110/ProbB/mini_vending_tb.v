/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.03    ---------------------- //
// ---------------------- mini_vending_tb   ---------------------- // 
/////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`define INTERVAL 10

`ifdef syn
   `include "mini_vending_syn.v"
   `include "/usr/cad/CBDK/CBDK_IC_Contest_v2.1/Verilog/tsmc13_neg.v"
`else
   `include "mini_vending.v"
`endif


module mini_vending_tb();
  reg         clk, rst, en;
  reg  [5:0]  money, beverage;
  wire [5:0]  change;
  wire        finish;

  reg [5:0] golden [9:0];
  integer i,err;
 
  mini_vending mv0(.clk(clk),.rst(rst),.en(en),.money(money),.beverage(beverage),.change(change),.finish(finish));

  always begin
    #(`INTERVAL/2) clk = ~clk;
  end

 initial begin
                      clk = 1; rst = 1; en = 0;
    #`INTERVAL        rst = 1; en = 0;
    #(`INTERVAL*0.5)  rst = 0; 
    #`INTERVAL        en = 1; money = 6'd40;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd40;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd50;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd35;    
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd55;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd52; 
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd20;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd15;  
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd63;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd58;  
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd31;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd18; 
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd35;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd26;  
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd63;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd63;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd54;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd38;    
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
    #`INTERVAL        en = 1; money = 6'd50;
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd13; 
    #`INTERVAL        en = 0; money = 6'd0; beverage = 6'd0;
 end

 initial begin
   golden[0] = 0;
   golden[1] = 15;
   golden[2] = 3;
   golden[3] = 5;
   golden[4] = 5;
   golden[5] = 13;
   golden[6] = 9;
   golden[7] = 0;
   golden[8] = 16;
   golden[9] = 37;
end


  initial begin
    err = 0;
    #(5*`INTERVAL-1)
    for(i=0;i<10;i=i+1)begin
      if(finish === 1'b1)begin
         if(change === golden[i])
            $display("Result No.%0d is correct. the result is %d", i+1,golden[i]);
         else begin
            $display("Result No.%0d is not correct. The result is %d, but %d is expected.", i+1, change, golden[i]);
            err = err + 1;
         end
       end
       else begin
	    $display("Finish signal not detect. (T^T)");
	    err = err + 1;
       end
      #(3*`INTERVAL);
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
       $fsdbDumpfile("mini_vending_tb.fsdb");
       $fsdbDumpvars();
   end
  `endif

 `ifdef syn
    initial $sdf_annotate("mini_vending_syn.sdf",mv0);
 `endif

endmodule

