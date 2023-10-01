/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06
// Date      : Mon Mar 20 12:59:41 2023
/////////////////////////////////////////////////////////////


module det_seq ( clk, rst, d, q, num );
  output [2:0] num;
  input clk, rst, d;
  output q;
  wire   N37, N38, N39, N40, n3, n6, n7, n8, n9, n10, n11, n12, n13, n14, n16,
         n17, n18, n19;
  wire   [2:0] cs;
  wire   [2:0] ns;

  DFFRX1 \cs_reg[2]  ( .D(ns[2]), .CK(clk), .RN(n6), .Q(cs[2]), .QN(n17) );
  EDFFX2 \num_reg[2]  ( .D(N40), .E(N37), .CK(clk), .Q(num[2]), .QN(n18) );
  EDFFX2 \num_reg[1]  ( .D(N39), .E(N37), .CK(clk), .Q(num[1]) );
  DFFRX1 \cs_reg[1]  ( .D(ns[1]), .CK(clk), .RN(n6), .Q(cs[1]), .QN(n19) );
  DFFRX1 \cs_reg[0]  ( .D(ns[0]), .CK(clk), .RN(n6), .Q(cs[0]), .QN(n16) );
  EDFFX2 \num_reg[0]  ( .D(N38), .E(N37), .CK(clk), .Q(num[0]) );
  NAND2X1 U25 ( .A(q), .B(n6), .Y(n13) );
  NAND2X1 U26 ( .A(n6), .B(n13), .Y(N37) );
  NOR2X2 U27 ( .A(n3), .B(n17), .Y(q) );
  CLKINVX1 U28 ( .A(n9), .Y(n3) );
  CLKINVX1 U29 ( .A(rst), .Y(n6) );
  NOR2X1 U30 ( .A(n13), .B(num[0]), .Y(N38) );
  OAI21XL U31 ( .A0(n11), .A1(n18), .B0(n12), .Y(N40) );
  NAND4BX1 U32 ( .AN(n13), .B(num[1]), .C(num[0]), .D(n18), .Y(n12) );
  AOI2BB1X1 U33 ( .A0N(n13), .A1N(num[1]), .B0(N38), .Y(n11) );
  NOR2X1 U34 ( .A(n14), .B(n13), .Y(N39) );
  XNOR2X1 U35 ( .A(num[0]), .B(num[1]), .Y(n14) );
  OAI32X1 U36 ( .A0(n19), .A1(cs[2]), .A2(cs[0]), .B0(n7), .B1(n3), .Y(ns[1])
         );
  AOI211X1 U37 ( .A0(cs[1]), .A1(n16), .B0(n8), .C0(n9), .Y(ns[2]) );
  AOI33X1 U38 ( .A0(n17), .A1(n7), .A2(cs[0]), .B0(cs[2]), .B1(n16), .B2(d), 
        .Y(n8) );
  OAI33X1 U39 ( .A0(n7), .A1(cs[1]), .A2(cs[0]), .B0(n10), .B1(cs[2]), .B2(n19), .Y(ns[0]) );
  XOR2X1 U40 ( .A(d), .B(cs[0]), .Y(n10) );
  CLKINVX1 U41 ( .A(d), .Y(n7) );
  NOR2X1 U42 ( .A(n16), .B(cs[1]), .Y(n9) );
endmodule

