/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06
// Date      : Fri Mar  3 17:08:14 2023
/////////////////////////////////////////////////////////////


module fixedpoint_DW_mult_uns_0 ( a, b, product );
  input [7:0] a;
  input [7:0] b;
  output [15:0] product;
  wire   n2, n3, n4, n5, n6, n7, n8, n9, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n110, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n120, n121, n122, n123, n124, n125, n126,
         n127, n128, n129, n130, n131, n132, n133, n134, n135, n136, n137,
         n138, n139, n140, n141, n142, n143, n144, n145, n147, n148, n149,
         n150, n151, n152, n153, n155, n156, n157, n158, n159, n160, n207,
         n208, n209, n210, n211, n212, n213, n214, n215, n216, n217, n218,
         n219, n220, n221, n222, n223, n224, n225, n226, n227, n228, n229,
         n230, n231, n232, n233, n234, n235, n236;

  SAEDRVT14_ADDF_V1_1 U2 ( .A(n2), .B(n15), .CI(n99), .CO(product[15]), .S(
        product[14]) );
  SAEDRVT14_ADDF_V1_1 U3 ( .A(n3), .B(n17), .CI(n16), .CO(n2), .S(product[13])
         );
  SAEDRVT14_ADDF_V1_1 U4 ( .A(n4), .B(n21), .CI(n18), .CO(n3), .S(product[12])
         );
  SAEDRVT14_ADDF_V1_1 U5 ( .A(n5), .B(n22), .CI(n27), .CO(n4), .S(product[11])
         );
  SAEDRVT14_ADDF_V1_1 U6 ( .A(n6), .B(n28), .CI(n35), .CO(n5), .S(product[10])
         );
  SAEDRVT14_ADDF_V1_1 U7 ( .A(n7), .B(n36), .CI(n45), .CO(n6), .S(product[9])
         );
  SAEDRVT14_ADDF_V1_1 U8 ( .A(n8), .B(n46), .CI(n57), .CO(n7), .S(product[8])
         );
  SAEDRVT14_ADDF_V1_1 U9 ( .A(n9), .B(n58), .CI(n69), .CO(n8), .S(product[7])
         );
  SAEDRVT14_ADDF_V1_1 U16 ( .A(n19), .B(n100), .CI(n107), .CO(n15), .S(n16) );
  SAEDRVT14_ADDF_V1_1 U17 ( .A(n23), .B(n20), .CI(n25), .CO(n17), .S(n18) );
  SAEDRVT14_ADDF_V1_1 U18 ( .A(n108), .B(n101), .CI(n115), .CO(n19), .S(n20)
         );
  SAEDRVT14_ADDF_V1_1 U19 ( .A(n24), .B(n29), .CI(n31), .CO(n21), .S(n22) );
  SAEDRVT14_ADDF_V1_1 U20 ( .A(n26), .B(n33), .CI(n116), .CO(n23), .S(n24) );
  SAEDRVT14_ADDF_V1_1 U21 ( .A(n109), .B(n102), .CI(n123), .CO(n25), .S(n26)
         );
  SAEDRVT14_ADDF_V1_1 U22 ( .A(n30), .B(n37), .CI(n32), .CO(n27), .S(n28) );
  SAEDRVT14_ADDF_V1_1 U23 ( .A(n39), .B(n34), .CI(n41), .CO(n29), .S(n30) );
  SAEDRVT14_ADDF_V1_1 U24 ( .A(n43), .B(n117), .CI(n124), .CO(n31), .S(n32) );
  SAEDRVT14_ADDF_V1_1 U25 ( .A(n110), .B(n103), .CI(n131), .CO(n33), .S(n34)
         );
  SAEDRVT14_ADDF_V1_1 U26 ( .A(n38), .B(n47), .CI(n40), .CO(n35), .S(n36) );
  SAEDRVT14_ADDF_V1_1 U27 ( .A(n49), .B(n44), .CI(n42), .CO(n37), .S(n38) );
  SAEDRVT14_ADDF_V1_1 U28 ( .A(n51), .B(n53), .CI(n55), .CO(n39), .S(n40) );
  SAEDRVT14_ADDF_V1_1 U29 ( .A(n125), .B(n118), .CI(n132), .CO(n41), .S(n42)
         );
  SAEDRVT14_ADDF_V1_1 U30 ( .A(n111), .B(n104), .CI(n139), .CO(n43), .S(n44)
         );
  SAEDRVT14_ADDF_V1_1 U31 ( .A(n48), .B(n59), .CI(n50), .CO(n45), .S(n46) );
  SAEDRVT14_ADDF_V1_1 U32 ( .A(n52), .B(n61), .CI(n54), .CO(n47), .S(n48) );
  SAEDRVT14_ADDF_V1_1 U33 ( .A(n65), .B(n63), .CI(n56), .CO(n49), .S(n50) );
  SAEDRVT14_ADDF_V1_1 U34 ( .A(n67), .B(n133), .CI(n140), .CO(n51), .S(n52) );
  SAEDRVT14_ADDF_V1_1 U35 ( .A(n147), .B(n119), .CI(n126), .CO(n53), .S(n54)
         );
  SAEDRVT14_ADDH_0P5 U36 ( .A(n105), .B(n112), .CO(n55), .S(n56) );
  SAEDRVT14_ADDF_V1_1 U37 ( .A(n60), .B(n62), .CI(n71), .CO(n57), .S(n58) );
  SAEDRVT14_ADDF_V1_1 U38 ( .A(n66), .B(n64), .CI(n73), .CO(n59), .S(n60) );
  SAEDRVT14_ADDF_V1_1 U39 ( .A(n75), .B(n68), .CI(n77), .CO(n61), .S(n62) );
  SAEDRVT14_ADDF_V1_1 U40 ( .A(n141), .B(n134), .CI(n127), .CO(n63), .S(n64)
         );
  SAEDRVT14_ADDF_V1_1 U41 ( .A(n148), .B(n120), .CI(n155), .CO(n65), .S(n66)
         );
  SAEDRVT14_ADDH_0P5 U42 ( .A(n106), .B(n113), .CO(n67), .S(n68) );
  SAEDRVT14_ADDF_V1_1 U43 ( .A(n79), .B(n74), .CI(n81), .CO(n69), .S(n70) );
  SAEDRVT14_ADDF_V1_1 U44 ( .A(n76), .B(n83), .CI(n78), .CO(n71), .S(n72) );
  SAEDRVT14_ADDF_V1_1 U45 ( .A(n85), .B(n135), .CI(n142), .CO(n73), .S(n74) );
  SAEDRVT14_ADDF_V1_1 U46 ( .A(n149), .B(n128), .CI(n156), .CO(n75), .S(n76)
         );
  SAEDRVT14_ADDH_0P5 U47 ( .A(n114), .B(n121), .CO(n77), .S(n78) );
  SAEDRVT14_ADDF_V1_1 U48 ( .A(n87), .B(n84), .CI(n89), .CO(n79), .S(n80) );
  SAEDRVT14_ADDF_V1_1 U49 ( .A(n86), .B(n91), .CI(n150), .CO(n81), .S(n82) );
  SAEDRVT14_ADDF_V1_1 U50 ( .A(n143), .B(n136), .CI(n157), .CO(n83), .S(n84)
         );
  SAEDRVT14_ADDH_0P5 U51 ( .A(n122), .B(n129), .CO(n85), .S(n86) );
  SAEDRVT14_ADDF_V1_1 U52 ( .A(n93), .B(n92), .CI(n95), .CO(n87), .S(n88) );
  SAEDRVT14_ADDF_V1_1 U53 ( .A(n151), .B(n144), .CI(n158), .CO(n89), .S(n90)
         );
  SAEDRVT14_ADDH_0P5 U54 ( .A(n130), .B(n137), .CO(n91), .S(n92) );
  SAEDRVT14_ADDF_V1_1 U55 ( .A(n97), .B(n152), .CI(n159), .CO(n93), .S(n94) );
  SAEDRVT14_ADDH_0P5 U56 ( .A(n138), .B(n145), .CO(n95), .S(n96) );
  SAEDRVT14_ADDH_0P5 U57 ( .A(n153), .B(n160), .CO(n97), .S(n98) );
  SAEDRVT14_INV_S_1 U139 ( .A(n98), .X(n215) );
  SAEDRVT14_INV_S_1 U140 ( .A(n94), .X(n214) );
  SAEDRVT14_INV_S_1 U141 ( .A(n96), .X(n211) );
  SAEDRVT14_INV_S_1 U142 ( .A(a[3]), .X(n212) );
  SAEDRVT14_INV_S_1 U143 ( .A(a[4]), .X(n210) );
  SAEDRVT14_INV_S_1 U144 ( .A(a[6]), .X(n208) );
  SAEDRVT14_INV_S_1 U145 ( .A(a[5]), .X(n209) );
  SAEDRVT14_INV_S_1 U146 ( .A(b[1]), .X(n224) );
  SAEDRVT14_INV_S_1 U147 ( .A(b[2]), .X(n223) );
  SAEDRVT14_INV_S_1 U148 ( .A(b[3]), .X(n222) );
  SAEDRVT14_INV_S_1 U149 ( .A(b[4]), .X(n221) );
  SAEDRVT14_INV_S_1 U150 ( .A(b[5]), .X(n220) );
  SAEDRVT14_INV_S_1 U151 ( .A(b[6]), .X(n219) );
  SAEDRVT14_INV_S_1 U152 ( .A(a[1]), .X(n216) );
  SAEDRVT14_INV_S_1 U153 ( .A(b[7]), .X(n218) );
  SAEDRVT14_INV_S_1 U154 ( .A(a[7]), .X(n207) );
  SAEDRVT14_INV_S_1 U155 ( .A(a[0]), .X(n217) );
  SAEDRVT14_INV_S_1 U156 ( .A(a[2]), .X(n213) );
  SAEDRVT14_INV_S_1 U157 ( .A(b[0]), .X(n225) );
  SAEDRVT14_NR2_1 U158 ( .A1(n207), .A2(n218), .X(n99) );
  SAEDRVT14_AO21_1 U159 ( .A1(n70), .A2(n226), .B(n227), .X(n9) );
  SAEDRVT14_AO22_0P5 U160 ( .A1(n226), .A2(n72), .B1(n70), .B2(n72), .X(n227)
         );
  SAEDRVT14_AO21_1 U161 ( .A1(n80), .A2(n228), .B(n229), .X(n226) );
  SAEDRVT14_AO22_0P5 U162 ( .A1(n228), .A2(n82), .B1(n80), .B2(n82), .X(n229)
         );
  SAEDRVT14_AO21_1 U163 ( .A1(n88), .A2(n230), .B(n231), .X(n228) );
  SAEDRVT14_AO22_0P5 U164 ( .A1(n230), .A2(n90), .B1(n88), .B2(n90), .X(n231)
         );
  SAEDRVT14_OAI21_0P5 U165 ( .A1(n232), .A2(n214), .B(n233), .X(n230) );
  SAEDRVT14_OA22_0P75 U166 ( .A1(n232), .A2(n211), .B1(n211), .B2(n214), .X(
        n233) );
  SAEDRVT14_OA21_1 U167 ( .A1(n234), .A2(n215), .B(n235), .X(n232) );
  SAEDRVT14_OA22_0P75 U168 ( .A1(n236), .A2(n234), .B1(n236), .B2(n215), .X(
        n235) );
  SAEDRVT14_ND2_CDC_0P5 U169 ( .A1(a[2]), .A2(b[0]), .X(n236) );
  SAEDRVT14_OR4_1 U170 ( .A1(n225), .A2(n224), .A3(n217), .A4(n216), .X(n234)
         );
  SAEDRVT14_NR2_1 U171 ( .A1(n217), .A2(n223), .X(n160) );
  SAEDRVT14_NR2_1 U172 ( .A1(n217), .A2(n222), .X(n159) );
  SAEDRVT14_NR2_1 U173 ( .A1(n217), .A2(n221), .X(n158) );
  SAEDRVT14_NR2_1 U174 ( .A1(n217), .A2(n220), .X(n157) );
  SAEDRVT14_NR2_1 U175 ( .A1(n217), .A2(n219), .X(n156) );
  SAEDRVT14_NR2_1 U176 ( .A1(n218), .A2(n217), .X(n155) );
  SAEDRVT14_NR2_1 U177 ( .A1(n216), .A2(n224), .X(n153) );
  SAEDRVT14_NR2_1 U178 ( .A1(n216), .A2(n223), .X(n152) );
  SAEDRVT14_NR2_1 U179 ( .A1(n216), .A2(n222), .X(n151) );
  SAEDRVT14_NR2_1 U180 ( .A1(n216), .A2(n221), .X(n150) );
  SAEDRVT14_NR2_1 U181 ( .A1(n216), .A2(n220), .X(n149) );
  SAEDRVT14_NR2_1 U182 ( .A1(n216), .A2(n219), .X(n148) );
  SAEDRVT14_NR2_1 U183 ( .A1(n218), .A2(n216), .X(n147) );
  SAEDRVT14_NR2_1 U184 ( .A1(n224), .A2(n213), .X(n145) );
  SAEDRVT14_NR2_1 U185 ( .A1(n213), .A2(n223), .X(n144) );
  SAEDRVT14_NR2_1 U186 ( .A1(n213), .A2(n222), .X(n143) );
  SAEDRVT14_NR2_1 U187 ( .A1(n213), .A2(n221), .X(n142) );
  SAEDRVT14_NR2_1 U188 ( .A1(n213), .A2(n220), .X(n141) );
  SAEDRVT14_NR2_1 U189 ( .A1(n213), .A2(n219), .X(n140) );
  SAEDRVT14_NR2_1 U190 ( .A1(n218), .A2(n213), .X(n139) );
  SAEDRVT14_NR2_1 U191 ( .A1(n225), .A2(n212), .X(n138) );
  SAEDRVT14_NR2_1 U192 ( .A1(n224), .A2(n212), .X(n137) );
  SAEDRVT14_NR2_1 U193 ( .A1(n223), .A2(n212), .X(n136) );
  SAEDRVT14_NR2_1 U194 ( .A1(n222), .A2(n212), .X(n135) );
  SAEDRVT14_NR2_1 U195 ( .A1(n221), .A2(n212), .X(n134) );
  SAEDRVT14_NR2_1 U196 ( .A1(n220), .A2(n212), .X(n133) );
  SAEDRVT14_NR2_1 U197 ( .A1(n219), .A2(n212), .X(n132) );
  SAEDRVT14_NR2_1 U198 ( .A1(n218), .A2(n212), .X(n131) );
  SAEDRVT14_NR2_1 U199 ( .A1(n225), .A2(n210), .X(n130) );
  SAEDRVT14_NR2_1 U200 ( .A1(n224), .A2(n210), .X(n129) );
  SAEDRVT14_NR2_1 U201 ( .A1(n223), .A2(n210), .X(n128) );
  SAEDRVT14_NR2_1 U202 ( .A1(n222), .A2(n210), .X(n127) );
  SAEDRVT14_NR2_1 U203 ( .A1(n221), .A2(n210), .X(n126) );
  SAEDRVT14_NR2_1 U204 ( .A1(n220), .A2(n210), .X(n125) );
  SAEDRVT14_NR2_1 U205 ( .A1(n219), .A2(n210), .X(n124) );
  SAEDRVT14_NR2_1 U206 ( .A1(n218), .A2(n210), .X(n123) );
  SAEDRVT14_NR2_1 U207 ( .A1(n225), .A2(n209), .X(n122) );
  SAEDRVT14_NR2_1 U208 ( .A1(n224), .A2(n209), .X(n121) );
  SAEDRVT14_NR2_1 U209 ( .A1(n223), .A2(n209), .X(n120) );
  SAEDRVT14_NR2_1 U210 ( .A1(n222), .A2(n209), .X(n119) );
  SAEDRVT14_NR2_1 U211 ( .A1(n221), .A2(n209), .X(n118) );
  SAEDRVT14_NR2_1 U212 ( .A1(n220), .A2(n209), .X(n117) );
  SAEDRVT14_NR2_1 U213 ( .A1(n219), .A2(n209), .X(n116) );
  SAEDRVT14_NR2_1 U214 ( .A1(n218), .A2(n209), .X(n115) );
  SAEDRVT14_NR2_1 U215 ( .A1(n225), .A2(n208), .X(n114) );
  SAEDRVT14_NR2_1 U216 ( .A1(n224), .A2(n208), .X(n113) );
  SAEDRVT14_NR2_1 U217 ( .A1(n223), .A2(n208), .X(n112) );
  SAEDRVT14_NR2_1 U218 ( .A1(n222), .A2(n208), .X(n111) );
  SAEDRVT14_NR2_1 U219 ( .A1(n221), .A2(n208), .X(n110) );
  SAEDRVT14_NR2_1 U220 ( .A1(n220), .A2(n208), .X(n109) );
  SAEDRVT14_NR2_1 U221 ( .A1(n219), .A2(n208), .X(n108) );
  SAEDRVT14_NR2_1 U222 ( .A1(n218), .A2(n208), .X(n107) );
  SAEDRVT14_NR2_1 U223 ( .A1(n207), .A2(n225), .X(n106) );
  SAEDRVT14_NR2_1 U224 ( .A1(n207), .A2(n224), .X(n105) );
  SAEDRVT14_NR2_1 U225 ( .A1(n207), .A2(n223), .X(n104) );
  SAEDRVT14_NR2_1 U226 ( .A1(n207), .A2(n222), .X(n103) );
  SAEDRVT14_NR2_1 U227 ( .A1(n207), .A2(n221), .X(n102) );
  SAEDRVT14_NR2_1 U228 ( .A1(n207), .A2(n220), .X(n101) );
  SAEDRVT14_NR2_1 U229 ( .A1(n207), .A2(n219), .X(n100) );
endmodule


module fixedpoint_DW01_inc_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  SAEDRVT14_ADDH_0P5 U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  SAEDRVT14_ADDH_0P5 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  SAEDRVT14_ADDH_0P5 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  SAEDRVT14_ADDH_0P5 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  SAEDRVT14_ADDH_0P5 U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  SAEDRVT14_ADDH_0P5 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  SAEDRVT14_INV_S_1 U1 ( .A(A[0]), .X(SUM[0]) );
  SAEDRVT14_EO2_V1_0P75 U2 ( .A1(carry[7]), .A2(A[7]), .X(SUM[7]) );
endmodule


module fixedpoint ( in1, in2, out );
  input [7:0] in1;
  input [7:0] in2;
  output [7:0] out;
  wire   N2, N3, N4, N5, N6, N7, N8, N9, n2;
  wire   [15:7] all_out;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3, 
        SYNOPSYS_UNCONNECTED__4, SYNOPSYS_UNCONNECTED__5, 
        SYNOPSYS_UNCONNECTED__6;

  fixedpoint_DW_mult_uns_0 mult_7 ( .a(in1), .b(in2), .product({all_out, 
        SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3, 
        SYNOPSYS_UNCONNECTED__4, SYNOPSYS_UNCONNECTED__5, 
        SYNOPSYS_UNCONNECTED__6}) );
  fixedpoint_DW01_inc_0 add_11 ( .A(all_out[15:8]), .SUM({N9, N8, N7, N6, N5, 
        N4, N3, N2}) );
  SAEDRVT14_INV_S_1 U11 ( .A(all_out[7]), .X(n2) );
  SAEDRVT14_AO22_1 U12 ( .A1(all_out[8]), .A2(n2), .B1(N2), .B2(all_out[7]), 
        .X(out[0]) );
  SAEDRVT14_AO22_1 U13 ( .A1(all_out[9]), .A2(n2), .B1(N3), .B2(all_out[7]), 
        .X(out[1]) );
  SAEDRVT14_AO22_1 U14 ( .A1(all_out[10]), .A2(n2), .B1(N4), .B2(all_out[7]), 
        .X(out[2]) );
  SAEDRVT14_AO22_1 U15 ( .A1(all_out[11]), .A2(n2), .B1(N5), .B2(all_out[7]), 
        .X(out[3]) );
  SAEDRVT14_AO22_1 U16 ( .A1(all_out[12]), .A2(n2), .B1(N6), .B2(all_out[7]), 
        .X(out[4]) );
  SAEDRVT14_AO22_1 U17 ( .A1(all_out[13]), .A2(n2), .B1(N7), .B2(all_out[7]), 
        .X(out[5]) );
  SAEDRVT14_AO22_1 U18 ( .A1(all_out[15]), .A2(n2), .B1(all_out[7]), .B2(N9), 
        .X(out[7]) );
  SAEDRVT14_AO22_1 U19 ( .A1(all_out[14]), .A2(n2), .B1(N8), .B2(all_out[7]), 
        .X(out[6]) );
endmodule

