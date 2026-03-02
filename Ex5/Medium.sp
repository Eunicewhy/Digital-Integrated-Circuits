*Medium*
.include '7nm_TT.pm'
.temp 25
.global VDD GND

.param Vdd = 0.7v 

VDD VDD GND Vdd
VSS VSS GND 0

.protect
.include 'asap7sc7p5t_SIMPLE_RVT.sp'
.include 'buffer.sp'
.unprotect
.vec 'Ex5_1.vec'

XBUF0  IN_0[0] IN0_0 buffer
XBUF1  IN_0[1] IN0_1 buffer
XBUF2  IN_1[0] IN1_0 buffer
XBUF3  IN_1[1] IN1_1 buffer
XBUF4  IN_2[0] IN2_0 buffer
XBUF5  IN_2[1] IN2_1 buffer
XBUF6  IN_3[0] IN3_0 buffer
XBUF7  IN_3[1] IN3_1 buffer

XMed0 VSS VDD IN0_1 IN0_0 IN1_1 IN1_0 IN2_1 IN2_0 IN3_1 IN3_0 Output[1] Output[0] Medium

Cout0 Output[0] GND 0.001f
Cout1 Output[1] GND 0.001f


.SUBCKT Medium VSS VDD  IN_0[1] IN_0[0] IN_1[1] IN_1[0] IN_2[1] IN_2[0] IN_3[1] IN_3[0] OUT[1] OUT[0]
  XU20 VSS VDD  n22 n21 n23 NAND2xp33_ASAP7_75t_R
  XU21 VSS VDD  IN_3[0] IN_2[0] n24 NAND2xp33_ASAP7_75t_R
  XU22 VSS VDD  n25 IN_3[0] IN_2[0] n19 NAND3xp33_ASAP7_75t_R
  XU23 VSS VDD  IN_3[1] IN_2[1] n20 NAND2xp33_ASAP7_75t_R
  XU24 VSS VDD  n20 n19 n31 AND2x2_ASAP7_75t_R
  XU25 VSS VDD  n20 n19 OUT[1] NAND2xp33_ASAP7_75t_R
  XU26 VSS VDD  IN_3[1] IN_2[1] n25 XOR2xp5_ASAP7_75t_R
  XU27 VSS VDD  IN_1[0] IN_0[0] n26 AND2x2_ASAP7_75t_R
  XU28 VSS VDD  IN_1[1] n26 n22 OR2x2_ASAP7_75t_R
  XU29 VSS VDD  IN_1[1] IN_1[0] IN_0[0] n21 NAND3xp33_ASAP7_75t_R
  XU30 VSS VDD  n23 IN_0[1] n30 XOR2xp5_ASAP7_75t_R
  XU31 VSS VDD  n25 n24 n29 XOR2xp5_ASAP7_75t_R
  XU32 VSS VDD  n31 IN_1[1] IN_0[1] n27 MAJx2_ASAP7_75t_R
  XU33 VSS VDD  n31 n27 n26 n28 MAJx2_ASAP7_75t_R
  XU34 VSS VDD  n30 n29 n28 OUT[0] MAJIxp5_ASAP7_75t_R
.ENDS


*****************************
**      Measurement        **
*****************************
.tran 0.01ps 50ns 
.meas TRAN delay  TRIG V(IN_2[1]) VAL=Vdd/2 RISE=1 TARG V(Output[0]) VAL=Vdd/2 RISE=1
.meas tran pwr avg POWER 

*** 
*****************************
**    Simulator setting    **
*****************************
.option post 
.options probe
.probe v(*) i(*)
.option captab	
.op
.end
