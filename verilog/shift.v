// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

//1 tai sao ko dung mach day? tai sao ko can dau ra la thanh ghi
//2 tai sao lai shift_bit la 4bit?
//3 tai sao ko dung phep dich so hoc: giu  nguyen dau cua data_in 
// thi ta ko can phai chon add/sub ma luon luon la sub
// dung phep dich logic: ko giu lai dau >>> vi khi do, khi ta dich xong se dc data_out la so duong, 
// khi do ta se thuc hien x+ hoac - data_out se chi phu thuoc vao dau cua x.
// vi du: 
// khi data_out luon duong:
// 	khi x>0 => t phai - 1 so duong de thanh x cang gan 0 => x - data_out
// 	khi x<0 => x + data_out
// neu ta giu nguyen dau x:
// 	khi x > 0 => data_out >0 => x - data_out
// 	khi x < 0 => data_out <0 => x - data_out
module shift
#(
	parameter WIDTH= 24,
	parameter WIDTH_SHIFT_BIT= 4 // so luong bit 
)
(

	//input											rst,
	//input 										clk,
	input						[WIDTH_SHIFT_BIT-1:0]	shift_bit, //xac dinh dich bao nhieu bit
	input 		signed	[WIDTH-1:0] 				data_in,
	//output reg 	[WIDTH-1:0] 				data_out
	output  					[WIDTH-1:0] 				data_out
);

/*
always @(posedge clk) begin
	if(!rst) begin
		data_out <=0;
	end
	else begin
		//data_out<={1'b0,data_in[WIDTH-1:1]};
	end
end
*/

	assign data_out = data_in >>> shift_bit;
endmodule