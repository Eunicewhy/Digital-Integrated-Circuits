// `include "../00_TESTBED/define.v"

module Convolution_without_pipeline(
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

// FSM state
reg [1:0] state_cs, state_ns;
parameter IDLE = 3'd0;
parameter CONV = 3'd1;
parameter AVR_POOL = 3'd2;
parameter OUTPUT = 3'd3;

// Buffers
reg signed [7:0] IFM_Buffer [0:195]; // 14x14 input feature map buffer (signed: [7], int: [6:3], frac: [2:0])
reg signed [7:0] Weight_Buffer [0:8]; // 3x3 weight buffer (signed: [7], int: [6:3], frac: [2:0])

reg signed [31:0] OFM_Buffer [0:11][0:11], // 12x12 output feature map buffer (signed: [31], int: [8:3], frac: [2:0])
				  OFM_Pool_Buffer [0:5][0:5]; // 6x6 pooled output feature map buffer (signed: [31], int: [8:3], frac: [2:0])

// counters
reg [7:0] input_cnt;
reg [3:0] row_cnt, col_cnt;
reg [3:0] out_row_cnt, out_col_cnt;

integer i, j;
reg pool_valid;

// IFM Buffering
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		// initialize IFM_Buffer
		for(i = 0; i < 196; i = i + 1)
			IFM_Buffer[i] <= 0;
	end
	else begin
		if(state_cs == IDLE || state_cs == CONV) begin
			if(in_valid) begin
				IFM_Buffer[input_cnt] <= In_IFM;
			end
			else begin
				IFM_Buffer[input_cnt] <= IFM_Buffer[input_cnt];
			end
		end
		else begin
			for (i = 0; i < 196; i = i + 1) begin
				IFM_Buffer[i] <= IFM_Buffer[i];
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
		if(state_cs == IDLE || state_cs == CONV) begin
			if(in_valid && input_cnt < 9) begin
				Weight_Buffer[input_cnt] <= In_Weight;
			end
			else begin
				Weight_Buffer[input_cnt] <= Weight_Buffer[input_cnt];
			end
		end
		else begin
			for (i = 0; i < 9; i = i + 1) begin
				Weight_Buffer[i] <= Weight_Buffer[i];
			end
		end
	end
end

// FSM
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state_cs <= IDLE;
	else
		state_cs <= state_ns;
end

always@(*) begin
	case(state_cs)
		IDLE: begin
			if(input_cnt == 8'd52)		// 196 cycles for 14x14 input feature map
				state_ns = CONV;
			else
				state_ns = IDLE;
		end
		CONV: begin
			if(row_cnt == 4'd11 && col_cnt == 4'd11)	// 12x12 output feature map after convolution
				state_ns = AVR_POOL;
			else
				state_ns = CONV;
		end
		AVR_POOL: begin
			if(pool_valid)	// 6x6 output feature map after average pooling
				state_ns = OUTPUT;
			else
				state_ns = AVR_POOL;
		end
		OUTPUT: begin
			if(out_row_cnt == 4'd5 && out_col_cnt == 4'd5)
				state_ns = IDLE;
			else
				state_ns = OUTPUT;
		end
		default:
			state_ns = IDLE;
	endcase
end

// input_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        input_cnt <= 0;
    end
    else begin
        if(state_cs == IDLE || state_cs == CONV) begin
            if(in_valid) begin
                if(input_cnt == 8'd196)
                    input_cnt <= 0;
                else if(in_valid)
                    input_cnt <= input_cnt + 1;
                else
                    input_cnt <= input_cnt;
            end
            else
                input_cnt <= input_cnt;
        end
        else if(state_cs == OUTPUT)
            if(out_col_cnt == 4'd5 && out_row_cnt == 4'd5)
                input_cnt <= 0;
            else
                input_cnt <= input_cnt;
        else
            input_cnt <= input_cnt;
    end
end

// counter
// col_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        col_cnt <= 0;
    end
    else begin
        if(state_cs == IDLE) begin
            col_cnt <= 0;
        end
        else if(state_cs == CONV) begin
            if(col_cnt == 4'd11)
                col_cnt <= 0;
            else
                col_cnt <= col_cnt + 1;
        end
        else if(state_cs == AVR_POOL) begin
            if(col_cnt == 4'd5)
                col_cnt <= 0;
            else
                col_cnt <= col_cnt + 1;
        end
        else if(state_cs == OUTPUT) begin
            if(col_cnt == 4'd5)
                col_cnt <= 0;
            else
                col_cnt <= col_cnt + 1;
        end
        else
            col_cnt <= col_cnt;

    end
end

// row_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_cnt <= 0;
    end
    else begin
        if(state_cs == IDLE) begin
            row_cnt <= 0;
        end
        else if(state_cs == CONV) begin
            if(col_cnt == 4'd11 && row_cnt == 4'd11)
                row_cnt <= 0;
            else if(col_cnt == 4'd11)
                row_cnt <= row_cnt + 1;
            else
                row_cnt <= row_cnt;
        end
        else if(state_cs == AVR_POOL) begin
            if(col_cnt == 4'd5 && row_cnt == 4'd5)
                row_cnt <= 0;
            else if(col_cnt == 4'd5)
                row_cnt <= row_cnt + 1;
            else
                row_cnt <= row_cnt;
        end
        else if(state_cs == OUTPUT) begin
            if(col_cnt == 4'd5 && row_cnt == 4'd5)
                row_cnt <= 0;
            else if(col_cnt == 4'd5)
                row_cnt <= row_cnt + 1;
            else
                row_cnt <= row_cnt;
        end
        else
            row_cnt <= row_cnt;
    end
end

// out_col_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_col_cnt <= 0;
    end
    else begin
        if(state_cs == OUTPUT) begin
            if(out_col_cnt == 4'd5)
                out_col_cnt <= 0;
            else
                out_col_cnt <= out_col_cnt + 1;
        end
        else
            out_col_cnt <= out_col_cnt;

    end
end

// out_row_cnt
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_row_cnt <= 0;
    end
    else begin
        if(state_cs == OUTPUT) begin
            if(out_col_cnt == 4'd5 && out_row_cnt == 4'd5)
                out_row_cnt <= 0;
            else if(out_col_cnt == 4'd5)
                out_row_cnt <= out_row_cnt + 1;
            else
                out_row_cnt <= out_row_cnt;
        end
        else
            out_row_cnt <= out_row_cnt;
    end
end

reg signed [15:0] p0, p1, p2, p3, p4, p5, p6, p7, p8;
reg signed [31:0] acc;
integer base;
// Convolution
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		// initialize OFM_Buffer
		for(i = 0; i < 12; i = i + 1) begin
			for(j = 0; j < 12; j = j + 1) begin
				OFM_Buffer[i][j] <= 0;
			end
		end
	end
	else begin
		if(state_cs == CONV) begin
			// compute 9 multiplications and sum
            
            base = 14 * row_cnt + col_cnt;
            p0 = $signed(IFM_Buffer[base])   * $signed(Weight_Buffer[0]);
            p1 = $signed(IFM_Buffer[base+1]) * $signed(Weight_Buffer[1]);
            p2 = $signed(IFM_Buffer[base+2]) * $signed(Weight_Buffer[2]);
            p3 = $signed(IFM_Buffer[base+14]) * $signed(Weight_Buffer[3]);
            p4 = $signed(IFM_Buffer[base+14+1]) * $signed(Weight_Buffer[4]);
            p5 = $signed(IFM_Buffer[base+14+2]) * $signed(Weight_Buffer[5]);
            p6 = $signed(IFM_Buffer[base+28]) * $signed(Weight_Buffer[6]);
            p7 = $signed(IFM_Buffer[base+28+1]) * $signed(Weight_Buffer[7]);
            p8 = $signed(IFM_Buffer[base+28+2]) * $signed(Weight_Buffer[8]);

            acc = 0;
            acc = acc + p0;
            acc = acc + p1;
            acc = acc + p2;
            acc = acc + p3;
            acc = acc + p4;
            acc = acc + p5;
            acc = acc + p6;
            acc = acc + p7;
            acc = acc + p8;

            // OFM_Buffer[row_cnt][col_cnt] <= acc;
            OFM_Buffer[row_cnt][col_cnt] <= acc;

		end
		else begin
			// retain previous values
			for(i = 0; i < 12; i = i + 1) begin
				for(j = 0; j < 12; j = j + 1) begin
					OFM_Buffer[i][j] <= OFM_Buffer[i][j];
				end
			end
		end
	end
end


// Pooling + Leaky ReLU - UPDATED to exact division by 3 and trunc-to-zero for /4
reg signed [33:0] sum4; // sum of four 32-bit Q8.6 numbers
reg signed [31:0] avg_q86; // Q8.6
reg signed [13:0] int14;   // truncated integer (sign + 13-bit integer)
reg signed [13:0] out14;   // after leaky ReLU (14-bit)
integer rbase, cbase;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pool_valid <= 1'b0;
        for (i=0;i<6;i=i+1)
            for (j=0;j<6;j=j+1)
                OFM_Pool_Buffer[i][j] <= 0;
    end
    else begin
        if (state_cs == AVR_POOL || state_cs == OUTPUT) begin
            rbase = row_cnt * 2;
            cbase = col_cnt * 2;

            // gather 4 values (Q8.6)
            sum4 = $signed(OFM_Buffer[rbase][cbase])
                 + $signed(OFM_Buffer[rbase][cbase+1])
                 + $signed(OFM_Buffer[rbase+1][cbase])
                 + $signed(OFM_Buffer[rbase+1][cbase+1]);

            // avg = sum / 4 (Q8.6)
            // sum4 can be negative: implement arithmetic truncate-toward-zero division by 4
            if (sum4 >= 0)
                avg_q86 = sum4 >>> 2; // positive: arithmetic right shift equals trunc toward zero
            else
                avg_q86 = - ( ( -sum4 ) >>> 2 ); // negative: trunc toward zero

            // TRUNCATE avg_q86 (Q8.6) to 14-bit integer: remove fractional 6 bits, truncate toward zero
            if (avg_q86 >= 0)
                int14 = avg_q86 >>> 6; // keep lower 14 bits (signed)
            else
                int14 = - ( ( -avg_q86 ) >>> 6 );

            // Leaky ReLU on int14: if >=0 keep, else divide by 3 (signed division trunc towards 0)
            if (int14 >= 0) begin
                out14 = int14;
            end
            else begin
                out14 = -(((-int14) * 32'sd21846)>>> 16); // signed div, trunc toward 0
            end

            // store 14-bit result
            OFM_Pool_Buffer[row_cnt][col_cnt] <= out14;
            pool_valid <= 1'd1;
        end
        else begin
            pool_valid <= 1'd0;
            for (i=0;i<6;i=i+1)
            	for (j=0;j<6;j=j+1)
                	OFM_Pool_Buffer[i][j] <= OFM_Pool_Buffer[i][j];
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
        if (state_cs == OUTPUT) begin
            out_valid <= 1'b1;
            Out_OFM <= OFM_Pool_Buffer[out_row_cnt][out_col_cnt]; // already 14-bit signed
        end
        else begin
            // on transition OUTPUT->IDLE clear counters for next batch
            out_valid <= 1'b0;
            Out_OFM <= 0;
        end
    end
end

endmodule