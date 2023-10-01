/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor : Almond  ----------------------- //
// ---------------------- Version : v.1.0   ---------------------- //
// ---------------------- Date : 2023.02.08 ---------------------- //
// -------------------------- testbench -------------------------- //
/////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define PERIOD 9.3

/////////////////////////////////////////////////////////
//                                                     //
//               Do not modify code below              //
//                                                     //
/////////////////////////////////////////////////////////
`define MAX 100000
`define size 4096
`define INPUT_PIC "input_pic.bmp"

`define size_pic 64*64
`define size_weight 8*8
`define offset 138
`define offset2 54

`include "RAM.v"

`ifdef syn
  `include "/usr/cad/CBDK/SAED14_EDK_rvt/verilog/saed14nm_rvt.v"
  `include "../syn/top_syn.v"
`else
  `include "../rtl/top.v"
`endif

`ifdef tb3//left to right bottom to top
  `define GOLDEN_PIC    "../dat/l2rb2t_bmp.dat"
  `define GOLDEN_WEIGHT "../dat/l2rb2t_weight.dat"
  `define MODE          2'd3
`elsif tb2//left to right top to bottom
  `define GOLDEN_PIC    "../dat/l2rt2b_bmp.dat"
  `define GOLDEN_WEIGHT "../dat/l2rt2b_weight.dat"
  `define MODE          2'd2
`elsif tb1//right to left bottom to top
  `define GOLDEN_PIC    "../dat/r2lb2t_bmp.dat"
  `define GOLDEN_WEIGHT "../dat/r2lb2t_weight.dat"
  `define MODE          2'd1
`elsif tb0//right to left top to bottom
  `define GOLDEN_PIC    "../dat/r2lt2b_bmp.dat"
  `define GOLDEN_WEIGHT "../dat/r2lt2b_weight.dat"
  `define MODE          2'd0
`else //tb3
  `define GOLDEN_PIC    "../dat/l2rb2t_bmp.dat"
  `define GOLDEN_WEIGHT "../dat/l2rb2t_weight.dat"
  `define MODE          2'd3
`endif


module top_tb;
  reg           clk;
  reg           rst;
  wire [23:0]   RAM_IF_Q;
  wire [23:0]   RAM_W_Q;
  wire [23:0]   RAM_PIC_Q;
  wire          RAM_IF_OE;
  wire          RAM_IF_WE;
  wire [17:0]   RAM_IF_A;
  wire [23:0]   RAM_IF_D;
  wire          RAM_W_OE;
  wire          RAM_W_WE;
  wire [17:0]   RAM_W_A;
  wire [23:0]   RAM_W_D;
  wire          RAM_PIC_OE;
  wire          RAM_PIC_WE;
  wire [17:0]   RAM_PIC_A;
  wire [23:0]   RAM_PIC_D;
  wire          done;
  reg  [ 1:0]   mode;
  reg           realdone;
  integer err_weight = 0;
  integer err_pic    = 0;
  integer i, ifile, ofile, pointer, temp;

  reg [7:0] data [`size_pic*3+`offset:0];
  reg [23:0] golden_weight [`size_weight-1:0];
  reg [23:0] golden_pic    [`size_pic-1:0];

  //top
  top top(
    .clk           (clk),
    .rst           (rst),
    .mode          (mode),
    .RAM_IF_Q      (RAM_IF_Q),
    .RAM_W_Q       (RAM_W_Q),
    .RAM_PIC_Q     (RAM_PIC_Q),
    .RAM_IF_OE     (RAM_IF_OE),
    .RAM_IF_WE     (RAM_IF_WE),
    .RAM_IF_A      (RAM_IF_A),
    .RAM_IF_D      (RAM_IF_D),
    .RAM_W_OE      (RAM_W_OE),
    .RAM_W_WE      (RAM_W_WE),
    .RAM_W_A       (RAM_W_A),
    .RAM_W_D       (RAM_W_D),
    .RAM_PIC_OE    (RAM_PIC_OE),
    .RAM_PIC_WE    (RAM_PIC_WE),
    .RAM_PIC_A     (RAM_PIC_A),
    .RAM_PIC_D     (RAM_PIC_D),
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

  RAM RAM_PIC(
    .CK (clk), 
    .A  (RAM_PIC_A), 
    .WE (RAM_PIC_WE), 
    .OE (RAM_PIC_OE), 
    .D  (RAM_PIC_D), 
    .Q  (RAM_PIC_Q)
  ); 

  //clk
  always #(`PERIOD/2) clk = ~clk;

  initial begin
    clk = 0; rst = 1;
    mode = `MODE;
    #(`PERIOD*5) rst = 0;
  end
  
  //realdone(prevent glitch done)
  always @(posedge clk) realdone <= done;

  initial begin
    ifile = $fopen(`INPUT_PIC, "rb");
    pointer = $fread(data, ifile);
    `ifdef tb3//left to right bottom to top
      ofile = $fopen("tb3_result.bmp", "wb");
    `elsif tb2//left to right top to bottom
      ofile = $fopen("tb2_result.bmp", "wb");
    `elsif tb1//right to left bottom to top
      ofile = $fopen("tb1_result.bmp", "wb");
    `elsif tb0//right to left top to bottom
      ofile = $fopen("tb0_result.bmp", "wb");
    `else //tb3
      ofile = $fopen("tb3_result.bmp", "wb");
    `endif
    
    $readmemh(`GOLDEN_PIC, golden_pic);
    $readmemh(`GOLDEN_WEIGHT, golden_weight);

    //store (R, G, B) in RAM_IF
    for(i=0;i<`size_pic;i=i+1) begin
        RAM_IF.memory[i] = {data[3*i+`offset+2],data[3*i+`offset+1],data[3*i+`offset]};
    end

    $fclose(ifile);  
    
    wait(rst == 0)
    wait(realdone);
    
    //check answer
    for (i=0; i<`size_weight; i=i+1) begin
      if(RAM_W.memory[i] !== golden_weight[i]) begin
        err_weight = err_weight+1;
        $display("RAM_W[%4d] = %h, expect = %h", i, RAM_W.memory[i], golden_weight[i]);
      end
    end
    
    if(err_weight == 0) begin
      $display("        ****************************");
      $display("        **                        **");
      $display("        **  WEIGHT ALL CORRECT !  **");
      $display("        **                        **");
      $display("        ****************************");
    end
    
    for (i=0; i<`size_pic; i=i+1) begin
      if(RAM_PIC.memory[i] !== golden_pic[i]) begin
        err_pic = err_pic+1;
        $display("RAM_PIC[%4d] = %h, expect = %h", i, RAM_PIC.memory[i], golden_pic[i]);
      end
    end
    
    if(err_pic == 0) begin
      $display("        ****************************");
      $display("        **                        **");
      $display("        **    IMG  ALL CORRECT !  **");
      $display("        **                        **");
      $display("        ****************************");
    end
    
    
    //write bmp
    for (i=0; i<`offset; i=i+1) begin
      $fwrite(ofile, "%c", data[i]);
    end
    for (i=0; i<`size_pic; i=i+1) begin
      temp = RAM_PIC.memory[i];
      $fwrite(ofile, "%c", temp[7:0]);
      $fwrite(ofile, "%c", temp[15:8]);
      $fwrite(ofile, "%c", temp[23:16]);
    end
    $fclose(ofile);

    
    if ((err_pic + err_weight) === 0)
        begin
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
          $display("        ****************************               ");
          $display("        **                        **       |\__||  ");
          $display("        **  OOPS!!                **      / X,X  | ");
          $display("        **                        **    /_____   | ");
          $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
          $display("        **                        **  |^ ^ ^ ^ |w| ");
          $display("        ****************************   \\m___m__|_|");
          $display("         Totally has %d errors                     ", err_pic+err_weight); 
          $display("\n");
        end
    $finish;
  end

  `ifdef FSDB
    initial begin
      $fsdbDumpfile("top.fsdb");
      $fsdbDumpvars("+struct", "+mda", top);
      //$fsdbDumpvars("+struct", "+mda", top_tb);
      //$fsdbDumpvars("+struct", "+mda", RAM_IF);
      //$fsdbDumpvars("+struct", "+mda", RAM_W);
      //$fsdbDumpvars("+struct", "+mda", RAM_PIC);
    end
  `endif
  initial begin
    #(`MAX * `PERIOD);
    $display("*************************************");
    $display("\n");
    $display("holy cow!! simulation can not finish !");
    $display("\n");
        $display("*************************************");
    $finish;
  end
  
  `ifdef syn
    initial $sdf_annotate("../syn/top_syn.sdf", top);
  `endif 
  
endmodule

