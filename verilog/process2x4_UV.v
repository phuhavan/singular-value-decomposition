// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module process2x4_UV
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
	input		[1:0]						index,		//chon bo cordic nao de xoay theo: luu y dung 3 bit,
	// de neu no ko phai la 0,1,2,3 thi cai bo nay se khong
	input									ce,	// chip enable: can thiep vao bo mux
	input									sel, // chon xem co nhan du lieu tu bo rotation hay tu bo add/sub
	input									sign_in,
	input	[WIDTH_SHIFT_BIT-1:0]	shift,
	input	[WIDTH_SHIFT_BIT-1:0]	count,	
	input									sign_rotation,
	
	
	//output								sign_out,
	output 		[WIDTH-1:0]				x_out0,
	output		[WIDTH-1:0]				y_out0,
	output 		[WIDTH-1:0]				x_out1,
	output		[WIDTH-1:0]				y_out1,
	output 		[WIDTH-1:0]				x_out2,
	output		[WIDTH-1:0]				y_out2,
	output 		[WIDTH-1:0]				x_out3,
	output		[WIDTH-1:0]				y_out3,
	output		[WIDTH-1:0]wir_mux_x,
	output		[WIDTH-1:0]wir_mux_y,
	output		[WIDTH-1:0]wir_shift_x,
	output		[WIDTH-1:0]wir_shift_y,
	output		[WIDTH-1:0]wir_add_sub_x,
	output		[WIDTH-1:0]wir_add_sub_y,
	output		[WIDTH-1:0]wir_rot_x,
	output		[WIDTH-1:0]wir_rot_y
	
);

//wire	[WIDTH_SHIFT_BIT-1:0]	shift;
//wire									sign;
//wire									sel;
wire  	[WIDTH-1:0]				wire_x_out0;
wire 		[WIDTH-1:0]				wire_y_out0;
wire 		[WIDTH-1:0]				wire_x_out1;
wire 		[WIDTH-1:0]				wire_y_out1;
wire 		[WIDTH-1:0]				wire_x_out2;
wire 		[WIDTH-1:0]				wire_y_out2;
wire 		[WIDTH-1:0]				wire_x_out3;
wire 		[WIDTH-1:0]				wire_y_out3;
wire									msb0,msb1,msb2,msb3;


reg	[WIDTH-1:0]				reg_x_out0;
reg	[WIDTH-1:0]				reg_y_out0;
reg	[WIDTH-1:0]				reg_x_out1;
reg	[WIDTH-1:0]				reg_y_out1;
reg	[WIDTH-1:0]				reg_x_out2;
reg	[WIDTH-1:0]				reg_y_out2;
reg	[WIDTH-1:0]				reg_x_out3;
reg	[WIDTH-1:0]				reg_y_out3;



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
	.sign_rotation(sign_rotation),
	.sel(sel),
	.ce(ce),
	.sign_out(msb0),
	.x_out(wire_x_out0),
	.y_out(wire_y_out0)

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
	.sign_rotation(sign_rotation),
	.sel(sel),
	.ce(ce),
	.sign_out(msb1),
	.x_out(wire_x_out1),
	.y_out(wire_y_out1)

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
	.sign_rotation(sign_rotation),
	.sel(sel),
	.ce(ce),
	.sign_out(msb2),
	.x_out(wire_x_out2),
	.y_out(wire_y_out2)

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
	.sign_rotation(sign_rotation),
	.sel(sel),
	.ce(ce),
	.sign_out(msb3),
	.x_out(wire_x_out3),
	.y_out(wire_y_out3),
	.wir_mux_x(				wir_mux_x),
	.wir_mux_y(             wir_mux_y),
	.wir_shift_x(           wir_shift_x),
	.wir_shift_y(           wir_shift_y),
	.wir_add_sub_x(         wir_add_sub_x),
	.wir_add_sub_y(         wir_add_sub_y),
	.wir_rot_x(             wir_rot_x),
	.wir_rot_y(             wir_rot_y)
);

//mux4x1 mux4x1
//(
//	.clk(clk)	,
//	.rst(rst_n)	,
//	.in0(msb0)	,
//	.in1(msb1)	,
//	.in2(msb2)	,
//	.in3(msb3)	,
//	.sel(index[1:0]),
//	.ce (ce)	,	
//	.out(sign_out)
//);

assign x_out0 =wire_x_out0;
assign x_out1 =wire_x_out1;
assign x_out2 =wire_x_out2;
assign x_out3 =wire_x_out3;
assign y_out0 =wire_y_out0;
assign y_out1 =wire_y_out1;
assign y_out2 =wire_y_out2;
assign y_out3 =wire_y_out3;




//assign x_out0 =(index==2'b00)?wire_x_out0:reg_x_out0;
//assign x_out1 =(index==2'b00||index==2'b01)?wire_x_out1:reg_x_out1;
//assign x_out2 =(index==2'b00||index==2'b01||index==2'b10)?wire_x_out2:reg_x_out2;
//assign x_out3 =(index==2'b00||index==2'b01||index==2'b10||index==2'b11)?wire_x_out3:reg_x_out3;
//assign y_out0 =(index==2'b00)?wire_y_out0:reg_y_out0;
//assign y_out1 =(index==2'b00||index==2'b01)?wire_y_out1:reg_y_out1;
//assign y_out2 =(index==2'b00||index==2'b01||index==2'b10)?wire_y_out2:reg_y_out2;
//assign y_out3 =(index==2'b00||index==2'b01||index==2'b10||index==2'b11)?wire_y_out3:reg_y_out3;



//wire enable_reg;
//assign enable_reg= (count==4'b0000)?1'b1:1'b0;
//
//always @(posedge clk) begin
//	if(!rst_n) begin
//		reg_x_out0<=24'b0;
//	   reg_y_out0<=24'b0;
//	   reg_x_out1<=24'b0;
//	   reg_y_out1<=24'b0;
//	   reg_x_out2<=24'b0;
//	   reg_y_out2<=24'b0;
//	   reg_x_out3<=24'b0;
//	   reg_y_out3<=24'b0;
//	end
//	else begin
//		if(enable_reg) begin
//			reg_x_out0<= x_in0;
//			reg_y_out0<= y_in0;
//			reg_x_out1<= x_in1;
//			reg_y_out1<= y_in1;
//			reg_x_out2<= x_in2;
//			reg_y_out2<= y_in2;
//			reg_x_out3<= x_in3;
//			reg_y_out3<= y_in3;
//		end
//	end
	
//end



// code giu gia tri sau khi da quay
//assign x_out0 =(index==3'b000)?wire_x_out0:reg_x_out0;
//assign x_out1 =(index==3'b000||index==3'b001)?wire_x_out1:reg_x_out1;
//assign x_out2 =(index==3'b000||index==3'b001||index==3'b010)?wire_x_out2:reg_x_out2;
//assign x_out3 =(index==3'b000||index==3'b001||index==3'b010||index==3'b011)?wire_x_out3:reg_x_out3;
//
//
//assign y_out0 =(index==3'b000)?wire_y_out0:reg_y_out0;
//assign y_out1 =(index==3'b000||index==3'b001)?wire_y_out1:reg_y_out1;
//assign y_out2 =(index==3'b000||index==3'b001||index==3'b010)?wire_y_out2:reg_y_out2;
//assign y_out3 =(index==3'b000||index==3'b001||index==3'b010||index==3'b011)?wire_y_out3:reg_y_out3;

//wire enable_reg;
//assign enable_reg= (shift==4'b1111)?1'b1:1'b0;
//
//always @(posedge clk) begin
//	if(!rst_n) begin
//		reg_x_out0<=24'b0;
//	   reg_y_out0<=24'b0;
//	   reg_x_out1<=24'b0;
//	   reg_y_out1<=24'b0;
//	   reg_x_out2<=24'b0;
//	   reg_y_out2<=24'b0;
//	   reg_x_out3<=24'b0;
//	   reg_y_out3<=24'b0;
//	end
//	else begin
//		if(enable_reg) begin
//			reg_x_out0= wire_x_out0;
//			reg_y_out0= wire_y_out0;
//			reg_x_out1= wire_x_out1;
//			reg_y_out1= wire_y_out1;
//			reg_x_out2= wire_x_out2;
//			reg_y_out2= wire_y_out2;
//			reg_x_out3= x_out3;
//			reg_y_out3= y_out3;
//		end
//	end
//	
//end


endmodule