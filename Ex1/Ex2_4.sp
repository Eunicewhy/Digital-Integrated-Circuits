*ex2.4*
.TITLE inverter_TA
.include '7nm_TT.pm'
.temp 25
.global VDD GND

.param pn = 4
.param nn = 3

VDD VDD GND 0.7v
Vin Vin GND 0.7v
VSS VSS GND 0v

.subckt inv vin vout vdd vss
MP1 vout vin vdd vdd pmos_rvt nfin=pn
MN1 vout vin vss vss nmos_rvt nfin=nn
.ends

XM0 Vin Vout VDD VSS inv

.DC Vin 0 0.7 0.001

.PRINT DC V(Vin) V(Vout)
.option post=1

.end
