// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module cordic2x8_UV
#(
	parameter	WIDTH=24,
	parameter 	WIDTH_SHIFT_BIT=4,
	parameter	WIDTH_INDEX=3
)
(
	input 								clk,
	input 								rst_n,
	input			[383:0]	data_in,
	
	input									ce1,ce0,
	input	[WIDTH_SHIFT_BIT-1:0]	shift,count,
	input							sel,
	input								sign_in,
	input					sign_rotation,
	input		[2:0]						index,
	
	output			[383:0]	data_out,
	output	[WIDTH-1:0]wir_mux_x,
	output	[WIDTH-1:0]wir_mux_y,
	output	[WIDTH-1:0]wir_shift_x,
	output	[WIDTH-1:0]wir_shift_y,
	output	[WIDTH-1:0]wir_add_sub_x,
	output	[WIDTH-1:0]wir_add_sub_y,
	output	[WIDTH-1:0]wir_rot_x,
	output	[WIDTH-1:0]wir_rot_y
);

	wire	[WIDTH-1:0]				x_out0,x_out1,x_out2,x_out3,x_out4,x_out5,x_out6,x_out7;
	wire	[WIDTH-1:0]				y_out0,y_out1,y_out2,y_out3,y_out4,y_out5,y_out6,y_out7;
	
	wire 	[WIDTH-1:0]				x_in0,x_in1,x_in2,x_in3,x_in4,x_in5,x_in6,x_in7;		
	wire 	[WIDTH-1:0]				y_in0,y_in1,y_in2,y_in3,y_in4,y_in5,y_in6,y_in7;
	assign {y_in7,y_in6,y_in5,y_in4,y_in3,y_in2,y_in1,y_in0,x_in7,x_in6,x_in5,x_in4,x_in3,x_in2,x_in1,x_in0} = data_in;
	assign data_out = {y_out7,y_out6,y_out5,y_out4,y_out3,y_out2,y_out1,y_out0,x_out7,x_out6,x_out5,x_out4,x_out3,x_out2,x_out1,x_out0};
	



process2x4_UV
#(

	.WIDTH					(WIDTH),
	.WIDTH_SHIFT_BIT		(WIDTH_SHIFT_BIT),
	.WIDTH_INDEX			(WIDTH_INDEX)
)
process2x4_0
(
	.clk		(clk),
	.rst_n	(rst_n),
	.x_in0	(x_in0),
	.y_in0	(y_in0),
	.x_in1	(x_in1),
	.y_in1	(y_in1),
	.x_in2	(x_in2),
	.y_in2	(y_in2),
	.x_in3	(x_in3),
	.y_in3	(y_in3),
	.index	(index[1:0]),
	.ce		(ce0),
	.sel		(sel),
	.shift	(shift),
	.sign_rotation(sign_rotation),
	.sign_in(sign_in),
	//.sign_out(sign_out0),
	.x_out0	(x_out0),
	.y_out0	(y_out0),
	.x_out1	(x_out1),
	.y_out1	(y_out1),
	.x_out2	(x_out2),
	.y_out2	(y_out2),
	.x_out3	(x_out3),
	.y_out3	(y_out3),
	
	//.reg_y_out0(reg_y_out0),
	.count(count),
	
	.wir_mux_x(				wir_mux_x),
	.wir_mux_y(             wir_mux_y),
	.wir_shift_x(           wir_shift_x),
	.wir_shift_y(           wir_shift_y),
	.wir_add_sub_x(         wir_add_sub_x),
	.wir_add_sub_y(         wir_add_sub_y),
	.wir_rot_x(             wir_rot_x),
	.wir_rot_y(             wir_rot_y)
);


process2x4_UV
#(

	.WIDTH					(WIDTH),
	.WIDTH_SHIFT_BIT		(WIDTH_SHIFT_BIT),
	.WIDTH_INDEX			(WIDTH_INDEX)
)
process2x4_1
(
	.clk		(clk),
	.rst_n	(rst_n),
	.x_in0	(x_in4),
	.y_in0	(y_in4),
	.x_in1	(x_in5),
	.y_in1	(y_in5),
	.x_in2	(x_in6),
	.y_in2	(y_in6),
	.x_in3	(x_in7),
	.y_in3	(y_in7),
	.index	(index[1:0]),
	.ce		(ce1),
	.sel		(sel),
	.shift	(shift),
	.sign_rotation(sign_rotation),
	.count(count),
	.sign_in(sign_in),
	//.sign_out(sign_out1),
	.x_out0	(x_out4),
	.y_out0	(y_out4),
	.x_out1	(x_out5),
	.y_out1	(y_out5),
	.x_out2	(x_out6),
	.y_out2	(y_out6),
	.x_out3	(x_out7),
	.y_out3	(y_out7)
);

//control
//#(
//	.WIDTH				(WIDTH),
//	.WIDTH_SHIFT_BIT	(WIDTH_SHIFT_BIT)
//)
//control
//(
//	.rst_n	(rst_n),
//	.clk		(clk),
//	.sel		(sel),
//	.shift_bit(shift),
//	.count(count),
//	.start(ce0||ce1)
//	//.count()
//);

//wire[2:0] index1,index0;
//assign 	index1= (index==3'b100)?3'b000:((index==3'b101)?3'b001:((index==3'b110)?3'b010:((index==3'b111)?3'b011:3'b011)));
//assign 	index0= (index==3'b000)?3'b000:((index==3'b001)?3'b001:((index==3'b010)?3'b010:((index==3'b011)?3'b011:3'b011)));
//assign	sign_in= (index<3'b100)?sign_out0:sign_out1;
//assign sign_rotation= (index==3'b000)?y_in0[WIDTH-1]:((index==3'b001)?y_in1[WIDTH-1]:((index==3'b010)?y_in2[WIDTH-1]:((index==3'b011)?y_in3[WIDTH-1]:((index==3'b100)?y_in4[WIDTH-1]:((index==3'b101)?y_in5[WIDTH-1]:((index==3'b110)?y_in6[WIDTH-1]:((index==3'b111)?y_in7[WIDTH-1]:1'b0)))))));


endmodule