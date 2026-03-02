// `include "../00_TESTBED/define.v"
`include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW02_mult.v"

module Convolution_with_pipeline(
    //input
    clk,
    rst_n,
    in_valid,
    In_IFM,
    In_Weight,
    //output
    out_valid,
    Out_OFM
);

input clk, rst_n, in_valid;
input [7:0]In_IFM;
input [7:0]In_Weight;

//////////////The output port shoud be registers///////////////////////
output reg out_valid;
output reg[13:0] Out_OFM;
//////////////////////////////////////////////////////////////////////

// Buffers
reg [7:0] IFM_Buffer [0:30]; // 31-element shift register
reg [7:0] Weight_Buffer [0:8]; // 3x3 weight buffer (signed: [7], int: [6:3], frac: [2:0])

reg [14:0] OFM_Pool_Buffer [0:5][0:5]; // 6x6 pooled output feature map buffer (signed: [18], int: [8:3], frac: [2:0])

// counters
reg [7:0] input_cnt;
reg [3:0] row_cnt, col_cnt;
reg [3:0] out_row_cnt, out_col_cnt;

integer i, j;

// pipeline product regs (stage0 outputs)
reg signed [18:0] p0_r0, p1_r0, p2_r0, p3_r0, p4_r0, p5_r0, p6_r0, p7_r0, p8_r0;
// partial sums (stage1 outputs)
reg signed [18:0] s0_r1, s1_r1, s2_r1, s3_r1, s4_r1;
// final acc (stage2 output)
reg signed [18:0] acc_r2, acc_r3, acc_r4, acc_r5, acc_r6;

// pipeline valid and coordinate registers
reg [5:0] conv_valid_pipe; // conv_valid_pipe[0] = stage0 valid ... [2] = stage2 valid
reg [3:0] row_pipe [0:4];
reg [3:0] col_pipe [0:4];
reg [2:0] pool_valid_pipe;
// ------------------------------------------------------------------
// IFM shift
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (i=0;i<=30;i=i+1) begin
			IFM_Buffer[i] <= 0;
		end
	end
	else begin
		if(input_cnt==208) begin
			for (i=0;i<=30;i=i+1) begin
				IFM_Buffer[i] <= 0;
			end
		end
		else if(in_valid && input_cnt<=30) begin
			IFM_Buffer[input_cnt]  <= In_IFM;
		end
		else if(input_cnt>=31 && input_cnt<=195) begin	
			IFM_Buffer[30] <= In_IFM;
			for(j=0;j<30;j=j+1) begin
				IFM_Buffer[j] <= IFM_Buffer[j+1];
			end
		end
		else if(input_cnt==196||input_cnt==197||input_cnt==198||input_cnt==199) begin	
			for (i=0;i<=30;i=i+1) begin
				IFM_Buffer[i] <= IFM_Buffer[i];
			end
		end
		else begin
			for (i=0;i<=30;i=i+1) begin
				IFM_Buffer[i] <= 0;
			end
		end
	end
end

// Weight Buffering
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        // initialize Weight_Buffer
        for(j = 0; j < 9; j = j + 1)
            Weight_Buffer[j] <= 0;
    end
    else begin
        if(in_valid && input_cnt < 9) begin
            Weight_Buffer[input_cnt] <= In_Weight;
        end
        else begin
            Weight_Buffer[input_cnt] <= Weight_Buffer[input_cnt];
        end
    end
end

// input_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        input_cnt <= 0;
    end
    else begin
        if(in_valid || (input_cnt >= 196 && input_cnt < 208)) begin
            input_cnt <= input_cnt + 1;
        end
        else
            input_cnt <= 0;
    end
end

reg wait_flag;
always@(*) begin
		if(input_cnt==43||input_cnt==44 ||input_cnt==57||input_cnt==58||input_cnt==71||input_cnt==72||input_cnt==85||input_cnt==86||input_cnt==99||input_cnt==100||input_cnt==113||input_cnt==114||input_cnt==127||input_cnt==128||input_cnt==141||input_cnt==142||input_cnt==155||input_cnt==156||input_cnt==169||input_cnt==170||input_cnt==183||input_cnt==184) begin
			wait_flag=1;
		end
		else begin
            wait_flag=0;
        end
end

// counter
// col_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        col_cnt <= 0;
    end
    else begin
        if(input_cnt < 8'd31) begin
            col_cnt <= 0;
        end
        else if(input_cnt >= 8'd31 && input_cnt <= 8'd196) begin
            if(col_cnt == 4'd11 || wait_flag)
                col_cnt <= 0;
            else
                col_cnt <= col_cnt + 1;
        end
        else
            col_cnt <= 0;

    end
end

// row_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_cnt <= 0;
    end
    else begin
        if(input_cnt < 8'd31) begin
            row_cnt <= 0;
        end
        else if(input_cnt >= 8'd31 && input_cnt <= 8'd196) begin
            if(col_cnt == 4'd11 && row_cnt == 4'd11)
                row_cnt <= 0;
            else if(col_cnt == 4'd11)
                row_cnt <= row_cnt + 1;
            else
                row_cnt <= row_cnt;
        end
        else
            row_cnt <= 0;
    end
end


// out_col_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_col_cnt <= 0;
    end
    else begin
        if(input_cnt >= 8'd172 && input_cnt < 8'd208) begin
            if(out_col_cnt == 4'd5)
                out_col_cnt <= 0;
            else
                out_col_cnt <= out_col_cnt + 1;
        end
        else
            out_col_cnt <= 0;

    end
end

// out_row_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_row_cnt <= 0;
    end
    else begin
        if(input_cnt >= 8'd172 && input_cnt < 8'd208) begin
            if(out_col_cnt == 4'd5 && out_row_cnt == 4'd5)
                out_row_cnt <= 0;
            else if(out_col_cnt == 4'd5)
                out_row_cnt <= out_row_cnt + 1;
            else
                out_row_cnt <= out_row_cnt;
        end
        else
            out_row_cnt <= 0;
    end
end

reg conv_wait_flag;
always@(*) begin
    if(col_pipe[0] != 4'd2 && col_pipe[0] != 4'd3) begin
        conv_wait_flag = 1;
    end
    else begin
        conv_wait_flag = 0;
    end
end

parameter A_width = 8;
parameter B_width = 8;
wire signed [A_width+B_width-1:0] mul_r0, mul_r1, mul_r2, mul_r3, mul_r4, mul_r5, mul_r6, mul_r7, mul_r8;

DW02_mult #(A_width, B_width) U_DW02_mult_0 (.A(IFM_Buffer[0] ), .B(Weight_Buffer[0]), .TC(1'b1), .PRODUCT(mul_r0));
DW02_mult #(A_width, B_width) U_DW02_mult_1 (.A(IFM_Buffer[1] ), .B(Weight_Buffer[1]), .TC(1'b1), .PRODUCT(mul_r1));
DW02_mult #(A_width, B_width) U_DW02_mult_2 (.A(IFM_Buffer[2] ), .B(Weight_Buffer[2]), .TC(1'b1), .PRODUCT(mul_r2));
DW02_mult #(A_width, B_width) U_DW02_mult_3 (.A(IFM_Buffer[14]), .B(Weight_Buffer[3]), .TC(1'b1), .PRODUCT(mul_r3));
DW02_mult #(A_width, B_width) U_DW02_mult_4 (.A(IFM_Buffer[15]), .B(Weight_Buffer[4]), .TC(1'b1), .PRODUCT(mul_r4));
DW02_mult #(A_width, B_width) U_DW02_mult_5 (.A(IFM_Buffer[16]), .B(Weight_Buffer[5]), .TC(1'b1), .PRODUCT(mul_r5));
DW02_mult #(A_width, B_width) U_DW02_mult_6 (.A(IFM_Buffer[28]), .B(Weight_Buffer[6]), .TC(1'b1), .PRODUCT(mul_r6));
DW02_mult #(A_width, B_width) U_DW02_mult_7 (.A(IFM_Buffer[29]), .B(Weight_Buffer[7]), .TC(1'b1), .PRODUCT(mul_r7));
DW02_mult #(A_width, B_width) U_DW02_mult_8 (.A(IFM_Buffer[30]), .B(Weight_Buffer[8]), .TC(1'b1), .PRODUCT(mul_r8));

reg signed [18:0] OFM_curr, out14;            // streaming OFM value (latest conv output)
reg [3:0] OFM_row_reg, OFM_col_reg;    // coordinates for OFM_curr (0..11)
// ------------------------------------------------------------------
// Pipelined Convolution: 3-stage pipeline
// ------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // clear pipeline regs
        p0_r0 <= 0; p1_r0 <= 0; p2_r0 <= 0; p3_r0 <= 0; p4_r0 <= 0; p5_r0 <= 0; p6_r0 <= 0; p7_r0 <= 0; p8_r0 <= 0;
        s0_r1 <= 0; s1_r1 <= 0; s2_r1 <= 0; s3_r1 <= 0; s4_r1 <= 0;
        acc_r2 <= 0; acc_r3 <= 0; acc_r4 <= 0; acc_r5 <= 0; acc_r6 <= 0;
        conv_valid_pipe <= 6'b0;

        row_pipe[0] <= 0; row_pipe[1] <= 0; row_pipe[2] <= 0; row_pipe[3] <= 0; row_pipe[4] <= 0;
        col_pipe[0] <= 0; col_pipe[1] <= 0; col_pipe[2] <= 0; col_pipe[3] <= 0; col_pipe[4] <= 0;
        OFM_row_reg <=0; OFM_col_reg<=0;
        OFM_curr <= 32'd0;
    end
    else begin
        // Stage0: we assert conv_valid_pipe[0] when we have enough streamed data to form a 3x3 window.
        if (input_cnt >= 8'd31 && input_cnt <= 8'd196) begin
            if(wait_flag) begin
				p0_r0 <= 0;
				p1_r0 <= 0;
				p2_r0 <= 0;
				p3_r0 <= 0;
				p4_r0 <= 0;
				p5_r0 <= 0;
				p6_r0 <= 0;
				p7_r0 <= 0;
				p8_r0 <= 0;
			end
			else begin
                // top-left .. bottom-right mapping 
                p0_r0 <= $signed({{3{mul_r0[15]}}, mul_r0}); // top-left
                p1_r0 <= $signed({{3{mul_r1[15]}}, mul_r1}); // top-mid
                p2_r0 <= $signed({{3{mul_r2[15]}}, mul_r2}); // top-right
                p3_r0 <= $signed({{3{mul_r3[15]}}, mul_r3}); // mid-left
                p4_r0 <= $signed({{3{mul_r4[15]}}, mul_r4}); // mid-mid
                p5_r0 <= $signed({{3{mul_r5[15]}}, mul_r5}); // mid-right
                p6_r0 <= $signed({{3{mul_r6[15]}}, mul_r6}); // bot-left
                p7_r0 <= $signed({{3{mul_r7[15]}}, mul_r7}); // bot-mid
                p8_r0 <= $signed({{3{mul_r8[15]}}, mul_r8}); // bot-right
                conv_valid_pipe[0] <= 1'b1;
                row_pipe[0] <= row_cnt;
                col_pipe[0] <= col_cnt;
			end
        end
        else begin
            p0_r0 <= 0; p1_r0 <= 0; p2_r0 <= 0; p3_r0 <= 0; p4_r0 <= 0; p5_r0 <= 0; p6_r0 <= 0; p7_r0 <= 0; p8_r0 <= 0;
            conv_valid_pipe <= 6'd0;
            row_pipe[0] <= 0;
            col_pipe[0] <= 0;
        end

        // Stage1: compute 9 products from IFM_Buffer 
        if (conv_valid_pipe[0]) begin
            s0_r1 <= p0_r0 + p1_r0; // sum of first row
            s1_r1 <= p2_r0 + p3_r0; 
            s2_r1 <= p4_r0 + p5_r0;
            s3_r1 <= p6_r0 + p7_r0;
            s4_r1 <= p8_r0;

            conv_valid_pipe[1] <= 1'b1;
            row_pipe[1] <= row_pipe[0];
            col_pipe[1] <= col_pipe[0];
        end
        else begin
            s0_r1 <= 0; s1_r1 <= 0; s2_r1 <= 0; s3_r1 <= 0; s4_r1 <= 0;
            conv_valid_pipe[1] <= 1'b0;
            row_pipe[1] <= 0;
            col_pipe[1] <= 0;
        end

        // Stage2..StageN: keep original reduction/accum pipeline 
        if (conv_valid_pipe[1]) begin
            acc_r2 <= s0_r1 + s1_r1;
            acc_r3 <= s2_r1 + s3_r1;
            acc_r4 <= s4_r1;
            conv_valid_pipe[2] <= 1'b1;
            row_pipe[2] <= row_pipe[1];
            col_pipe[2] <= col_pipe[1];
        end
        else begin
            conv_valid_pipe[2] <= 1'b0;
            row_pipe[2] <= 0;
            col_pipe[2] <= 0;
        end

        if (conv_valid_pipe[2]) begin
            acc_r5 <= acc_r2 + acc_r3;
            acc_r6 <= acc_r4;
            conv_valid_pipe[3] <= 1'b1;
            row_pipe[3] <= row_pipe[2];
            col_pipe[3] <= col_pipe[2];
        end
        else begin
            conv_valid_pipe[3] <= 1'b0;
            row_pipe[3] <= 0;
            col_pipe[3] <= 0;
        end

        if (conv_valid_pipe[3]) begin
            out14 <= acc_r5 + acc_r6;
            
            conv_valid_pipe[4] <= 1'b1;
            row_pipe[4] <= row_pipe[3];
            col_pipe[4] <= col_pipe[3];
        end
        else begin
            conv_valid_pipe[4] <= 0;
            row_pipe[4] <= 0;
            col_pipe[4] <= 0;
        end

        if (conv_valid_pipe[4] && conv_wait_flag) begin
            OFM_curr <= out14;
            
            conv_valid_pipe[5] <= 1'b1;
            OFM_row_reg <= row_pipe[4];
            OFM_col_reg <= col_pipe[4];
        end
        else begin
            conv_valid_pipe[5] <= conv_valid_pipe[5];
            OFM_row_reg <= OFM_row_reg;
            OFM_col_reg <= OFM_col_reg;
        end
    end
end

reg max_flag;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		max_flag <= 0;
	end
	else begin
		if(input_cnt >= 37) begin
			max_flag <= ~max_flag;
		end
		else begin
            max_flag <= 0;
        end
	end
end

reg [5:0] cnt_max;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt_max <= 0;
	end
	else begin
		if(input_cnt >= 37) begin
			if(max_flag)begin
				if(!conv_wait_flag) begin
					cnt_max <= cnt_max;
				end
				else if(cnt_max == 5) begin
					cnt_max <= 0;
				end
				else begin
					cnt_max <= cnt_max + 1;
				end
			end
		end
		else begin
            cnt_max <= 0;
        end
	end
end

// Pooling + Leaky ReLU - UPDATED to exact division by 3 and trunc-to-zero for /4

// --- pooling pipeline regs (modify existing ones accordingly) ---
reg signed [23:0] POOL_SUM [0:5];     // wider to avoid overflow
reg [2:0] POOL_CNT [0:5];             // count 0..4
reg [2:0] prow, pcol;
reg [2:0] prow_r [0:2], pcol_r [0:2];
reg signed [19:0] avg_q86;
reg signed [13:0] int_val, int_val_r0;
reg signed [47:0] leaky_prod;
reg [5:0] cnt_max_r [0:3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // clear accumulators & output pool buffer
        for (i = 0; i < 36; i = i + 1) begin
            POOL_SUM[i] <= 0;
            POOL_CNT[i] <= 0;
        end
        for (i = 0; i < 6; i = i + 1)
            for (j = 0; j < 6; j = j + 1)
                OFM_Pool_Buffer[i][j] <= 0;
        pool_valid_pipe <= 3'd0;
        prow <= 0;
        pcol <= 0;
        pcol_r[0] <= 0; pcol_r[1] <= 0; pcol_r[2] <= 0;
        prow_r[0] <= 0; prow_r[1] <= 0; prow_r[2] <= 0;
        cnt_max_r[0] <= 0; cnt_max_r[1] <= 0; cnt_max_r[2] <= 0; cnt_max_r[3] <= 0;
        avg_q86 <= 0;
        int_val <= 0;
        int_val_r0 <= 0;
        leaky_prod <= 0;
    end
    else begin
        if(input_cnt <= 8'd36) begin
            for (i = 0; i < 36; i = i + 1) begin
                POOL_SUM[i] <= 0;
                POOL_CNT[i] <= 0;
            end
            for (i = 0; i < 6; i = i + 1)
                for (j = 0; j < 6; j = j + 1)
                    OFM_Pool_Buffer[i][j] <= 0;
            pool_valid_pipe <= 3'd0;
        end
        // when conv produces a valid OFM (and conv_wait_flag gating used in your design)
        else if (conv_valid_pipe[5] && conv_wait_flag) begin
            // compute pool index: integer division by 2 (>>1) then flatten to 6x6
            prow <= OFM_row_reg >> 1;
            pcol <= OFM_col_reg >> 1;

            POOL_SUM[cnt_max] <= POOL_SUM[cnt_max] + $signed({{5{OFM_curr[18]}}, OFM_curr});
            POOL_CNT[cnt_max] <= POOL_CNT[cnt_max] + 1'b1;

            cnt_max_r[0] <= cnt_max;
            // when tmp_cnt == 4 -> we just collected the 4th element -> compute avg & LeakyReLU & store
            if (POOL_CNT[cnt_max_r[0]] == 4) begin
                avg_q86 <= (POOL_SUM[cnt_max_r[0]][22] == 1'b0) ? (POOL_SUM[cnt_max_r[0]] >>> 2) : -(( -POOL_SUM[cnt_max_r[0]] ) >>> 2);
                pool_valid_pipe[0] <= 1'b1;
                cnt_max_r[1] <= cnt_max_r[0];
                pcol_r[0] <= pcol;
                prow_r[0] <= prow;
            end
            else begin
                avg_q86 <= 0;
                pool_valid_pipe[0] <= 1'b0;
            end

            if (pool_valid_pipe[0]) begin
            // truncate fractional 6 bits -> arithmetic >>6
                if (avg_q86 >= 0)
                    int_val <= avg_q86 >>> 6;
                else
                    int_val <= -(( -avg_q86 ) >>> 6);

                pool_valid_pipe[1] <= 1'b1;
                cnt_max_r[2] <= cnt_max_r[1];
                pcol_r[1] <= pcol_r[0];
                prow_r[1] <= prow_r[0];
            end
            else begin
                int_val <= 0;
                pool_valid_pipe[1] <= 1'b0;
            end

            if (pool_valid_pipe[1]) begin
            // truncate fractional 6 bits -> arithmetic >>6
                int_val_r0 <= int_val;
                if (int_val < 0) begin
                    leaky_prod <= -int_val * 32'sd21846;
                end
                pool_valid_pipe[2] <= 1'b1;
                cnt_max_r[3] <= cnt_max_r[2];
                pcol_r[2] <= pcol_r[1];
                prow_r[2] <= prow_r[1];
            end
            else begin
                int_val_r0 <= 0;
                leaky_prod <= 0;
                pool_valid_pipe[2] <= 1'b0;
            end

            if (pool_valid_pipe[2]) begin
            // truncate fractional 6 bits -> arithmetic >>6
                if (int_val_r0 >= 0)
                    OFM_Pool_Buffer[prow_r[2]][pcol_r[2]] <= $unsigned(int_val_r0);
                else begin
                    // leaky: out = -( ( -int_val * 21846 ) >>> 16 );
                    OFM_Pool_Buffer[prow_r[2]][pcol_r[2]] <= $unsigned(-( leaky_prod >>> 16 ));
                end
                POOL_SUM[cnt_max_r[3]] <= 0;
                POOL_CNT[cnt_max_r[3]] <= 0;
            end
        end
    end
end

//-------------------------------------------------
// OUTPUT: read OFM_Pool_Buffer (14-bit) and present Out_OFM
//-------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 1'b0;
        Out_OFM <= 0;
    end
    else begin
        if (input_cnt >= 8'd172 && input_cnt < 8'd208) begin
            out_valid <= 1'b1;
            Out_OFM <= OFM_Pool_Buffer[out_row_cnt][out_col_cnt]; // already 14-bit signed
        end
        else begin
            out_valid <= 1'b0;
            Out_OFM <= 0;
        end
    end
end

endmodule
