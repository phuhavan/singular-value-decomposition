// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module cordic4x2
#(

	parameter 	WIDTH=24,
	parameter	WIDTH_SHIFT_BIT=4,
	parameter	WIDTH_INDEX=2
)
(
	input									clk,
	input									rst_n,
	input		[WIDTH-1:0]				x_in0,
	input		[WIDTH-1:0]				y_in0,
	input		[WIDTH-1:0]				x_in1,
	input		[WIDTH-1:0]				y_in1,
	input		[WIDTH-1:0]				x_in2,
	input		[WIDTH-1:0]				y_in2,
	input		[WIDTH-1:0]				x_in3,
	input		[WIDTH-1:0]				y_in3,
	input		[1:0]						index,		//chon bo cordic nao de xoay theo
	input									ce,	// chip enable: can thiep vao bo mux
	output								sel,
	input									sign_in,
	output								sign_out,
	output 	[WIDTH-1:0]				x_out0,
	output	[WIDTH-1:0]				y_out0,
	output 	[WIDTH-1:0]				x_out1,
	output	[WIDTH-1:0]				y_out1,
	output 	[WIDTH-1:0]				x_out2,
	output	[WIDTH-1:0]				y_out2,
	output 	[WIDTH-1:0]				x_out3,
	output	[WIDTH-1:0]				y_out3,
	
	output	[WIDTH-1:0]wir_mux_x,
	output	[WIDTH-1:0]wir_mux_y,
	output	[WIDTH-1:0]wir_shift_x,
	output	[WIDTH-1:0]wir_shift_y,
	output	[WIDTH-1:0]wir_add_sub_x,
	output	[WIDTH-1:0]wir_add_sub_y,
	output	[WIDTH-1:0]wir_rot_x,
	output	[WIDTH-1:0]wir_rot_y
	
);

wire	[WIDTH_SHIFT_BIT-1:0]	shift;
//wire									sign;
//wire									sel;
wire									msb0,msb1,msb2,msb3;

process
#(
	.WIDTH				(WIDTH				),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT	)// so luong bit 
)
process0
(
	.clk(clk),
	.rst_n(rst_n),
	.x_in(x_in0),
	.y_in(y_in0),
	.shift_bit(shift),
	.sign_in(sign_in),
	.sel(sel),
	.ce(ce),
	.sign_out(msb0),
	.x_out(x_out0),
	.y_out(y_out0)
	//.wir_mux_x(				wir_mux_x),
	//.wir_mux_y(             wir_mux_y),
	//.wir_shift_x(           wir_shift_x),
	//.wir_shift_y(           wir_shift_y),
	//.wir_add_sub_x(         wir_add_sub_x),
	//.wir_add_sub_y(         wir_add_sub_y),
	//.wir_rot_x(             wir_rot_x),
	//.wir_rot_y(             wir_rot_y)
);


process
#(
	.WIDTH				(WIDTH				),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT	)// so luong bit 
)
process1
(
	.clk(clk),
	.rst_n(rst_n),
	.x_in(x_in1),
	.y_in(y_in1),
	.shift_bit(shift),
	.sign_in(sign_in),
	.sel(sel),
	.ce(ce),
	.sign_out(msb1),
	.x_out(x_out1),
	.y_out(y_out1)
	//wir_mux_x,wir_mux_y,
	//wir_shift_x,wir_shift_y,
	//wir_add_sub_x,wir_add_sub_y,
	//wir_rot_x,wir_rot_y
);


process
#(
	.WIDTH				(WIDTH				),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT	)// so luong bit 
)
process2
(
	.clk(clk),
	.rst_n(rst_n),
	.x_in(x_in2),
	.y_in(y_in2),
	.shift_bit(shift),
	.sign_in(sign_in),
	.sel(sel),
	.ce(ce),
	.sign_out(msb2),
	.x_out(x_out2),
	.y_out(y_out2)
	//wir_mux_x,wir_mux_y,
	//wir_shift_x,wir_shift_y,
	//wir_add_sub_x,wir_add_sub_y,
	//wir_rot_x,wir_rot_y
);

process
#(
	.WIDTH				(WIDTH				),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT	)// so luong bit 
)
process3
(
	.clk(clk),
	.rst_n(rst_n),
	.x_in(x_in3),
	.y_in(y_in3),
	.shift_bit(shift),
	.sign_in(sign_in),
	.sel(sel),
	.ce(ce),
	.sign_out(msb3),
	.x_out(x_out3),
	.y_out(y_out3),
	.wir_mux_x(				wir_mux_x),
	.wir_mux_y(             wir_mux_y),
	.wir_shift_x(           wir_shift_x),
	.wir_shift_y(           wir_shift_y),
	.wir_add_sub_x(         wir_add_sub_x),
	.wir_add_sub_y(         wir_add_sub_y),
	.wir_rot_x(             wir_rot_x),
	.wir_rot_y(             wir_rot_y)
);

mux4x1 mux4x1
(
	.clk(clk)	,
	.rst(rst_n)	,
	.in0(msb0)	,
	.in1(msb1)	,
	.in2(msb2)	,
	.in3(msb3)	,
	.sel(index)	,
	.ce (ce)	,	
	.out(sign_out)
);


control
#(
	.WIDTH				(WIDTH),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT)
)
control
(
	.rst_n	(rst_n),
	.clk		(clk),
	.sel		(sel),
	.shift_bit(shift),
	.start(ce)
	//.count()
);

endmodule