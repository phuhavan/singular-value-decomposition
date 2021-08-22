// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module process
#(
	parameter WIDTH=24,
	parameter WIDTH_SHIFT_BIT= 4 // so luong bit 
)
(
	input										sign_rotation,
	input 									clk,
	input										rst_n,
	input 	[WIDTH-1:0] 				x_in,
	input 	[WIDTH-1:0] 				y_in,
	input		[WIDTH_SHIFT_BIT-1:0]	shift_bit,
	input 									sign_in,
	input										sel,
	input										ce,
	output 									sign_out,
	output 	[WIDTH-1:0]					x_out,
	output	[WIDTH-1:0]					y_out,
	output 	[WIDTH-1:0]		wir_mux_x,wir_mux_y,
	output 	[WIDTH-1:0]		wir_shift_x,wir_shift_y,
	output	[WIDTH-1:0]		wir_add_sub_x,wir_add_sub_y,
	output 	[WIDTH-1:0] 	wir_rot_x,wir_rot_y
);

//wire 	[WIDTH-1:0] 	wir_rot_x,wir_rot_y;
//wire 	[WIDTH-1:0]		wir_mux_x,wir_mux_y;
//wire 	[WIDTH-1:0]		wir_shift_x,wir_shift_y;
//wire	[WIDTH-1:0]		wir_add_sub_x,wir_add_sub_y;	

rotation90
#(
  .WIDTH (WIDTH)    // Counter width
)
rotation90_process
(
	.sign_rotation(sign_rotation),
	.x_in  (x_in),
	.y_in  (y_in),
	.x_out (wir_rot_x),
	.y_out (wir_rot_y)
);

mux
#(
	.WIDTH (WIDTH)
)
mux_x
(
	.clk(clk),
	.rst(rst_n),
	.in0(wir_rot_x),
	.in1(wir_add_sub_x),
	.ce(ce),
	.sel(sel),
	.out(wir_mux_x),//loi
	.msb()
);

mux
#(
	.WIDTH (WIDTH)
)
mux_y
(
	.clk(clk),
	.rst(rst_n),
	.in0(wir_rot_y),
	.in1(wir_add_sub_y),
	.ce(ce),
	.sel(sel),
	.out(wir_mux_y),
	.msb(sign_out)
);

shift
#(
	.WIDTH				(WIDTH),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT)
)
shift_x
(
	.shift_bit	(shift_bit), //xac dinh dich bao nhieu bit
	.data_in		(wir_mux_y),
	.data_out	(wir_shift_x)
);

shift
#(
	.WIDTH				(WIDTH),
	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT)
)
shift_y
(

	.shift_bit	(shift_bit), //xac dinh dich bao nhieu bit
	.data_in		(wir_mux_x),
	.data_out	(wir_shift_y)
);

add_sub
#(
	.WIDTH	(WIDTH)
)
add_sub_x
(
	.b			(wir_shift_x)	,
	.a			(wir_mux_x)	,
	.sign		(!sign_in)	,		
	.result	(wir_add_sub_x)	
);

add_sub
#(
	.WIDTH	(WIDTH)
)
add_sub_y
(
	.b			(wir_shift_y)	,
	.a			(wir_mux_y)	,
	.sign		(sign_in)	,		
	.result	(wir_add_sub_y)	
);

mulk
#(
	.WIDTH		(WIDTH)
)
mulk_x
(
	.data_in		(wir_add_sub_x),
	.data_out	(x_out)
);

mulk
#(
	.WIDTH	(WIDTH)
)
mulk_y
(
	.data_in		(wir_add_sub_y),
	.data_out	(y_out)
);
endmodule
