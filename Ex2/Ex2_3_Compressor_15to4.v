module full_adder (
    A, B, Cin,
    Sum, Co
);
    input A, B, Cin;
    output Sum, Co;

    assign Sum = A ^ B ^ Cin;
    assign Co  = (A & B) | ((A ^ B) & Cin);
endmodule

module compressor_5to3 (
    i0, i1, i2, i3, i4,
    o2, o1, o0
);
    input i0, i1, i2, i3, i4;
    output o2, o1, o0;
    assign o0 = i0 ^ i1 ^ i2 ^ i3 ^ i4;

    wire a4_0 = i0 & i1 & i2 & i3;
    wire a4_1 = i0 & i1 & i2 & i4;
    wire a4_2 = i0 & i1 & i3 & i4;
    wire a4_3 = i0 & i2 & i3 & i4;
    wire a4_4 = i1 & i2 & i3 & i4;
    assign o2 = a4_0 | a4_1 | a4_2 | a4_3 | a4_4;

    wire p01 = i0 & i1;
    wire p02 = i0 & i2;
    wire p03 = i0 & i3;
    wire p04 = i0 & i4;
    wire p12 = i1 & i2;
    wire p13 = i1 & i3;
    wire p14 = i1 & i4;
    wire p23 = i2 & i3;
    wire p24 = i2 & i4;
    wire p34 = i3 & i4;
    wire ge2 = p01 | p02 | p03 | p04 | p12 | p13 | p14 | p23 | p24 | p34;

    assign o1 = ge2 & (~o2);

endmodule


module Compressor_15to4(
    //Input Port
    X,
    //Output Port
    CPRS
);
//==============================================//
//                Port Declaration              //
//==============================================//
input [14:0] X;
output reg [3:0] CPRS;

//==============================================//
//             Parameter and Integer            //
//==============================================//
wire s0, s1, s2, s3, s4;
wire c0, c1, c2, c3, c4;

wire sc2, sc1, sc0; 
wire cc2, cc1, cc0; 

wire bit0, bit1, bit2, bit3;
wire carry1, carry2;

//==============================================//
//                  Design                      //
//==============================================//

full_adder fa0 ( .A(X[0]),  .B(X[1]),  .Cin(X[2]),  .Sum(s0), .Co(c0) );
full_adder fa1 ( .A(X[3]),  .B(X[4]),  .Cin(X[5]),  .Sum(s1), .Co(c1) );
full_adder fa2 ( .A(X[6]),  .B(X[7]),  .Cin(X[8]),  .Sum(s2), .Co(c2) );
full_adder fa3 ( .A(X[9]),  .B(X[10]), .Cin(X[11]), .Sum(s3), .Co(c3) );
full_adder fa4 ( .A(X[12]), .B(X[13]), .Cin(X[14]), .Sum(s4), .Co(c4) );

compressor_5to3 stg_s (
    .i0(s0), .i1(s1), .i2(s2), .i3(s3), .i4(s4),
    .o2(sc2), .o1(sc1), .o0(sc0)
);

compressor_5to3 stg_c (
    .i0(c0), .i1(c1), .i2(c2), .i3(c3), .i4(c4),
    .o2(cc2), .o1(cc1), .o0(cc0)
);

assign bit0 = sc0; // total[0]

assign bit1 = sc1 ^ cc0;
assign carry1 = sc1 & cc0;

assign bit2 = sc2 ^ cc1 ^ carry1;
assign carry2 = (sc2 & cc1) | (cc1 & carry1) | (sc2 & carry1);

assign bit3 = cc2 ^ carry2;

always @(*) begin
    CPRS[3:0] = {bit3, bit2, bit1, bit0};
end

endmodule
