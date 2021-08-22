// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module cordic2x8_A
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
	input		[WIDTH_INDEX-1:0]		index,
	output	[WIDTH_SHIFT_BIT-1:0]	shift,count,
	
	
	output								sign_out,
	output 								sign_out0,sign_out1,
	output			[383:0]	data_out,
	output					sel,
	output					sign_rotation,
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
	


//wire	[2:0] 					index1,index0;
//wire								sign_in,sign_out0,sign_out1;
//wire						sel;
//wire	[WIDTH_SHIFT_BIT-1:0]						shift;

process2x4
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
	.sign_in(sign_out),
	.sign_out(sign_out0),
	.x_out0	(wire_x_out0),
	.y_out0	(wire_y_out0),
	.x_out1	(wire_x_out1),
	.y_out1	(wire_y_out1),
	.x_out2	(wire_x_out2),
	.y_out2	(wire_y_out2),
	.x_out3	(wire_x_out3),
	.y_out3	(wire_y_out3),
	
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


process2x4
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
	.sign_in(sign_out),
	.sign_out(sign_out1),
	.x_out0	(wire_x_out4),
	.y_out0	(wire_y_out4),
	.x_out1	(wire_x_out5),
	.y_out1	(wire_y_out5),
	.x_out2	(wire_x_out6),
	.y_out2	(wire_y_out6),
	.x_out3	(wire_x_out7),
	.y_out3	(wire_y_out7)
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
	.count(count),
	.start(ce0||ce1)
);


assign	sign_out= (index[2])?sign_out1:sign_out0;
assign sign_rotation= (index==3'b000)?y_in0[WIDTH-1]:((index==3'b001)?y_in1[WIDTH-1]:((index==3'b010)?y_in2[WIDTH-1]:((index==3'b011)?y_in3[WIDTH-1]:((index==3'b100)?y_in4[WIDTH-1]:((index==3'b101)?y_in5[WIDTH-1]:((index==3'b110)?y_in6[WIDTH-1]:((index==3'b111)?y_in7[WIDTH-1]:1'b0)))))));


// giu nguyen gia tri cua nhung gia tri truoc index

wire  	[WIDTH-1:0]				wire_x_out0;
wire 		[WIDTH-1:0]				wire_y_out0;
wire 		[WIDTH-1:0]				wire_x_out1;
wire 		[WIDTH-1:0]				wire_y_out1;
wire 		[WIDTH-1:0]				wire_x_out2;
wire 		[WIDTH-1:0]				wire_y_out2;
wire 		[WIDTH-1:0]				wire_x_out3;
wire 		[WIDTH-1:0]				wire_y_out3;


wire  		[WIDTH-1:0]				wire_x_out4;
wire 		[WIDTH-1:0]				wire_y_out4;
wire 		[WIDTH-1:0]				wire_x_out5;
wire 		[WIDTH-1:0]				wire_y_out5;
wire 		[WIDTH-1:0]				wire_x_out6;
wire 		[WIDTH-1:0]				wire_y_out6;
wire 		[WIDTH-1:0]				wire_x_out7;
wire 		[WIDTH-1:0]				wire_y_out7;





assign x_out0 =wire_x_out0;
assign x_out1 =wire_x_out1;
assign x_out2 =wire_x_out2;
assign x_out3 =wire_x_out3;
assign x_out4 =wire_x_out4;
assign x_out5 =wire_x_out5;
assign x_out6 =wire_x_out6;
assign x_out7 =wire_x_out7;

assign y_out0 =wire_y_out0;
assign y_out1 =wire_y_out1;
assign y_out2 =wire_y_out2;
assign y_out3 =wire_y_out3;
assign y_out4 =wire_y_out4;
assign y_out5 =wire_y_out5;
assign y_out6 =wire_y_out6;
assign y_out7 =wire_y_out7;

/*

assign x_out0 =(index>3'd0)?reg_x_out0:wire_x_out0;
assign x_out1 =(index>3'd1)?reg_x_out1:wire_x_out1;
assign x_out2 =(index>3'd2)?reg_x_out2:wire_x_out2;
assign x_out3 =(index>3'd3)?reg_x_out3:wire_x_out3;
assign x_out4 =(index>3'd4)?reg_x_out4:wire_x_out4;
assign x_out5 =(index>3'd5)?reg_x_out5:wire_x_out5;
assign x_out6 =(index>3'd6)?reg_x_out6:wire_x_out6;
assign x_out7 =(index>3'd7)?reg_x_out7:wire_x_out7;

assign y_out0 =(index>3'd0)?reg_y_out0:wire_y_out0;
assign y_out1 =(index>3'd1)?reg_y_out1:wire_y_out1;
assign y_out2 =(index>3'd2)?reg_y_out2:wire_y_out2;
assign y_out3 =(index>3'd3)?reg_y_out3:wire_y_out3;
assign y_out4 =(index>3'd4)?reg_y_out4:wire_y_out4;
assign y_out5 =(index>3'd5)?reg_y_out5:wire_y_out5;
assign y_out6 =(index>3'd6)?reg_y_out6:wire_y_out6;
assign y_out7 =(index>3'd7)?reg_y_out7:wire_y_out7;

	always @(posedge clk) begin
		if(!rst_n) begin
			reg_x_out0<=24'b0;
			reg_y_out0<=24'b0;
			reg_x_out1<=24'b0;
			reg_y_out1<=24'b0;
			reg_x_out2<=24'b0;
			reg_y_out2<=24'b0;
			reg_x_out3<=24'b0;
			reg_y_out3<=24'b0;
			reg_x_out4<=24'b0;
			reg_y_out4<=24'b0;
			reg_x_out5<=24'b0;
			reg_y_out5<=24'b0;
			reg_x_out6<=24'b0;
			reg_y_out6<=24'b0;
			reg_x_out7<=24'b0;
			reg_y_out7<=24'b0;
		end
		else begin
			if(count==4'b0000) begin
				reg_x_out0= x_in0;
				reg_y_out0= y_in0;
				reg_x_out1= x_in1;
				reg_y_out1= y_in1;
				reg_x_out2= x_in2;
				reg_y_out2= y_in2;
				reg_x_out3= x_in3;
				reg_y_out3= y_in3;
				reg_x_out4= x_in4;
				reg_y_out4= y_in4;
				reg_x_out5= x_in5;
				reg_y_out5= y_in5;
				reg_x_out6= x_in6;
				reg_y_out6= y_in6;
				reg_x_out7= x_in7;
				reg_y_out7= y_in7;
			end
		end
	end
*/

endmodule