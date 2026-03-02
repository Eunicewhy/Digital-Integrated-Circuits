*ex1.2*
.include '7nm_TT.pm'
.temp 25
.global VDD GND

.param supply = 0.7v 

VDD VDD GND supply
Vgsp Vgsp VDD 0v
Vgsn Vgsn GND 0v

MP0 GND Vgsp VDD VDD pmos_rvt nf = 1 nfin = 1
MN0 VDD Vgsn GND GND nmos_rvt nf = 1 nfin = 1

.DC Vgsp 0 -0.7v -0.001v
.DC Vgsn 0 0.7v 0.001v

.PRINT DC I(MN0) -I(MP0)
.option post=1

.end