// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

//  Cho du lieu di qua 1 thanh ghi
module reg_cordic
#(
	parameter width = 32
)
(
	input				[width-1:0]	in0,
	input								clk,rst_n,
	input				[3:0]			sel,
	output	reg	[width-1:0]	out0
);
	always @ (posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			out0 <= 0;
		end
		else if (!sel)	begin
			out0 <= in0;
		end
	end
endmodule
