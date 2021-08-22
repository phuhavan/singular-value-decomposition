// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module control_unit_svd
#(
	parameter	addr_width = 6
)
(
	input				[4:0]					cnt_svd,				//	Du lieu lay tu bo dem cua data_path
	input										ce_svd,				// Cho phep chuyen trang thai tinh svd
	input										clk,rst_n,
	output	reg							ce_cordic_slot0_A,	// enable/disable gian tiep cordic slot 0 cua A
	output	reg							ce_cordic_slot1_A,	// enable/disable gian tiep cordic slot 1 cua A
	output	reg							ce_cordic_slot0_UV,	// enable/disable gian tiep cordic slot 0 cua UV
	output	reg							ce_cordic_slot1_UV,	// enable/disable gian tiep cordic slot 1 cua UV
	output	reg							mux_ctrl_0,			// Lua chon giua data_in va data_out_dram
	output	reg							demux_ctrl_0,			// dua ra du lieu data_out_svd_A va data_out_dram_A
	output	reg							mux_ctrl_1,				// Lua chon giua du lieu Dram_U va Dram_V
	output	reg							demux_ctrl_1,			// dua du lieu vao Dram_U hoac Dram_V
	output	reg	[2:0]					sel_cordic_rot,	// lua chon phan tu duoc xoay trong cordic
	output	reg							ce_cnt,				// Cho phep hoat dong bo dem
	output	reg 	[addr_width-1:0]	addr,					//	Xuat ra dia chi cho Dram
	output	reg							we_A,						//	Dieu khien viec doc/ghi cua Dram
	output	reg							we_U,						//	Dieu khien viec doc/ghi cua Dram_U
	output	reg							we_V,						//	Dieu khien viec doc/ghi cua Dram_V
	output	reg							reset,						// Reset 2 ma tran U va V ve duong cheo
	output	reg							en_load_out			// tin hieu bao co dau ra svd
);
//------------------------------------------------------------------------------------------------
//Reg
//------------------------------------------------------------------------------------------------
	reg	[6:0]	cnt_eyes;		// Thuc hien duong cheo
	reg			cal_eyes;		// Xac dinh tinh duong cheo
	reg	[6:0]	current_state, next_state;
	
	localparam 	load_in_matrix = 7'd0,
					r0c0 = 7'd1	,r0c1 = 7'd2	,r0c2 = 7'd3	,r0c3 = 7'd4	,c_r0c0 = 7'd5	,c_r1c1 = 7'd6	,c_r2c2 = 7'd7,
					r1c0 = 7'd8	,r1c1 = 7'd9	,r1c2 = 7'd10	,r1c3 = 7'd11	,r_r0c0 = 7'd12,r_r1c1 = 7'd13,r_r2c2 = 7'd14,
					r2c0 = 7'd15,r2c1 = 7'd16	,r2c2 = 7'd17	,r2c3 = 7'd18	,r2c4 = 7'd19	,r2c5 = 7'd20	,r2c6 = 7'd21,
					r3c0 = 7'd22,r3c1 = 7'd23	,r3c2 = 7'd24	,r3c3 = 7'd25	,r3c4 = 7'd26	,r3c5 = 7'd27	,r3c6 = 7'd28,
					r4c0 = 7'd29,r4c1 = 7'd30	,r4c2 = 7'd31	,r4c3 = 7'd32	,r4c4 = 7'd33	,r4c5 = 7'd34	,r4c6 = 7'd35,
					r5c0 = 7'd36,r5c1 = 7'd37	,r5c2 = 7'd38	,r5c3 = 7'd39	,r5c4 = 7'd40	,r5c5 = 7'd41	,r5c6 = 7'd42,
					r6c0 = 7'd43,r6c1 = 7'd44	,r6c2 = 7'd45	,r6c3 = 7'd46	,r6c4 = 7'd47	,r6c5 = 7'd48	,r6c6 = 7'd49,
					load_out_matrix = 7'd50;
					
//--------------------------------------------------------------------------------------------------
//Assign
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
//Chuyen trang thai
//--------------------------------------------------------------------------------------------------	
	always @ (posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			current_state <= load_in_matrix;
		end
		else if(ce_svd) begin
			current_state <= next_state;
		end
	end

// Duong cheo
	always @ (posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			cnt_eyes <= 0;
		end
		else if ((cal_eyes)&&(cnt_svd==5'd15)) begin
			cnt_eyes <= cnt_eyes + 6'b1;
		end
		else if (!cal_eyes) begin
			cnt_eyes <= 0;
		end
	end

//
	
//--------------------------------------------------------------------------------------------------
//state
//--------------------------------------------------------------------------------------------------
	always @ (current_state,cnt_svd,cal_eyes,cnt_eyes) begin
		next_state 		 	 = load_in_matrix;
		mux_ctrl_0 		 	 = 0;
		mux_ctrl_1			 = 0;
		demux_ctrl_0		 = 0;
		demux_ctrl_1		 = 0;
		ce_cordic_slot0_A  = 0;
		ce_cordic_slot1_A  = 0;
		ce_cordic_slot0_UV = 0;
		ce_cordic_slot1_UV = 0;
		ce_cnt			 	 = 1'b0;
		sel_cordic_rot	 	 = 3'b0;
		addr				 	 = 6'b0;
		we_A					 = 0;
		we_U					 = 0;
		we_V					 = 0;
		reset					 = 1'b1;
		cal_eyes			 	 = 1'b0;
		en_load_out			 = 1'b0;
		case (current_state)
			load_in_matrix:// Nap du lieu
				begin
					mux_ctrl_0 = 1'b0;
					mux_ctrl_1 = 1'b1;
					demux_ctrl_0 = 1'b1;
					demux_ctrl_1 = 1'b1;
					reset = 1'b0;
					ce_cnt = 1'b1;
					//we_A = 1'b1;
					we_U = 1'b0;
					we_V = 1'b0;
					ce_cordic_slot0_A = 0;
					ce_cordic_slot1_A = 0;
					ce_cordic_slot0_UV = 0;
					ce_cordic_slot1_UV = 0;
					if(cnt_svd == 5'd0)begin
						we_A = 1'b1;
						addr = 6'b000000;
						next_state = load_in_matrix;
					end
					else if(cnt_svd == 5'd1) begin
						we_A = 1'b1;
						addr = 6'b000010;
						next_state = load_in_matrix;
					end
					else begin
						we_A = 1'b0;
						ce_cnt = 0;
						next_state = r6c0;
					end
				end
			r6c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b111000;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r5c0;
					end
					else begin
						we_A				= 1'b0;
						we_U				= 1'b0;
						next_state	= r6c0;
					end
				end
			r5c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b110100;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r4c0;
					end
					else begin
						we_A				= 1'b0;
						we_U				= 1'b0;
						next_state	= r5c0;
					end
				end
			r4c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b110000;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r3c0;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r4c0;
					end
				end
			r3c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101100;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r2c0;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r3c0;
					end
				end
			r2c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101000;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r1c0;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r2c0;
					end
				end
			r1c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b100100;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r0c0;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r1c0;
					end
				end
			r0c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b100000;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r0c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r0c0;
					end
				end
			r0c2://cot
				begin
					mux_ctrl_0 		 	= 1'b1;
					demux_ctrl_0 		= 1'b1;
					mux_ctrl_1			= 1'b1;
					demux_ctrl_1		= 1'b1;
					ce_cnt 			 	= 1'b1;
					reset					= 1'b1;
					addr				 	= 6'b000010;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b1;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b0;
					we_U					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_V			= 1'b1;
						next_state 	= r0c1;
					end
					else begin
						we_A			= 1'b0;
						we_V			= 1'b0;
						next_state	= r0c2;
					end
				end
			r0c1://cot
				begin
					mux_ctrl_0 		 	= 1'b1;
					demux_ctrl_0 		= 1'b1;
					mux_ctrl_1			= 1'b1;
					demux_ctrl_1		= 1'b1;
					ce_cnt 			 	= 1'b1;
					reset					= 1'b1;
					addr				 = 6'b000001;
					sel_cordic_rot	 = 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b1;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b0;
					we_U					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_V			= 1'b1;
						next_state 	= r6c1;
					end
					else begin
						we_A			= 1'b0;
						we_V			= 1'b0;
						next_state	= r0c1;
					end
				end
			r6c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 = 6'b111001;
					sel_cordic_rot	 = 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r5c1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r6c1;
					end
				end
			r5c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 = 6'b110101;
					sel_cordic_rot	 = 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r4c1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r5c1;
					end
				end
			r4c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 = 6'b110001;
					sel_cordic_rot	 = 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r3c1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r4c1;
					end
				end
			r3c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101101;
					sel_cordic_rot	 	= 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r2c1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r3c1;
					end
				end
			r2c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101001;
					sel_cordic_rot	 	= 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r1c1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r2c1;
					end
				end
			r1c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b100101;
					sel_cordic_rot	 	= 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r1c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r1c1;
					end
				end
			r1c2://cot
				begin
					mux_ctrl_0 		 	= 1'b1;
					demux_ctrl_0 		= 1'b1;
					mux_ctrl_1			= 1'b1;
					demux_ctrl_1		= 1'b1;
					ce_cnt 			 	= 1'b1;
					reset					= 1'b1;
					addr				 	= 6'b000110;
					sel_cordic_rot	 	= 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b1;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b0;
					we_U					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_V			= 1'b1;
						next_state 	= r6c2;
					end
					else begin
						we_A			= 1'b0;
						we_V			= 1'b0;
						next_state	= r1c2;
					end
				end
			r6c2://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b111010;
					sel_cordic_rot		= 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r5c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r6c2;
					end
				end
			r5c2://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 = 6'b110110;
					sel_cordic_rot	 = 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r4c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r5c2;
					end
				end
			r4c2://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b110010;
					sel_cordic_rot	 	= 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r3c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r4c2;
					end
				end
			r3c2://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101110;
					sel_cordic_rot	 	= 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r2c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r3c2;
					end
				end
			r2c2://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101001;
					sel_cordic_rot	 	= 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r6c3;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r2c2;
					end
				end
			r6c3://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b111011;
					sel_cordic_rot		= 3'b011;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r5c3;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r6c3;
					end
				end
			r5c3://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 = 6'b110111;
					sel_cordic_rot	 = 3'b011;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r4c3;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r5c3;
					end
				end
			r4c3://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b110010;
					sel_cordic_rot	 	= 3'b011;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= r3c3;
					end
					else begin
						we_A				= 1'b0;
						we_U			= 1'b0;
						next_state	= r4c3;
					end
				end
			r3c3://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101110;
					sel_cordic_rot	 	= 3'b011;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= c_r0c0;
						cal_eyes		= 1'b1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r3c3;
					end
				end
			c_r0c0:// Duong cheo, theo cot, tai r0c0
				begin
					mux_ctrl_0 		 	= 1'b1;
					demux_ctrl_0 		= 1'b1;
					mux_ctrl_1			= 1'b1;
					demux_ctrl_1		= 1'b1;
					ce_cnt 			 	= 1'b1;
					reset					= 1'b1;
					addr				 	= 6'b000000;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b0;
					we_U					= 1'b0;
					cal_eyes				= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_V			= 1'b1;
						next_state 	= r_r0c0;
					end
					else begin
						we_A			= 1'b0;
						we_V			= 1'b0;
						next_state	= c_r0c0;
					end
				end
			r_r0c0://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b100000;
					sel_cordic_rot	 	= 3'b000;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					cal_eyes				= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= c_r1c1;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r_r0c0;
					end
				end
			c_r1c1:// Duong cheo, theo cot, tai r1c1
				begin
					mux_ctrl_0 		 	= 1'b1;
					demux_ctrl_0 		= 1'b1;
					mux_ctrl_1			= 1'b1;
					demux_ctrl_1		= 1'b1;
					ce_cnt 			 	= 1'b1;
					reset					= 1'b1;
					addr				 	= 6'b000101;
					sel_cordic_rot	 	= 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b0;
					we_U					= 1'b0;
					cal_eyes				= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_V			= 1'b1;
						next_state 	= r_r1c1;
					end
					else begin
						we_A			= 1'b0;
						we_V			= 1'b0;
						next_state	= c_r1c1;
					end
				end
			r_r1c1://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b100101;
					sel_cordic_rot	 	= 3'b001;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					cal_eyes				= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						next_state 	= c_r2c2;
					end
					else begin
						we_A			= 1'b0;
						we_U			= 1'b0;
						next_state	= r_r1c1;
					end
				end
			c_r2c2:// Duong cheo, theo cot, tai r2c2
				begin
					mux_ctrl_0 		 	= 1'b1;
					demux_ctrl_0 		= 1'b1;
					mux_ctrl_1			= 1'b1;
					demux_ctrl_1		= 1'b1;
					ce_cnt 			 	= 1'b1;
					reset					= 1'b1;
					addr				 	= 6'b001010;
					sel_cordic_rot	 	= 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b0;
					we_U					= 1'b0;
					cal_eyes				= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_V			= 1'b1;
						next_state 	= r_r2c2;
					end
					else begin
						we_A			= 1'b0;
						we_V			= 1'b0;
						next_state	= c_r2c2;
					end
				end
			r_r2c2://Hang
				begin
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b1;
					demux_ctrl_1		= 1'b0;
					reset					= 1'b1;
					ce_cnt 			 	= 1'b1;
					addr				 	= 6'b101001;
					sel_cordic_rot	 	= 3'b010;
					ce_cordic_slot0_A = 1'b1;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b1;
					ce_cordic_slot1_UV= 1'b1;
					we_V					= 1'b0;
					cal_eyes				= 1'b1;
					if(cnt_svd == 5'd17)begin
						ce_cnt 		= 1'b0;
						we_A 			= 1'b1;
						we_U			= 1'b1;
						if(cnt_eyes>=7'd96)begin
							next_state = load_out_matrix;
						end
						else begin
							next_state 	= c_r0c0;
						end
					end
					else begin
						we_A				= 1'b0;
						we_U			= 1'b0;
						next_state	= r_r2c2;
					end
				end
			load_out_matrix:
				begin
					en_load_out			= 1'b1;
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b0;
					demux_ctrl_1		= 1'b0;
					we_A 					= 1'b0;
					we_U					= 1'b0;
					we_V					= 1'b0;
					addr					= 6'b000000;
					ce_cordic_slot0_A = 1'b0;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b0;
					ce_cordic_slot1_UV= 1'b0;
					ce_cnt 			 	= 1'b0;
					cal_eyes				= 1'b0;
					sel_cordic_rot	 	= 3'b000;
					reset					= 1'b1;
					next_state			= load_in_matrix;
				end
			default:
				begin
					en_load_out			= 1'b1;
					mux_ctrl_0 		 	= 1'b1;
					mux_ctrl_1			= 1'b0;
					demux_ctrl_0 	 	= 1'b0;
					demux_ctrl_1		= 1'b0;
					we_A 					= 1'b0;
					we_U					= 1'b0;
					we_V					= 1'b0;
					addr					= 6'b000000;
					ce_cordic_slot0_A = 1'b0;
					ce_cordic_slot1_A = 1'b0;
					ce_cordic_slot0_UV= 1'b0;
					ce_cordic_slot1_UV= 1'b0;
					ce_cnt 			 	= 1'b0;
					cal_eyes				= 1'b0;
					sel_cordic_rot	 	= 3'b000;
					reset					= 1'b1;
					next_state			= load_in_matrix;
				end
		endcase
	end

endmodule
