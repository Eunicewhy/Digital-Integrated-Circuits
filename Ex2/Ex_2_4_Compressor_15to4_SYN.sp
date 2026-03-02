*ex2.4
.protect
.include '7nm_TT.pm'
.include 'asap7sc7p5t_OA_RVT.sp'
.include 'asap7sc7p5t_SIMPLE_RVT.sp'
.include 'asap7sc7p5t_AO_RVT.sp'
.include 'asap7sc7p5t_INVBUF_RVT.sp'
.include 'asap7sc7p5t_SEQ_RVT.sp'
.unprotect

.vec 'Ex2_4.vec'

.global VDD GND
VDD VDD GND 0.7
VSS VSS GND 0
.param Vdd = 0.7v 

.subckt inv_buffer vin vo
    XSINV0 GND VDD vin vx INVxp33_ASAP7_75t_R
    XSINV1 GND VDD vx vo INVxp33_ASAP7_75t_R
.ends

Xb0 x0 X[0] inv_buffer
Xb1 x1 X[1] inv_buffer
Xb2 x2 X[2] inv_buffer
Xb3 x3 X[3] inv_buffer
Xb4 x4 X[4] inv_buffer
Xb5 x5 X[5] inv_buffer
Xb6 x6 X[6] inv_buffer
Xb7 x7 X[7] inv_buffer
Xb8 x8 X[8] inv_buffer
Xb9 x9 X[9] inv_buffer
Xb10 x10 X[10] inv_buffer
Xb11 x11 X[11] inv_buffer
Xb12 x12 X[12] inv_buffer
Xb13 x13 X[13] inv_buffer
Xb14 x14 X[14] inv_buffer

.SUBCKT Compressor_15to4 VSS VDD  X[14] X[13] X[12] X[11] X[10] X[9] X[8] X[7] X[6] X[5] X[4] X[3] X[2] X[1] X[0] CPRS[3] CPRS[2] CPRS[1] CPRS[0]
XU27 VSS VDD  n34 n38 n35 XOR2xp5_ASAP7_75t_R
XU28 VSS VDD  X[3] X[5] n33 XOR2x1_ASAP7_75t_R
XU29 VSS VDD  X[0] X[2] n32 XNOR2xp5_ASAP7_75t_R
XU30 VSS VDD  X[1] n32 n29 XNOR2xp5_ASAP7_75t_R
XU31 VSS VDD  n24 n46 n37 XNOR2xp5_ASAP7_75t_R
XU32 VSS VDD  n27 n39 n38 n22 MAJIxp5_ASAP7_75t_R
XU33 VSS VDD  X[4] n33 n38 XNOR2x1_ASAP7_75t_R
XU34 VSS VDD  n27 n39 n38 n48 MAJx2_ASAP7_75t_R
XU35 VSS VDD  X[0] X[2] X[1] n23 MAJx2_ASAP7_75t_R
XU36 VSS VDD  X[0] X[2] X[1] n24 MAJIxp5_ASAP7_75t_R
XU37 VSS VDD  X[3] X[5] X[4] n25 MAJIxp5_ASAP7_75t_R
XU38 VSS VDD  X[3] X[5] X[4] n26 MAJx2_ASAP7_75t_R
XU39 VSS VDD  X[1] n32 n27 XOR2xp5_ASAP7_75t_R
XU40 VSS VDD  n29 n35 n28 XNOR2xp5_ASAP7_75t_R
XU41 VSS VDD  X[9] X[11] X[10] n31 MAJx2_ASAP7_75t_R
XU42 VSS VDD  X[12] X[14] X[13] n30 MAJIxp5_ASAP7_75t_R
XU43 VSS VDD  X[12] X[14] X[13] n44 MAJx2_ASAP7_75t_R
XU44 VSS VDD  X[9] X[11] X[10] A0  n41 FAx1_ASAP7_75t_R
XU45 VSS VDD  X[6] X[8] X[7] A1  n40 FAx1_ASAP7_75t_R
XU46 VSS VDD  X[12] X[14] X[13] A2  n34 FAx1_ASAP7_75t_R
XU47 VSS VDD  n29 n35 n42 XNOR2xp5_ASAP7_75t_R
XU48 VSS VDD  n41 n40 n28 A3  CPRS[0] FAx1_ASAP7_75t_R
XU49 VSS VDD  X[9] X[11] X[10] n46 MAJIxp5_ASAP7_75t_R
XU50 VSS VDD  X[6] X[8] X[7] n43 MAJIxp5_ASAP7_75t_R
XU51 VSS VDD  n25 n30 n43 A4  n36 FAx1_ASAP7_75t_R
XU52 VSS VDD  n37 n36 n49 XNOR2xp5_ASAP7_75t_R
XU53 VSS VDD  X[12] X[14] X[13] A5  n39 FAx1_ASAP7_75t_R
XU54 VSS VDD  n42 n41 n40 n50 MAJIxp5_ASAP7_75t_R
XU55 VSS VDD  n49 n48 n50 A6  CPRS[1] FAx1_ASAP7_75t_R
XU56 VSS VDD  n24 n46 n43 A7  n45 FAx1_ASAP7_75t_R
XU57 VSS VDD  n26 n45 n44 n52 MAJIxp5_ASAP7_75t_R
XU58 VSS VDD  X[6] X[8] X[7] n47 MAJx2_ASAP7_75t_R
XU59 VSS VDD  n23 n31 n47 n51 MAJIxp5_ASAP7_75t_R
XU60 VSS VDD  n50 n49 n22 n53 MAJIxp5_ASAP7_75t_R
XU61 VSS VDD  n52 n51 n53 A8  CPRS[2] FAx1_ASAP7_75t_R
XU62 VSS VDD  n53 n52 n51 CPRS[3] MAJIxp5_ASAP7_75t_R
.ENDS

X0 VSS VDD  X[14] X[13] X[12] X[11] X[10] X[9] X[8] X[7] X[6] X[5] X[4] X[3] X[2] X[1] X[0] CPRS[3] CPRS[2] CPRS[1] CPRS[0] Compressor_15to4

C0 CPRS[0] GND 5f
C1 CPRS[1] GND 5f
C2 CPRS[2] GND 5f
C3 CPRS[3] GND 5f

* .meas tran pwr avg POWER 
.measure TRAN t0 TRIG V(X[8])    VAL=0.35  FALL=1 TARG V(CPRS[2]) VAL=0.35  FALL=1
.measure TRAN t1 TRIG V(X[8])    VAL=0.35  FALL=2 TARG V(CPRS[2]) VAL=0.35  FALL=2
.measure TRAN t2 TRIG V(X[8])    VAL=0.35  FALL=3 TARG V(CPRS[2]) VAL=0.35  FALL=4
.measure TRAN t3 TRIG V(X[8])    VAL=0.35  FALL=4 TARG V(CPRS[2]) VAL=0.35  FALL=5
.measure TRAN t4 TRIG V(X[8])    VAL=0.35  FALL=7 TARG V(CPRS[2]) VAL=0.35  FALL=14


.measure tran Worst_case_delay  param='max(t0, t1, t2, t3, t4)'

*Vx0  x0  0  PULSE(0 Vdd 0.1ns 0.1ps 0.1ps 0.1ns 0.2ns)
*Vx1  x1  0  PULSE(0 Vdd 0.2ns 0.1ps 0.1ps 0.2ns 0.4ns)
*Vx2  x2  0  PULSE(0 Vdd 0.4ns 0.1ps 0.1ps 0.4ns 0.8ns)
*Vx3  x3  0  PULSE(0 Vdd 0.8ns 0.1ps 0.1ps 0.8ns 1.6ns)
*Vx4  x4  0  PULSE(0 Vdd 1.6ns 0.1ps 0.1ps 1.6ns 3.2ns)
*Vx5  x5  0  PULSE(0 Vdd 3.2ns 0.1ps 0.1ps 3.2ns 6.4ns)
*Vx6  x6  0  PULSE(0 Vdd 6.4ns 0.1ps 0.1ps 6.4ns 12.8ns)
*Vx7  x7  0  PULSE(0 Vdd 12.8ns 0.1ps 0.1ps 12.8ns 25.6ns)
*Vx8  x8  0  PULSE(0 Vdd 25.6ns 0.1ps 0.1ps 25.6ns 51.2ns)
*Vx9  x9  0  PULSE(0 Vdd 51.2ns 0.1ps 0.1ps 51.2ns 102.8ns)
*Vx10 x10 0  PULSE(0 Vdd 102.8ns 0.1ps 0.1ps 102.8ns 205.6ns)
*Vx11 x11 0  PULSE(0 Vdd 205.6ns 0.1ps 0.1ps 205.6ns 504.2ns)
*Vx12 x12 0  PULSE(0 Vdd 504.2ns 0.1ps 0.1ps 504.2ns 1000.84ns)
*Vx13 x13 0  PULSE(0 Vdd 1008.4ns 0.1ps 0.1ps 1000.84ns 2016.8ns)
*Vx14 x14 0  PULSE(0 Vdd 2016.8ns 0.1ps 0.1ps 2016.8ns 5033.6ns)

.tran 0.001ps 15ns
* .meas tran pwr1 avg power from=10.0071n to=10.1860n
.meas tran pwr1 avg power from=0n to=10n


* Simulator Setting
.option post 
.options probe	
.probe v(*) i(*)
.option captab	
.TEMP 25

.op

.end



