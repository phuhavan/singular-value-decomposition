// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module svd8x4
#(
	parameter data_width = 24,	// Do rong du lieu cua 1 phan tu nho
	parameter addr_row=3,		// Dia chi hang
	parameter addr_column=2,	// Dia chi cot
	parameter addr_width = addr_row+addr_column+1,	// |1bit|3bit|2bit| *1bit: xac dinh hang/|cot *3bit:hang  *2bit:cot
	parameter mem_size = 2**(addr_width-1),
	parameter width = data_width*2*8,
	parameter data_cordic = 16*data_width,
	parameter width_shamt = 4
)
(
	input		[data_cordic-1:0]		data_in,
	input									clk,rst_n,
	input									ce_svd,			// cho phep tinh svd
	output	[data_cordic-1:0]		data_out_A,data_out_U,data_out_V,
	output	[4:0]						counter,
	output								en_out_svd		//// tin hieu bao co dau ra svd
);
//------------------------------------------------------------------------------------------------
//Wire
//------------------------------------------------------------------------------------------------	
	wire		[data_cordic-1:0]	data_out_dram_A;		// Du lieu tu Dram
	wire		[data_cordic-1:0]	data_out_dram_V;		// Du lieu tu Dram_V
	wire		[data_cordic-1:0]	data_out_dram_U;		// Du lieu tu Dram_U
	wire								ce_cordic_slot0_A;	// enable/disable cordic slot 0
	wire								ce_cordic_slot1_A;	// enable/disable cordic slot 1
	wire								ce_cordic_slot0_UV;	// enable/disable gian tiep cordic slot 0 cua UV
	wire								ce_cordic_slot1_UV;	// enable/disable gian tiep cordic slot 1 cua UV
	wire								mux_ctrl_0;			// Lua chon giua data_in va data_out_dram_A
	wire								demux_ctrl_0;			// dua ra du lieu data_out_svd_A va data_out_dram_A
	wire								mux_ctrl_1;				// Lua chon giua du lieu Dram_U va Dram_V
	wire								demux_ctrl_1;			// dua du lieu vao Dram_U hoac Dram_V
	wire		[2:0]					sel_cordic_rot;	// lua chon phan tu duoc xoay trong cordic
	wire								ce_cnt;				// Cho phep hoat dong bo dem
	wire		[4:0]					cnt_svd;				// Tra lai gia tri bo dem cho khoi control unit
	wire		[data_cordic-1:0]	data_in_dram_A;		// Du lieu nap vao Dram
	wire		[data_cordic-1:0]	data_in_dram_U;		// Du lieu nap vao Dram_U
	wire		[data_cordic-1:0]	data_in_dram_V;		// Du lieu nap vao Dram_V
	wire		[data_cordic-1:0]	data_out_svd_A;
	wire		[data_cordic-1:0]	data_out_svd_U;
	wire		[data_cordic-1:0]	data_out_svd_V;
	wire		[addr_width-1:0]	addr;					//	Xuat ra dia chi cho Dram
	wire								we_A;					//	Dieu khien viec doc/ghi cua Dram
	wire								we_U;						//	Dieu khien viec doc/ghi cua Dram_U
	wire								we_V;						//	Dieu khien viec doc/ghi cua Dram_V
	wire								reset;					// Reset 2 ma tran U va V ve duong cheo
	wire								en_load_out;		// tin hieu bao co dau ra svd
	wire		[5:0]					addr_U;				// Dung de load ma tran ra
	wire		[5:0]					re_addr_U;			// result addr U
//------------------------------------------------------------------------------------------------
//Assign
//------------------------------------------------------------------------------------------------
	assign data_out_A = data_out_svd_A;
	assign data_out_U	= data_out_svd_U;
	assign data_out_V	= data_out_svd_V;
	assign counter  = cnt_svd;
	assign en_out_svd = en_load_out;
	assign addr_U = 6'b100000;
	
	mux_two_ins #(.data_width(6)) mux_addr(.in0(addr),.in1(addr_U),.mux_two(en_load_out),.out0(re_addr_U));
	
//------------------------------------------------------------------------------------------------
//Module: Data path
//------------------------------------------------------------------------------------------------
	data_path #(
					.width			(data_width),
					.data_cordic	(data_cordic),
					.width_shamt	(width_shamt)
					)
		data_unit(
					.data_in 				(data_in),		
					.data_out_dram_A 		(data_out_dram_A),	
					.data_out_dram_V		(data_out_dram_V),
					.data_out_dram_U 		(data_out_dram_U),
					.clk 						(clk),
					.rst_n 					(rst_n),
					.ce_svd					(ce_svd),
					.ce_cordic_slot0_A	(ce_cordic_slot0_A),
					.ce_cordic_slot1_A	(ce_cordic_slot1_A),
					.ce_cordic_slot0_UV	(ce_cordic_slot0_UV),
					.ce_cordic_slot1_UV	(ce_cordic_slot1_UV),
					.mux_ctrl_0 			(mux_ctrl_0),		
					.demux_ctrl_0			(demux_ctrl_0),	
					.mux_ctrl_1				(mux_ctrl_1),		
					.demux_ctrl_1			(demux_ctrl_1),
					.sel_cordic_rot		(sel_cordic_rot),	
					.ce_cnt 					(ce_cnt),		
					.cnt_svd 				(cnt_svd),		
					.data_in_dram_A		(data_in_dram_A),
					.data_in_dram_U		(data_in_dram_U),	
					.data_in_dram_V		(data_in_dram_V),
					.data_out_svd_A		(data_out_svd_A),
					.data_out_svd_U		(data_out_svd_U),
					.data_out_svd_V		(data_out_svd_V)
		);

//------------------------------------------------------------------------------------------------
//Module: Control Unit 
//------------------------------------------------------------------------------------------------		
	control_unit_svd #(.addr_width(addr_width))
		control_unit(
					.cnt_svd 				(cnt_svd),	
					.ce_svd		      	(ce_svd),		
					.clk              	(clk),
					.rst_n            	(rst_n),
					.ce_cordic_slot0_A	(ce_cordic_slot0_A),	
					.ce_cordic_slot1_A	(ce_cordic_slot1_A),	
					.ce_cordic_slot0_UV	(ce_cordic_slot0_UV),							
					.ce_cordic_slot1_UV	(ce_cordic_slot1_UV),
					.mux_ctrl_0 			(mux_ctrl_0),			
					.demux_ctrl_0 			(demux_ctrl_0),
					.mux_ctrl_1				(mux_ctrl_1),									
					.demux_ctrl_1			(demux_ctrl_1),
					.sel_cordic_rot		(sel_cordic_rot),
					.ce_cnt 					(ce_cnt),				
					.addr 					(addr),				
					.we_A						(we_A),
					.we_U				    	(we_U),				
					.we_V						(we_V),
					.reset					(reset),
					.en_load_out			(en_load_out)
		);

//------------------------------------------------------------------------------------------------
//Module: Dram_A
//------------------------------------------------------------------------------------------------
	store_A		#(
					.data_width		 (data_width), 
					.no_of_row       (addr_row),
					.no_of_col    (addr_column),
					.max_no_of_row_col(3),
					.addr_width     (addr_width)
				)
		dram_svd_A(
					.data_in 		 (data_in_dram_A),
					.addr           (addr),
					.clk            (clk),
					.rst_n			(reset),
					.we             (we_A),
					.data_out       (data_out_dram_A)
		);
//------------------------------------------------------------------------------------------------
//Module: Dram_V
//------------------------------------------------------------------------------------------------
	store_V		#(
					.data_width		 (data_width), 
					.no_of_row       (addr_row),
					.no_of_col    (addr_column),
					.max_no_of_row_col(3),
					.addr_width     (addr_width)
				)
		dram_svd_V(
					.data_in			(data_in_dram_V),
					.addr			(addr),
					.clk				(clk),
					.rst_n			(reset),
					.we				(we_V),
					.data_out		(data_out_dram_V)
		);
//------------------------------------------------------------------------------------------------
//Module: Dram_U
//------------------------------------------------------------------------------------------------
	store_U		#(
					.data_width		 (data_width), 
					.no_of_row       (addr_row),
					.no_of_col    (addr_column),
					.max_no_of_row_col(3),
					.addr_width     (addr_width)
				)
		dram_svd_U(
					.data_in			(data_in_dram_U),
					.addr			(re_addr_U),
					.clk				(clk),
					.rst_n			(reset),
					.we				(we_U),
					.data_out		(data_out_dram_U)
		);
endmodule
