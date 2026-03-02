.TITLE Ex2_2_CMOS

.protect
.include '7nm_TT.pm'
.include 'asap7sc7p5t_INVBUF_RVT.sp'

.unprotect
.vec 'Ex2_2.vec'

.global VDD GND
VDD VDD GND 0.7

.subckt inverter in out
	Mp  out  in  VDD  x  pmos_rvt  nfin=1
	Mn  out  in  GND  x  nmos_rvt  nfin=1
.ends

.subckt CMOS_NAND A B out 
    Mp0  out      A      VDD    x  pmos_rvt nfin=1
    Mp1  out      B      VDD    x  pmos_rvt nfin=1

    Mn0  out      A      W0  x  nmos_rvt nfin=1
    Mn1  W0    B      GND    x  nmos_rvt nfin=1
.ends

.subckt CMOS_XOR A A_inv B B_inv out 
    Mp0  W0    A_inv  VDD  x  pmos_rvt  nfin=1
    Mp1  out   B      W0   x  pmos_rvt  nfin=1
    Mp2  W1    A      VDD  x  pmos_rvt  nfin=1
    Mp3  out   B_inv  W1   x  pmos_rvt  nfin=1

    Mn0  W2   B_inv  GND x  nmos_rvt  nfin=1
    Mn1  out  A_inv  W2  x  nmos_rvt  nfin=1
    Mn2  W3   B      GND x  nmos_rvt  nfin=1
    Mn3  out  A      W3  x  nmos_rvt  nfin=1
.ends

.subckt inv_buffer vin vo
    XSINV0 GND VDD vin vx INVxp33_ASAP7_75t_R
    XSINV1 GND VDD vx vo INVxp33_ASAP7_75t_R
.ends

.subckt CMOS_FA A B Cin S_out C_out
    Xbuf0 A A_buf inv_buffer
    Xbuf1 B B_buf inv_buffer

    Xinv0 A_buf A_inv  inverter
    Xinv1 B_buf B_inv  inverter
    Xinv2 Cin Cin_inv  inverter

    XXOR0 A_buf A_inv  B_buf    B_inv   W0    CMOS_XOR
    XINV  W0    W0_inv inverter
    XXOR1 W0    W0_inv Cin      Cin_inv S_out CMOS_XOR

    XNAND0 A_buf B_buf W1    CMOS_NAND
    XNAND1 W0    Cin   W2    CMOS_NAND
    XNAND2 W1    W2    C_out CMOS_NAND
.ends

XbufCin0 Cin0 Cin0_buf inv_buffer
XFA0 A0 B0 Cin0_buf Sum0 Cin1 CMOS_FA
XFA1 A1 B1 Cin1 Sum1 Cin2 CMOS_FA
XFA2 A2 B2 Cin2 Sum2 Cin3 CMOS_FA
XFA3 A3 B3 Cin3 Sum3 Sum4 CMOS_FA


C0 Sum0 GND 5f
C1 Sum1 GND 5f
C2 Sum2 GND 5f
C3 Sum3 GND 5f
C4 Sum4 GND 5f


.tran 0.01ns 50ns 0.01ns
.meas tran pwr avg POWER 
.measure TRAN T_Delay_0 TRIG V(A0)  VAL=0.35 RISE=4 TARG V(Sum4) VAL=0.35 RISE=4

.option post 
.options probe	
.probe v(*) i(*)
.option captab	
.TEMP 25

.op

.end

