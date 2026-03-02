*ex2.1*
.include '7nm_TT.pm'
.include 'asap7sc7p5t_INVBUF_RVT.sp'
.temp 25
.global VDD GND

.param supply = 0.7v 
VDD VDD GND DC supply
VIN A 0 DC 0

XINV GND VDD A Y INVxp33_ASAP7_75t_R

.DC VIN 0 0.7 0.001



.PRINT DC V(A) V(Y)
.PLOT DC V(A) V(Y)
.option post=1

.alter 1
.param supply=0.6
.alter 2
.param supply=0.5
.alter 3
.param supply=0.4

.end