// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

// tai sao output lai la signed
module add_sub
#(
	WIDTH = 24
)
(
input signed 	[WIDTH -1:0] 	a,b,
input				sign,		
//output 			[WIDTH -1:0] 	result
output signed	[WIDTH -1:0] 	result

);
assign	result = sign? (a+b) :(a-b);

endmodule
