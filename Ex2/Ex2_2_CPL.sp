.TITLE Ex2_2_CPL

.protect
.include '7nm_TT.pm'
.include 'asap7sc7p5t_INVBUF_RVT.sp'

.unprotect
.vec 'Ex2_2.vec'

.global VDD GND
VDD VDD GND 0.7

.subckt inv_buffer vin vo
    XSINV0 GND VDD vin vx INVxp33_ASAP7_75t_R
    XSINV1 GND VDD vx vo INVxp33_ASAP7_75t_R
.ends

.subckt inverter in out
	Mp  out  in  VDD  x  pmos_rvt  nfin=1
	Mn  out  in  GND  x  nmos_rvt  nfin=1
.ends

.subckt CPL_FA A B Cin  S_out C_out
    Xbuf0 A A_buf inv_buffer
    Xbuf1 B B_buf inv_buffer

    Xinv0 A_buf A_inv  inverter
    Xinv1 B_buf B_inv  inverter
    Xinv2 Cin Cin_inv  inverter

    Mn1  W1  A_buf   B_inv B_inv nmos_rvt nfin=1  
    Mn2  W1  A_inv   B_buf B_buf nmos_rvt nfin=1 
    Mn3  W2  Cin_inv W1    W1    nmos_rvt nfin=1  
    Mn4  W2  Cin     W3    W3    nmos_rvt nfin=1 
    Mn5  W3  A_buf   B_buf B_buf nmos_rvt nfin=1 
    Mn6  W3  A_inv   B_inv B_inv nmos_rvt nfin=1 
    Mn7  W4  Cin     W1    W1    nmos_rvt nfin=1 
    Mn8  W4  Cin_inv W3    W3    nmos_rvt nfin=1 

    Mn9  W5  A_buf   B_buf B_buf nmos_rvt nfin=1 
    Mn10 W5  A_inv   GND   GND   nmos_rvt nfin=1 
    Mn11 W6  Cin_inv W5    W5    nmos_rvt nfin=1 
    Mn12 W7  A_buf   VDD   VDD   nmos_rvt nfin=1 
    Mn13 W7  A_inv   B_buf B_buf nmos_rvt nfin=1 
    Mn14 W6  Cin     W7    W7    nmos_rvt nfin=1 
    Mn15 W8  A_buf   GND   GND   nmos_rvt nfin=1 
    Mn16 W8  A_inv   B_inv B_inv nmos_rvt nfin=1 
    Mn17 W9  Cin     W8    W8    nmos_rvt nfin=1 
    Mn18 W10 A_buf   B_inv B_inv nmos_rvt nfin=1 
    Mn19 W10 A_inv   VDD   VDD   nmos_rvt nfin=1 
    Mn20 W9  Cin_inv W10   W10   nmos_rvt nfin=1 

    Mp1 VDD W4 W2 W2 pmos_rvt nfin=1
    Mp2 VDD W2 W4 W4 pmos_rvt nfin=1
    Mp3 VDD W9 W6 W6 pmos_rvt nfin=1
    Mp4 VDD W6 W9 W9 pmos_rvt nfin=1

    Xinv_W2 W2 S_out_inv inverter
    Xinv_W4 W4 S_out     inverter
    Xinv_W6 W6 C_out_inv inverter
    Xinv_W9 W9 C_out     inverter
.ends

XbufCin0 Cin0 Cin0_buf inv_buffer
XFA0 A0 B0 Cin0_buf Sum0 Cin1 CPL_FA
XFA1 A1 B1 Cin1 Sum1 Cin2 CPL_FA
XFA2 A2 B2 Cin2 Sum2 Cin3 CPL_FA
XFA3 A3 B3 Cin3 Sum3 Sum4 CPL_FA

C0 Sum0 GND 5f
C1 Sum1 GND 5f
C2 Sum2 GND 5f
C3 Sum3 GND 5f
C4 Sum4 GND 5f

.tran 0.01ns 50ns 0.01ns
.meas tran pwr avg POWER 
.measure TRAN T_Delay_0 TRIG V(A0)  VAL=0.35 RISE=4 TARG V(Sum4) VAL=0.35 RISE=4
.measure TRAN T_Delay_1 TRIG V(B0)  VAL=0.35 RISE=4 TARG V(Sum3) VAL=0.35 RISE=9

.option post 
.options probe	
.probe v(*) i(*)
.option captab	
.TEMP 25

.op

.end

