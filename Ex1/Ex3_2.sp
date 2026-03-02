*ex3.2*
.include '7nm_TT.pm'
.include 'asap7sc7p5t_INVBUF_RVT.sp'
.include 'asap7sc7p5t_SIMPLE_RVT.sp'
.temp 25
.global VDD GND

.param Vdd = 0.7v 

VDD VDD GND Vdd

* Largest Inverter *
* Input Buffer (Smallest Inverter)
XSINV0 GND VDD A_inv x_buffer0 INVxp33_ASAP7_75t_R
XSINV1 GND VDD x_buffer0 x_buffer_1 INVxp33_ASAP7_75t_R

* Largest Inverter
XLINV0 GND VDD x_buffer_1 x_inv INVx11_ASAP7_75t_R

* FO4
XFINV0 GND VDD x_inv Y_inv INVxp33_ASAP7_75t_R
XFINV1 GND VDD x_inv Y_inv INVxp33_ASAP7_75t_R
XFINV2 GND VDD x_inv Y_inv INVxp33_ASAP7_75t_R
XFINV3 GND VDD x_inv Y_inv INVxp33_ASAP7_75t_R

* Capacitance
CL0 x_inv 0 5f

Vin0 A_inv 0 PULSE(0 Vdd 0n 10p 10p 0.5n 1n)

* measures
.meas tran Trise_inv TRIG V(x_inv) VAL='0.1*Vdd' RISE=1 
+                TARG V(x_inv) VAL='0.9*Vdd' RISE=1
.meas tran Tfall_inv TRIG V(x_inv) VAL='0.9*Vdd' FALL=1 
+                TARG V(x_inv) VAL='0.1*Vdd' FALL=1
.meas tran Tplh_inv TRIG v(A_inv) VAL='0.5*Vdd' FALL=1 
+               TARG v(x_inv) VAL='0.5*Vdd' RISE=1
.meas tran Tphl_inv TRIG v(A_inv) VAL='0.5*Vdd' RISE=2
+               TARG v(x_inv) VAL='0.5*Vdd' FALL=2


* Largest NAND2 *
* Input Buffer (Smallest Inverter)
XSINV2 GND VDD A_nand x_buffer2 INVxp33_ASAP7_75t_R
XSINV3 GND VDD x_buffer2 x_buffer_A INVxp33_ASAP7_75t_R
XSINV4 GND VDD B_nand x_buffer3 INVxp33_ASAP7_75t_R
XSINV5 GND VDD x_buffer3 x_buffer_B INVxp33_ASAP7_75t_R

* Largest NAND2
XLNAND2 GND VDD x_buffer_B x_buffer_A x_nand NAND2x2_ASAP7_75t_R

* FO4
XFINV4 GND VDD x_nand Y_nand INVxp33_ASAP7_75t_R
XFINV5 GND VDD x_nand Y_nand INVxp33_ASAP7_75t_R
XFINV6 GND VDD x_nand Y_nand INVxp33_ASAP7_75t_R
XFINV7 GND VDD x_nand Y_nand INVxp33_ASAP7_75t_R

* Capacitance
CL1 x_nand 0 5f

* stimulus: f = 1 GHz
Vin1 A_nand 0 PULSE(0 Vdd 0n 10p 10p 0.5n 1n)
Vin2 B_nand 0 PULSE(0 Vdd 0.25n 10p 10p 0.5n 1n)


* measures
.meas tran Trise_nand TRIG V(x_nand) VAL='0.1*Vdd' RISE=1 
+                TARG V(x_nand) VAL='0.9*Vdd' RISE=1
.meas tran Tfall_nand TRIG V(x_nand) VAL='0.9*Vdd' FALL=1 
+                TARG V(x_nand) VAL='0.1*Vdd' FALL=1
.meas tran Tplh_nand TRIG v(A_nand) VAL='0.5*Vdd' FALL=1
+               TARG v(x_nand) VAL='0.5*Vdd' RISE=1
.meas tran Tphl_nand TRIG v(B_nand) VAL='0.5*Vdd' RISE=1 
+               TARG v(x_nand) VAL='0.5*Vdd' FALL=1


* transient simulation
.tran 0.01n 5n

.option post=1
.end
