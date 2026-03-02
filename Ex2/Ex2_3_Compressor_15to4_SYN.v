/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : P-2019.03-SP1-1
// Date      : Tue Oct 14 00:32:43 2025
/////////////////////////////////////////////////////////////


module Compressor_15to4 ( X, CPRS );
  input [14:0] X;
  output [3:0] CPRS;
  wire   n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53;

  XOR2xp5_ASAP7_75t_R U27 ( .A(n34), .B(n38), .Y(n35) );
  XOR2x1_ASAP7_75t_R U28 ( .A(X[3]), .B(X[5]), .Y(n33) );
  XNOR2xp5_ASAP7_75t_R U29 ( .A(X[0]), .B(X[2]), .Y(n32) );
  XNOR2xp5_ASAP7_75t_R U30 ( .A(X[1]), .B(n32), .Y(n29) );
  XNOR2xp5_ASAP7_75t_R U31 ( .A(n24), .B(n46), .Y(n37) );
  MAJIxp5_ASAP7_75t_R U32 ( .A(n27), .B(n39), .C(n38), .Y(n22) );
  XNOR2x1_ASAP7_75t_R U33 ( .A(X[4]), .B(n33), .Y(n38) );
  MAJx2_ASAP7_75t_R U34 ( .A(n27), .B(n39), .C(n38), .Y(n48) );
  MAJx2_ASAP7_75t_R U35 ( .A(X[0]), .B(X[2]), .C(X[1]), .Y(n23) );
  MAJIxp5_ASAP7_75t_R U36 ( .A(X[0]), .B(X[2]), .C(X[1]), .Y(n24) );
  MAJIxp5_ASAP7_75t_R U37 ( .A(X[3]), .B(X[5]), .C(X[4]), .Y(n25) );
  MAJx2_ASAP7_75t_R U38 ( .A(X[3]), .B(X[5]), .C(X[4]), .Y(n26) );
  XOR2xp5_ASAP7_75t_R U39 ( .A(X[1]), .B(n32), .Y(n27) );
  XNOR2xp5_ASAP7_75t_R U40 ( .A(n29), .B(n35), .Y(n28) );
  MAJx2_ASAP7_75t_R U41 ( .A(X[9]), .B(X[11]), .C(X[10]), .Y(n31) );
  MAJIxp5_ASAP7_75t_R U42 ( .A(X[12]), .B(X[14]), .C(X[13]), .Y(n30) );
  MAJx2_ASAP7_75t_R U43 ( .A(X[12]), .B(X[14]), .C(X[13]), .Y(n44) );
  FAx1_ASAP7_75t_R U44 ( .A(X[9]), .B(X[11]), .CI(X[10]), .SN(n41) );
  FAx1_ASAP7_75t_R U45 ( .A(X[6]), .B(X[8]), .CI(X[7]), .SN(n40) );
  FAx1_ASAP7_75t_R U46 ( .A(X[12]), .B(X[14]), .CI(X[13]), .SN(n34) );
  XNOR2xp5_ASAP7_75t_R U47 ( .A(n29), .B(n35), .Y(n42) );
  FAx1_ASAP7_75t_R U48 ( .A(n41), .B(n40), .CI(n28), .SN(CPRS[0]) );
  MAJIxp5_ASAP7_75t_R U49 ( .A(X[9]), .B(X[11]), .C(X[10]), .Y(n46) );
  MAJIxp5_ASAP7_75t_R U50 ( .A(X[6]), .B(X[8]), .C(X[7]), .Y(n43) );
  FAx1_ASAP7_75t_R U51 ( .A(n25), .B(n30), .CI(n43), .SN(n36) );
  XNOR2xp5_ASAP7_75t_R U52 ( .A(n37), .B(n36), .Y(n49) );
  FAx1_ASAP7_75t_R U53 ( .A(X[12]), .B(X[14]), .CI(X[13]), .SN(n39) );
  MAJIxp5_ASAP7_75t_R U54 ( .A(n42), .B(n41), .C(n40), .Y(n50) );
  FAx1_ASAP7_75t_R U55 ( .A(n49), .B(n48), .CI(n50), .SN(CPRS[1]) );
  FAx1_ASAP7_75t_R U56 ( .A(n24), .B(n46), .CI(n43), .SN(n45) );
  MAJIxp5_ASAP7_75t_R U57 ( .A(n26), .B(n45), .C(n44), .Y(n52) );
  MAJx2_ASAP7_75t_R U58 ( .A(X[6]), .B(X[8]), .C(X[7]), .Y(n47) );
  MAJIxp5_ASAP7_75t_R U59 ( .A(n23), .B(n31), .C(n47), .Y(n51) );
  MAJIxp5_ASAP7_75t_R U60 ( .A(n50), .B(n49), .C(n22), .Y(n53) );
  FAx1_ASAP7_75t_R U61 ( .A(n52), .B(n51), .CI(n53), .SN(CPRS[2]) );
  MAJIxp5_ASAP7_75t_R U62 ( .A(n53), .B(n52), .C(n51), .Y(CPRS[3]) );
endmodule

