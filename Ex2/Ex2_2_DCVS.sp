.TITLE Ex2_2_DCVS

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

.subckt inv_buffer vin vo
    XSINV0 GND VDD vin vx INVxp33_ASAP7_75t_R
    XSINV1 GND VDD vx vo INVxp33_ASAP7_75t_R
.ends

.subckt DCVS_FA A B Cin S_out C_out
    Xbuf0 A A_buf  inv_buffer
    Xbuf1 B B_buf  inv_buffer

    Xinv0 A_buf A_inv  inverter
    Xinv1 B_buf B_inv  inverter
    Xinv2 Cin Cin_inv  inverter

    MpC0 C_out C_out_inv VDD VDD pmos_rvt  nfin=1
    MpC1 C_out_inv C_out VDD VDD pmos_rvt  nfin=1

    MnC0 C_out_inv B_buf  WC0 WC0 nmos_rvt  nfin=6
    MnC1 C_out_inv A_buf  WC1 WC1 nmos_rvt  nfin=6
    MnC2 C_out     A_inv  WC2 WC2 nmos_rvt  nfin=6
    MnC3 C_out     B_inv  WC3 WC3 nmos_rvt  nfin=6

    MnC4 WC0 Cin     GND GND nmos_rvt  nfin=6
    MnC5 WC1 B_buf   GND GND nmos_rvt  nfin=6
    MnC6 WC1 Cin     GND GND nmos_rvt  nfin=6
    MnC7 WC2 Cin_inv GND GND nmos_rvt  nfin=6
    MnC8 WC2 B_inv   GND GND nmos_rvt  nfin=6
    MnC9 WC3 Cin_inv GND GND nmos_rvt  nfin=6

    MpS0 S_out     S_out_inv VDD VDD pmos_rvt  nfin=1
    MpS1 S_out_inv S_out     VDD VDD pmos_rvt  nfin=1

    MnS0 S_out_inv A_buf WS0 WS0 nmos_rvt nfin=6
    MnS1 S_out_inv A_inv WS1 WS1 nmos_rvt nfin=6
    MnS2 S_out     A_inv WS0 WS0 nmos_rvt nfin=6
    MnS3 S_out     A_buf WS1 WS1 nmos_rvt nfin=6

    MnS4 WS0  B_buf WS2 WS2 nmos_rvt nfin=6
    MnS5 WS0  B_inv WS3 WS3 nmos_rvt nfin=6
    MnS6 WS1  B_inv WS2 WS2 nmos_rvt nfin=6
    MnS7 WS1  B_buf WS3 WS3 nmos_rvt nfin=6

    MnS8 WS2  Cin     GND GND nmos_rvt nfin=6
    MnS9 WS3  Cin_inv GND GND nmos_rvt nfin=6
.ends

XbufCin0 Cin0 Cin0_buf inv_buffer
XFA0 A0 B0 Cin0_buf Sum0 Cin1 DCVS_FA
XFA1 A1 B1 Cin1 Sum1 Cin2 DCVS_FA
XFA2 A2 B2 Cin2 Sum2 Cin3 DCVS_FA
XFA3 A3 B3 Cin3 Sum3 Sum4 DCVS_FA

C0 Sum0 GND 5f
C1 Sum1 GND 5f
C2 Sum2 GND 5f
C3 Sum3 GND 5f
C4 Sum4 GND 5f

.tran 0.1ns 50ns 0.01ns
.meas tran pwr avg POWER 
.measure TRAN T_Delay0 TRIG V(B0)  VAL=0.35 RISE=4 TARG V(Sum3) VAL=0.35 RISE=11
.measure TRAN T_Delay1 TRIG V(B0)  VAL=0.35 FALL=5 TARG V(Sum3) VAL=0.35 FALL=12

.option post 
.options probe	
.probe v(*) i(*)
.option captab	
.TEMP 25

.op

.end

