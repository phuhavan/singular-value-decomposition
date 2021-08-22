// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module mux4x1
(
	input 	clk,
	input		rst,
	input		in0,
	input		in1,
	input		in2,
	input		in3,
	input	 	[1:0]		sel,
	input             ce,	
	output 	 			out
);

assign out=	(sel[1])?((sel[0])?in3:in2):((sel[0])?in1:in0);
endmodule
