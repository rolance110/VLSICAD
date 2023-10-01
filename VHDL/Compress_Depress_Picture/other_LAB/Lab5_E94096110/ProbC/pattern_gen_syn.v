/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06
// Date      : Mon Mar 20 13:24:33 2023
/////////////////////////////////////////////////////////////


module pattern_gen ( clk, rst, en, sel, pattern, valid );
  input [1:0] sel;
  input clk, rst, en;
  output pattern, valid;
  wire   en, n1, n4, n5, n6, n7, n8, n9;
  wire   [2:0] cs;
  wire   [2:0] ns;
  assign valid = en;

  DFFSX1 \cs_reg[2]  ( .D(ns[2]), .CK(clk), .SN(n1), .Q(cs[2]), .QN(n9) );
  CLKINVX1 U3 ( .A(rst), .Y(n1) );
  DFFRX1 \cs_reg[1]  ( .D(ns[1]), .CK(clk), .RN(n1), .Q(cs[1]) );
  DFFRX1 \cs_reg[0]  ( .D(ns[0]), .CK(clk), .RN(n1), .Q(cs[0]), .QN(n8) );
  NAND4X2 U14 ( .A(cs[1]), .B(n4), .C(n5), .D(n9), .Y(pattern) );
  NAND2X1 U15 ( .A(sel[0]), .B(cs[0]), .Y(n4) );
  NAND2X1 U16 ( .A(sel[1]), .B(n8), .Y(n5) );
  AND2X2 U17 ( .A(n6), .B(n7), .Y(ns[2]) );
  OAI32X1 U18 ( .A0(n9), .A1(en), .A2(cs[0]), .B0(cs[2]), .B1(n8), .Y(n6) );
  XOR2X1 U19 ( .A(cs[1]), .B(n8), .Y(n7) );
  NOR2X1 U20 ( .A(cs[2]), .B(n7), .Y(ns[1]) );
  NOR2X1 U21 ( .A(cs[2]), .B(cs[0]), .Y(ns[0]) );
endmodule

