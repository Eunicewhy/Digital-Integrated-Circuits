*****************************
**     Library setting     **
*****************************
.include '7nm_TT.pm'
.protect
.include 'asap7sc7p5t_SIMPLE_RVT.sp'
.include 'asap7sc7p5t_INVBUF_RVT.sp'
.unprotect

.VEC "Pattern_pe32_msb.vec"

.SUBCKT inverter in out
Mp1 out in VDD VDD pmos_rvt nfin=2
Mn1 out in GND GND nmos_rvt nfin=1
.ENDS

.SUBCKT inv_buffer in out
Xinv1 in mid inverter
Xinv2 mid out inverter
.ENDS


*****************************
**     Voltage Source      **
*****************************
.param supply = 0.7
.global VDD GND
Vvdd VDD GND supply
VSS VSS GND 0

XBUF0   in0   buff_in0   inv_buffer
XBUF1   in1   buff_in1   inv_buffer
XBUF2   in2   buff_in2   inv_buffer
XBUF3   in3   buff_in3   inv_buffer
XBUF4   in4   buff_in4   inv_buffer
XBUF5   in5   buff_in5   inv_buffer
XBUF6   in6   buff_in6   inv_buffer
XBUF7   in7   buff_in7   inv_buffer
XBUF8   in8   buff_in8   inv_buffer
XBUF9   in9   buff_in9   inv_buffer
XBUF10  in10  buff_in10  inv_buffer
XBUF11  in11  buff_in11  inv_buffer
XBUF12  in12  buff_in12  inv_buffer
XBUF13  in13  buff_in13  inv_buffer
XBUF14  in14  buff_in14  inv_buffer
XBUF15  in15  buff_in15  inv_buffer
XBUF16  in16  buff_in16  inv_buffer
XBUF17  in17  buff_in17  inv_buffer
XBUF18  in18  buff_in18  inv_buffer
XBUF19  in19  buff_in19  inv_buffer
XBUF20  in20  buff_in20  inv_buffer
XBUF21  in21  buff_in21  inv_buffer
XBUF22  in22  buff_in22  inv_buffer
XBUF23  in23  buff_in23  inv_buffer
XBUF24  in24  buff_in24  inv_buffer
XBUF25  in25  buff_in25  inv_buffer
XBUF26  in26  buff_in26  inv_buffer
XBUF27  in27  buff_in27  inv_buffer
XBUF28  in28  buff_in28  inv_buffer
XBUF29  in29  buff_in29  inv_buffer
XBUF30  in30  buff_in30  inv_buffer
XBUF31  in31  buff_in31  inv_buffer

CBUF0   buff_in0   GND  3f
CBUF1   buff_in1   GND  3f
CBUF2   buff_in2   GND  3f
CBUF3   buff_in3   GND  3f
CBUF4   buff_in4   GND  3f
CBUF5   buff_in5   GND  3f
CBUF6   buff_in6   GND  3f
CBUF7   buff_in7   GND  3f
CBUF8   buff_in8   GND  3f
CBUF9   buff_in9   GND  3f
CBUF10  buff_in10  GND  3f
CBUF11  buff_in11  GND  3f
CBUF12  buff_in12  GND  3f
CBUF13  buff_in13  GND  3f
CBUF14  buff_in14  GND  3f
CBUF15  buff_in15  GND  3f
CBUF16  buff_in16  GND  3f
CBUF17  buff_in17  GND  3f
CBUF18  buff_in18  GND  3f
CBUF19  buff_in19  GND  3f
CBUF20  buff_in20  GND  3f
CBUF21  buff_in21  GND  3f
CBUF22  buff_in22  GND  3f
CBUF23  buff_in23  GND  3f
CBUF24  buff_in24  GND  3f
CBUF25  buff_in25  GND  3f
CBUF26  buff_in26  GND  3f
CBUF27  buff_in27  GND  3f
CBUF28  buff_in28  GND  3f
CBUF29  buff_in29  GND  3f
CBUF30  buff_in30  GND  3f
CBUF31  buff_in31  GND  3f

XPE32 VSS VDD buff_in31 buff_in30 buff_in29 buff_in28 buff_in27 buff_in26 buff_in25 buff_in24 buff_in23 buff_in22 buff_in21 buff_in20 buff_in19 buff_in18 buff_in17 buff_in16 buff_in15 buff_in14 buff_in13 buff_in12 buff_in11 buff_in10 buff_in9 buff_in8 buff_in7 buff_in6 buff_in5 buff_in4 buff_in3 buff_in2 buff_in1 buff_in0 idx4 idx3 idx2 idx1 idx0 pe32_msb

cout0 idx0 GND 5f
cout1 idx1 GND 5f
cout2 idx2 GND 5f
cout3 idx3 GND 5f
cout4 idx4 GND 5f

.SUBCKT NAND5 VSS VDD a b c d e y
    XAND4 VSS VDD  b c d e p   AND4x2_ASAP7_75t_R
    XNAND VSS VDD  p a y       NAND2x2_ASAP7_75t_R
    Cwp p GND 3f
.ENDS

.SUBCKT pe32_msb VSS VDD  in[31] in[30] in[29] in[28] in[27] in[26] in[25] in[24] in[23] in[22] in[21] in[20] in[19] in[18] in[17] in[16] in[15] in[14] in[13] in[12] in[11] in[10] in[9] in[8] in[7] in[6] in[5] in[4] in[3] in[2] in[1] in[0] idx[4] idx[3] idx[2] idx[1] idx[0]
    XU1 VSS VDD  n31 n34 idx[3] NAND2xp5_ASAP7_75t_R
    XU2 VSS VDD  n37 n38 idx[2] NAND2xp5_ASAP7_75t_R
    XU3 VSS VDD  n32 n40 n39 NAND2xp5_ASAP7_75t_R
    XU4 VSS VDD  n33 n41 n40 NAND2xp5_ASAP7_75t_R
    XU72 VSS VDD  n31 n32 n33 idx[4] NAND3xp33_ASAP7_75t_R
    XU75 VSS VDD  n170 n169 n171 n37 n172 n31 AND5x1_ASAP7_75t_R
    XU76 VSS VDD  n170 n169 n171 n39 n172 n38 NAND5xp2_ASAP7_75t_R
    XU92 VSS VDD  in[4] in[5] n87 NOR2xp33_ASAP7_75t_R
    XU93 VSS VDD  in[16] n105 n107 NOR2xp33_ASAP7_75t_R
    XU94 VSS VDD  in[15] n104 n105 NOR2xp33_ASAP7_75t_R
    *XU95 VSS VDD  n111 in[10] in[8] n119 NOR3xp33_ASAP7_75t_R
    XU95 VSS VDD  n111 in[10] in[8] n119 NOR3x1_ASAP7_75t_R
    XU96 VSS VDD  in[7] n110 n111 NOR2xp33_ASAP7_75t_R
    XU97 VSS VDD  in[3] in[5] n114 NOR2xp33_ASAP7_75t_R
    XU98 VSS VDD  in[19] in[15] in[18] in[14] n159 NOR4xp25_ASAP7_75t_R
    XU99 VSS VDD  in[31] in[30] n166 NOR2xp33_ASAP7_75t_R
    XU100 VSS VDD  in[10] n147 n89 NOR2xp33_ASAP7_75t_R
    XU101 VSS VDD  in[16] in[17] in[18] in[19] n33 NOR4xp25_ASAP7_75t_R
    XU102 VSS VDD  in[12] in[13] in[14] in[15] n36 NOR4xp25_ASAP7_75t_R
    XU103 VSS VDD  in[28] in[29] in[30] in[31] n37 NOR4xp25_ASAP7_75t_R
    XU104 VSS VDD  n142 n141 in[29] in[28] n165 NOR4xp25_ASAP7_75t_R
    XU105 VSS VDD  n140 n143 n142 NOR2xp33_ASAP7_75t_R
    XU106 VSS VDD  in[21] in[20] n140 NOR2xp33_ASAP7_75t_R
    XU107 VSS VDD  in[8] n151 n92 NOR2xp33_ASAP7_75t_R
    XU108 VSS VDD  in[20] in[21] in[22] in[23] n32 NOR4xp25_ASAP7_75t_R
    XU109 VSS VDD  in[18] in[20] n127 NOR2xp33_ASAP7_75t_R
    XU110 VSS VDD  in[26] n170 INVx1_ASAP7_75t_R
    XU111 VSS VDD  in[27] n169 INVx1_ASAP7_75t_R
    XU112 VSS VDD  in[25] n171 INVx1_ASAP7_75t_R
    XU113 VSS VDD  in[24] n172 INVx1_ASAP7_75t_R
    XU114 VSS VDD  in[11] n123 INVx1_ASAP7_75t_R
    XU115 VSS VDD  in[7] in[6] n148 OR2x2_ASAP7_75t_R
    XU116 VSS VDD  n148 n88 INVx1_ASAP7_75t_R
    XU117 VSS VDD  n88 n87 n90 NAND2xp5_ASAP7_75t_R
    XU118 VSS VDD  in[8] in[9] n147 OR2x2_ASAP7_75t_R
    XU119 VSS VDD  n123 n90 n89 n91 NAND3xp33_ASAP7_75t_R
    XU120 VSS VDD  n36 n91 n41 NAND2xp5_ASAP7_75t_R
    XU121 VSS VDD  n32 n33 n95 AND2x2_ASAP7_75t_R
    XU122 VSS VDD  in[9] n93 INVx1_ASAP7_75t_R
    XU123 VSS VDD  in[11] in[10] n151 OR2x2_ASAP7_75t_R
    XU124 VSS VDD  n36 n93 n92 n94 NAND3xp33_ASAP7_75t_R
    XU125 VSS VDD  n95 n94 n34 NAND2xp5_ASAP7_75t_R
    XU126 VSS VDD  in[30] n102 INVx1_ASAP7_75t_R
    XU127 VSS VDD  in[29] n102 n136 NAND2xp5_ASAP7_75t_R
    XU128 VSS VDD  in[28] n138 INVx1_ASAP7_75t_R
    XU129 VSS VDD  in[24] n171 n96 NAND2xp5_ASAP7_75t_R
    XU130 VSS VDD  n96 n170 n99 AND2x2_ASAP7_75t_R
    XU131 VSS VDD  in[22] n97 INVx1_ASAP7_75t_R
    XU132 VSS VDD  n99 n97 n100 NAND2xp5_ASAP7_75t_R
    XU133 VSS VDD  in[23] in[25] n98 OR2x2_ASAP7_75t_R
    XU134 VSS VDD  n99 n98 n128 NAND2xp5_ASAP7_75t_R
    XU135 VSS VDD  n100 n169 n128 n101 NAND3xp33_ASAP7_75t_R
    XU136 VSS VDD  n102 n138 n101 n133 AND3x1_ASAP7_75t_R
    XU137 VSS VDD  in[20] n103 INVx1_ASAP7_75t_R
    XU138 VSS VDD  in[19] n103 n131 NAND2xp5_ASAP7_75t_R
    XU139 VSS VDD  in[14] n104 INVx1_ASAP7_75t_R
    XU140 VSS VDD  in[12] n155 INVx1_ASAP7_75t_R
    XU141 VSS VDD  n107 n155 n108 NAND2xp5_ASAP7_75t_R
    XU142 VSS VDD  in[17] n120 INVx1_ASAP7_75t_R
    XU143 VSS VDD  in[13] in[15] n106 OR2x2_ASAP7_75t_R
    XU144 VSS VDD  n107 n106 n121 NAND2xp5_ASAP7_75t_R
    XU145 VSS VDD  n108 n120 n121 n126 NAND3xp33_ASAP7_75t_R
    *XU146 VSS VDD  in[10] n109 INVx1_ASAP7_75t_R
    XU146 VSS VDD  in[10] n109 INVx6_ASAP7_75t_R
    *XU147 VSS VDD  in[9] n109 n124 NAND2xp5_ASAP7_75t_R
    XU147 VSS VDD  in[9] n109 n124 NAND2x1p5_ASAP7_75t_R
    XU148 VSS VDD  in[6] n110 INVx1_ASAP7_75t_R
    XU149 VSS VDD  in[7] n115 INVx1_ASAP7_75t_R
    XU150 VSS VDD  in[5] n112 INVx1_ASAP7_75t_R
    XU151 VSS VDD  in[4] n115 n112 n118 NAND3xp33_ASAP7_75t_R
    XU152 VSS VDD  in[2] n113 INVx1_ASAP7_75t_R
    XU153 VSS VDD  in[1] n113 n116 NAND2xp5_ASAP7_75t_R
    XU154 VSS VDD  n116 n115 n114 n117 NAND3xp33_ASAP7_75t_R
    *XU155 VSS VDD  n119 n118 n117 n122 NAND3xp33_ASAP7_75t_R
    XU155 VSS VDD  n119 n118 n117 n122 NAND3x2_ASAP7_75t_R
    *XU156 VSS VDD  n124 n123 n122 n121 n120 n125 NAND5xp2_ASAP7_75t_R
    XU156 VSS VDD  n124 n123 n122 n121 n120 n125 NAND5
    *XU157 VSS VDD  n127 n126 n125 n130 NAND3xp33_ASAP7_75t_R
    XU157 VSS VDD  n127 n126 n125 n130 NAND3x1_ASAP7_75t_R
    XU158 VSS VDD  in[21] n129 INVx1_ASAP7_75t_R
    *XU159 VSS VDD  n131 n130 n129 n128 n169 n132 NAND5xp2_ASAP7_75t_R
    XU159 VSS VDD  n131 n130 n129 n128 n169 n132 NAND5
    *XU160 VSS VDD  n133 n132 n135 NAND2xp5_ASAP7_75t_R
    XU160 VSS VDD  n133 n132 n135 NAND2x2_ASAP7_75t_R
    XU161 VSS VDD  in[31] n134 INVx1_ASAP7_75t_R
    *XU162 VSS VDD  n136 n135 n134 idx[0] NAND3xp33_ASAP7_75t_R
    XU162 VSS VDD  n136 n135 n134 idx[0] NAND3x2_ASAP7_75t_R
    XU163 VSS VDD  in[27] in[26] n139 OR2x2_ASAP7_75t_R
    XU164 VSS VDD  in[29] n137 INVx1_ASAP7_75t_R
    XU165 VSS VDD  n139 n138 n137 n168 NAND3xp33_ASAP7_75t_R
    XU166 VSS VDD  in[22] in[23] n143 OR2x2_ASAP7_75t_R
    XU167 VSS VDD  in[24] in[25] n141 OR2x2_ASAP7_75t_R
    XU168 VSS VDD  n143 n163 INVx1_ASAP7_75t_R
    XU169 VSS VDD  in[17] in[16] n146 OR2x2_ASAP7_75t_R
    XU170 VSS VDD  in[18] n145 INVx1_ASAP7_75t_R
    XU171 VSS VDD  in[19] n144 INVx1_ASAP7_75t_R
    XU172 VSS VDD  n146 n145 n144 n161 NAND3xp33_ASAP7_75t_R
    XU173 VSS VDD  n147 n149 INVx1_ASAP7_75t_R
    XU174 VSS VDD  n149 n148 n154 NAND2xp5_ASAP7_75t_R
    XU175 VSS VDD  in[2] in[3] n150 OR2x2_ASAP7_75t_R
    XU176 VSS VDD  n87 n150 n149 n153 NAND3xp33_ASAP7_75t_R
    XU177 VSS VDD  n151 n152 INVx1_ASAP7_75t_R
    XU178 VSS VDD  n154 n153 n152 n157 NAND3xp33_ASAP7_75t_R
    XU179 VSS VDD  in[13] n156 INVx1_ASAP7_75t_R
    XU180 VSS VDD  n157 n156 n155 n158 NAND3xp33_ASAP7_75t_R
    XU181 VSS VDD  n159 n158 n160 NAND2xp5_ASAP7_75t_R
    XU182 VSS VDD  n161 n160 n162 NAND2xp5_ASAP7_75t_R
    XU183 VSS VDD  n163 n162 n164 NAND2xp5_ASAP7_75t_R
    XU184 VSS VDD  n165 n164 n167 NAND2xp5_ASAP7_75t_R
    XU185 VSS VDD  n168 n167 n166 idx[1] NAND3xp33_ASAP7_75t_R

    CU3   n39  GND 3f
    CU4   n40  GND 3f
    CU75  n31  GND 3f
    CU76  n38  GND 3f
    CU92  n87  GND 3f
    CU93  n107 GND 3f
    CU94  n105 GND 3f
    CU95  n119 GND 3f
    CU96  n111 GND 3f
    CU97  n114 GND 3f
    CU98  n159 GND 3f
    CU99  n166 GND 3f
    CU100 n89  GND 3f
    CU101 n33  GND 3f
    CU102 n36  GND 3f
    CU103 n37  GND 3f
    CU104 n165 GND 3f
    CU105 n142 GND 3f
    CU106 n140 GND 3f
    CU107 n92  GND 3f
    CU108 n32  GND 3f
    CU109 n127 GND 3f
    CU110 n170 GND 3f
    CU111 n169 GND 3f
    CU112 n171 GND 3f
    CU113 n172 GND 3f
    CU114 n123 GND 3f
    CU115 n148 GND 3f
    CU116 n88  GND 3f
    CU117 n90  GND 3f
    CU118 n147 GND 3f
    CU119 n91  GND 3f
    CU120 n41  GND 3f
    CU121 n95  GND 3f
    CU122 n93  GND 3f
    CU123 n151 GND 3f
    CU124 n94  GND 3f
    CU125 n34  GND 3f
    CU126 n102 GND 3f
    CU127 n136 GND 3f
    CU128 n138 GND 3f
    CU129 n96  GND 3f
    CU130 n99  GND 3f
    CU131 n97  GND 3f
    CU132 n100 GND 3f
    CU133 n98  GND 3f
    CU134 n128 GND 3f
    CU135 n101 GND 3f
    CU136 n133 GND 3f
    CU137 n103 GND 3f
    CU138 n131 GND 3f
    CU139 n104 GND 3f
    CU140 n155 GND 3f
    CU141 n108 GND 3f
    CU142 n120 GND 3f
    CU143 n106 GND 3f
    CU144 n121 GND 3f
    CU145 n126 GND 3f
    CU146 n109 GND 3f
    CU147 n124 GND 3f
    CU148 n110 GND 3f
    CU149 n115 GND 3f
    CU150 n112 GND 3f
    CU151 n118 GND 3f
    CU152 n113 GND 3f
    CU153 n116 GND 3f
    CU154 n117 GND 3f
    CU155 n122 GND 3f
    CU156 n125 GND 3f
    CU157 n130 GND 3f
    CU158 n129 GND 3f
    CU159 n132 GND 3f
    CU160 n135 GND 3f
    CU161 n134 GND 3f
    CU163 n139 GND 3f
    CU164 n137 GND 3f
    CU165 n168 GND 3f
    CU166 n143 GND 3f
    CU167 n141 GND 3f
    CU168 n163 GND 3f
    CU169 n146 GND 3f
    CU170 n145 GND 3f
    CU171 n144 GND 3f
    CU172 n161 GND 3f
    CU173 n149 GND 3f
    CU174 n154 GND 3f
    CU175 n150 GND 3f
    CU176 n153 GND 3f
    CU177 n152 GND 3f
    CU178 n157 GND 3f
    CU179 n156 GND 3f
    CU180 n158 GND 3f
    CU181 n160 GND 3f
    CU182 n162 GND 3f
    CU183 n164 GND 3f
    CU184 n167 GND 3f
.ENDS





*****************************
**         Measure         **
*****************************
.tran 0.01ps 23ns 
.measure TRAN delay TRIG V(buff_in10) VAL='supply * 0.5' FALL=1 TARG V(idx0) VAL='supply * 0.5' RISE=1
.measure Tr_out TRIG V(idx0) VAL='supply * 0.1' RISE=1 TARG V(idx0) VAL='supply * 0.9' RISE=1
.measure Tf_out TRIG V(idx0) VAL='supply * 0.9' FALL=1 TARG V(idx0) VAL='supply * 0.1' FALL=1
.meas tran pwr avg POWER 

*** 
*****************************
**    Simulator setting    **
*****************************
.temp 25
.option post 
.options probe
.probe v(*) i(*)
.option captab	
.op

.end
