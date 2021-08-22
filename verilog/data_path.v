// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha


module data_path
#(
	parameter	width = 24,			//data width
	parameter	data_cordic = 16*width,
	parameter	width_shamt = 4
)
(
	input			[data_cordic-1:0]	data_in,				// Du lieu ben ngoai
	input			[data_cordic-1:0]	data_out_dram_A,	// Du lieu tu Dram_A
	input			[data_cordic-1:0]	data_out_dram_V,	// Du lieu tu Dram_V
	input			[data_cordic-1:0]	data_out_dram_U,	// Du lieu tu Dram_U
	input									clk,rst_n,
	input									ce_svd,
	input									ce_cordic_slot0_A,	// enable/disable gian tiep cordic slot 0 cua A
	input									ce_cordic_slot1_A,	// enable/disable gian tiep cordic slot 1 cua A
	input									ce_cordic_slot0_UV,	// enable/disable gian tiep cordic slot 0 cua UV
	input									ce_cordic_slot1_UV,	// enable/disable gian tiep cordic slot 1 cua UV
	input									mux_ctrl_0,			// Lua chon giua data_in va data_out_dram_A
	input									demux_ctrl_0,		// dua ra du lieu data_out_svd_A va data_out_dram_A
	input									mux_ctrl_1,				// Lua chon giua du lieu Dram_U va Dram_V
	input									demux_ctrl_1,			// dua du lieu vao Dram_U hoac Dram_V
	input			[2:0]					sel_cordic_rot,	// lua chon phan tu duoc xoay trong cordic
	input									ce_cnt,				// Cho phep hoat dong bo dem
	output 		[4:0]					cnt_svd,				// Tra lai gia tri bo dem cho khoi control unit
	output		[data_cordic-1:0]	data_in_dram_A,		// Du lieu nap vao Dram
	output		[data_cordic-1:0]	data_in_dram_U,		// Du lieu nap vao Dram_U
	output		[data_cordic-1:0]	data_in_dram_V,		// Du lieu nap vao Dram_V
	output		[data_cordic-1:0]	data_out_svd_A,
	output		[data_cordic-1:0]	data_out_svd_U,
	output		[data_cordic-1:0]	data_out_svd_V
);

//--------------------------------------------------------------------------------------------------
//Sinal Declarations: wire
//--------------------------------------------------------------------------------------------------			
	wire		[data_cordic-1:0]		data_in_cordic_A;	// Du lieu vao cordic A
	wire		[data_cordic-1:0]		data_out_cordic_A;	// Du lieu ra cordic A
	wire		[data_cordic-1:0]		data_in_cordic_UV;	// Du lieu vao cordic UV
	wire		[data_cordic-1:0]		data_in_cordic_U;		// Du lieu vao cordic U
	wire		[data_cordic-1:0]		data_in_cordic_V;		// Du lieu vao cordic V
	wire		[data_cordic-1:0]		data_out_cordic_UV;	// Du lieu ra cordic UV
	wire									en_slot0_A;			// Bat tat truc tiep cordic slot 0 cua A
	wire									en_slot1_A;			// Bat tat truc tiep cordic slot 1
	wire									en_slot0_UV;			// Bat tat truc tiep cordic slot 0 UV
	wire									en_slot1_UV;			// Bat tat truc tiep cordic slot 1 UV
	wire 		[width_shamt-1:0]		shift_bit_A;		// Dua tin hieu shift_bit cho khoi cordic_top_UV
	wire 									mux_ctrl_A;			// Dua tin hieu mux_ctrl cho khoi cordic_top_UV
	wire 									msb_rot_A;			// Dua tin hieu msb_rot cho khoi cordic_top_UV
	wire									signbit;				// Dua tin hieu sign_in cho khoi cordic_top_UV
//--------------------------------------------------------------------------------------------------
//Sinal Declarations: reg
//--------------------------------------------------------------------------------------------------
	reg		[4:0]		count;	// Bo dem de tinh cordic
//--------------------------------------------------------------------------------------------------
//assign
//--------------------------------------------------------------------------------------------------
	assign cnt_svd = count;
	assign en_slot0_A	= ((count<=5'd16)&&(count>=5'd1)) ? ce_cordic_slot0_A : 1'b0;
	assign en_slot1_A	= ((count<=5'd16)&&(count>=5'd1)) ? ce_cordic_slot1_A : 1'b0;
	assign en_slot0_UV= ((count<=5'd16)&&(count>=5'd1)) ? ce_cordic_slot0_UV : 1'b0;
	assign en_slot1_UV= ((count<=5'd16)&&(count>=5'd1)) ? ce_cordic_slot1_UV : 1'b0;
//--------------------------------------------------------------------------------------------------
//Bo dem
	always @ (posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			count <= 5'b0;
		end
		else if(ce_cnt&&ce_svd)begin
			if(count==5'd17)	count <= 5'b0;
			else					count <= count +5'b1;
		end
		else if(!ce_cnt)begin
			count <= 5'b0;
		end
	end
//--------------------------------------------------------------------------------------------------
//Module: mux_two_0
//Chon giua du lieu data_in va du lieu data_out_cordic_A
//--------------------------------------------------------------------------------------------------	
	mux_two_ins # (.data_width(data_cordic))
		mux_two_0(
					.in0			(data_in),
					.in1			(data_out_cordic_A),
					.mux_two		(mux_ctrl_0),
					.out0			(data_in_dram_A)
				);
//--------------------------------------------------------------------------------------------------
//Module: mux_two_1
//Chon giua du lieu data_in_cordic_U va data_in_cordic_V
//--------------------------------------------------------------------------------------------------	
	mux_two_ins # (.data_width(data_cordic))
		mux_two_1(
					.in0			(data_in_cordic_U),
					.in1			(data_in_cordic_V),
					.mux_two		(mux_ctrl_1),
					.out0			(data_in_cordic_UV)
				);			
//--------------------------------------------------------------------------------------------------
//Module: demux_two_0
//Dan du lieu vao data_out_dram_A
//--------------------------------------------------------------------------------------------------	
	demux_two_ins # (.data_width(data_cordic))
		demux_two(
					.in0			(data_out_dram_A),
					.demux_two	(demux_ctrl_0),
					.out0			(data_out_svd_A),			// Du lieu ra
					.out1			(data_in_cordic_A)
		);
//--------------------------------------------------------------------------------------------------
//Module: demux_two_1
//Dan du lieu vao data_out_dram_U
//--------------------------------------------------------------------------------------------------	
	demux_two_ins # (.data_width(data_cordic))
		demux_two_1(
					.in0			(data_out_dram_U),
					.demux_two	(demux_ctrl_0),
					.out0			(data_out_svd_U),			// Du lieu ra
					.out1			(data_in_cordic_U)
		);	
//--------------------------------------------------------------------------------------------------
//Module: demux_two_2
//Dan du lieu vao data_out_dram_V
//--------------------------------------------------------------------------------------------------	
	demux_two_ins # (.data_width(data_cordic))
		demux_two_2(
					.in0			(data_out_dram_V),
					.demux_two	(demux_ctrl_0),
					.out0			(data_out_svd_V),			// Du lieu ra
					.out1			(data_in_cordic_V)
		);	
//--------------------------------------------------------------------------------------------------
//Module: demux_two_3
//Dan du lieu vao data_out_dram_UV
//--------------------------------------------------------------------------------------------------	
	demux_two_ins # (.data_width(data_cordic))
		demux_two_3(
					.in0			(data_out_cordic_UV),
					.demux_two	(demux_ctrl_1),
					.out0			(data_in_dram_U),
					.out1			(data_in_dram_V)
		);
//--------------------------------------------------------------------------------------------------
//Module: cordic_top
//Tinh toan cordic
//--------------------------------------------------------------------------------------------------		
	cordic2x8_A #(
						.WIDTH			(width),
						.WIDTH_SHIFT_BIT(width_shamt),
						.WIDTH_INDEX	(3)
					)
		cordic_2x8_A(
					.data_in		(data_in_cordic_A),
					.clk			(clk),
					.rst_n		(rst_n),
					.index		(sel_cordic_rot),
					.ce0			(en_slot0_A),
					.ce1			(en_slot1_A),
					.data_out	(data_out_cordic_A),
					.shift(shift_bit_A),
					.sel	(mux_ctrl_A),
					.sign_rotation	(msb_rot_A),
					.sign_out		(signbit)
					);
//--------------------------------------------------------------------------------------------------
//Module: cordic_top_UV
//Tinh toan cordic UV
//--------------------------------------------------------------------------------------------------		
	cordic2x8_UV #(
						.WIDTH			(width),
						.WIDTH_SHIFT_BIT(width_shamt),
						.WIDTH_INDEX	(3)
					)
		cordic_2x8_UV(
					.data_in		(data_in_cordic_UV),
					.clk			(clk),
					.rst_n		(rst_n),
					.index(sel_cordic_rot),
					.ce0			(en_slot0_UV),
					.ce1			(en_slot1_UV),
					.data_out	(data_out_cordic_UV),
					.shift(shift_bit_A),
					.sel	(mux_ctrl_A),
					.sign_rotation	(msb_rot_A),
					.sign_in		(signbit)
		);
endmodule
