/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06
// Date      : Mon Mar 20 13:07:05 2023
/////////////////////////////////////////////////////////////


module mini_vending_DW01_sub_0 ( A, B, CI, DIFF, CO );
  input [5:0] A;
  input [5:0] B;
  output [5:0] DIFF;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7;
  wire   [6:0] carry;

  XOR3X1 U2_5 ( .A(A[5]), .B(n2), .C(carry[5]), .Y(DIFF[5]) );
  ADDFXL U2_4 ( .A(A[4]), .B(n3), .CI(carry[4]), .CO(carry[5]), .S(DIFF[4]) );
  ADDFXL U2_3 ( .A(A[3]), .B(n4), .CI(carry[3]), .CO(carry[4]), .S(DIFF[3]) );
  ADDFXL U2_2 ( .A(A[2]), .B(n5), .CI(carry[2]), .CO(carry[3]), .S(DIFF[2]) );
  ADDFXL U2_1 ( .A(A[1]), .B(n6), .CI(carry[1]), .CO(carry[2]), .S(DIFF[1]) );
  CLKINVX1 U1 ( .A(B[0]), .Y(n7) );
  CLKINVX1 U2 ( .A(B[1]), .Y(n6) );
  NAND2X1 U3 ( .A(B[0]), .B(n1), .Y(carry[1]) );
  CLKINVX1 U4 ( .A(A[0]), .Y(n1) );
  CLKINVX1 U5 ( .A(B[2]), .Y(n5) );
  CLKINVX1 U6 ( .A(B[3]), .Y(n4) );
  CLKINVX1 U7 ( .A(B[4]), .Y(n3) );
  CLKINVX1 U8 ( .A(B[5]), .Y(n2) );
  XNOR2X1 U9 ( .A(n7), .B(A[0]), .Y(DIFF[0]) );
endmodule


module mini_vending ( clk, rst, en, money, beverage, change, finish );
  input [5:0] money;
  input [5:0] beverage;
  output [5:0] change;
  input clk, rst, en;
  output finish;
  wire   N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, n7, n8,
         n9, n10;
  wire   [1:0] cs;
  wire   [1:0] ns;
  wire   [5:0] money_s;

  mini_vending_DW01_sub_0 sub_47 ( .A(money_s), .B(beverage), .CI(1'b0), 
        .DIFF({N22, N21, N20, N19, N18, N17}) );
  EDFFX1 \money_s_reg[2]  ( .D(N25), .E(n9), .CK(clk), .Q(money_s[2]) );
  EDFFX1 \money_s_reg[3]  ( .D(N26), .E(n9), .CK(clk), .Q(money_s[3]) );
  EDFFX1 \money_s_reg[4]  ( .D(N27), .E(n9), .CK(clk), .Q(money_s[4]) );
  EDFFX1 \money_s_reg[5]  ( .D(N28), .E(n9), .CK(clk), .Q(money_s[5]) );
  DFFRX1 \cs_reg[1]  ( .D(ns[1]), .CK(clk), .RN(n10), .Q(cs[1]), .QN(n9) );
  EDFFX1 \money_s_reg[1]  ( .D(N24), .E(n9), .CK(clk), .Q(money_s[1]) );
  EDFFX1 \money_s_reg[0]  ( .D(N23), .E(n9), .CK(clk), .Q(money_s[0]) );
  DFFRX2 \cs_reg[0]  ( .D(ns[0]), .CK(clk), .RN(n10), .Q(cs[0]), .QN(n8) );
  INVX3 U23 ( .A(n7), .Y(finish) );
  AO22X1 U24 ( .A0(money[5]), .A1(n8), .B0(N22), .B1(cs[0]), .Y(N28) );
  AO22X1 U25 ( .A0(money[4]), .A1(n8), .B0(N21), .B1(cs[0]), .Y(N27) );
  AO22X1 U26 ( .A0(money[3]), .A1(n8), .B0(N20), .B1(cs[0]), .Y(N26) );
  AO22X1 U27 ( .A0(money[2]), .A1(n8), .B0(N19), .B1(cs[0]), .Y(N25) );
  AO22X1 U28 ( .A0(money[1]), .A1(n8), .B0(N18), .B1(cs[0]), .Y(N24) );
  NOR3BXL U29 ( .AN(en), .B(cs[0]), .C(finish), .Y(ns[0]) );
  AO22X1 U30 ( .A0(money[0]), .A1(n8), .B0(N17), .B1(cs[0]), .Y(N23) );
  NOR2BX2 U31 ( .AN(money_s[0]), .B(n7), .Y(change[0]) );
  NOR2BX2 U32 ( .AN(money_s[1]), .B(n7), .Y(change[1]) );
  NOR2BX2 U33 ( .AN(money_s[2]), .B(n7), .Y(change[2]) );
  NOR2BX2 U34 ( .AN(money_s[3]), .B(n7), .Y(change[3]) );
  NOR2BX2 U35 ( .AN(money_s[4]), .B(n7), .Y(change[4]) );
  NOR2BX2 U36 ( .AN(money_s[5]), .B(n7), .Y(change[5]) );
  NAND2X2 U37 ( .A(cs[1]), .B(n8), .Y(n7) );
  NOR2X1 U38 ( .A(cs[1]), .B(n8), .Y(ns[1]) );
  CLKINVX1 U39 ( .A(rst), .Y(n10) );
endmodule

