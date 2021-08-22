// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha


module demux_two_ins
#(
	parameter data_width = 256
)
(
	input		[data_width-1:0] 	in0,
	input								demux_two,
	output	[data_width-1:0]	out0,out1
);
	assign out0 = (demux_two==1'b0) ? in0 : 0;
	assign out1 = (demux_two==1'b1) ? in0 : 0;

endmodule
