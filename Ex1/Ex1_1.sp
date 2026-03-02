*ex1.1*
.include '16mos.pm'
.temp 25
.global VDD GND

.param supply=0.7v 
.param wp=32n
.param wn=32n 


VDD VDD GND supply
Vgsp Vgsp VDD 0v
Vgsn Vgsn GND 0v

MP0 GND Vgsp VDD VDD pmos W=wp L=16n M=1.0   
MN0 VDD Vgsn GND GND nmos W=wn L=16n M=1.0

.DC Vgsp 0 -0.7v -0.001v
.DC Vgsn 0 0.7v 0.001v

.PRINT DC I(MN0) -I(MP0)
.option post=1

.end