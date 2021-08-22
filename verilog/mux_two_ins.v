// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module mux_two_ins
#(
	parameter data_width = 256
)
(
	input		[data_width-1:0]	in0,in1,
	input								mux_two,
	output	[data_width-1:0]	out0
);
	assign	out0 = (mux_two) ? in1 : in0;

endmodule
