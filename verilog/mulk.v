// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module mulk
#(
	parameter WIDTH=24
)
(
	input		signed	[WIDTH-1:0]		data_in,
	output 		 		[WIDTH-1:0]		data_out
);

 // 0.1001101101110100111011011 = 0.607252925634384
  assign data_out = (data_in>>>1)+(data_in>>>4)+(data_in>>>5)+(data_in>>>7)+(data_in>>>8)+(data_in>>>10)+(data_in>>>11)+(data_in>>>12)
         +(data_in>>>14)+(data_in>>>17)+(data_in>>>18)+(data_in>>>19)+(data_in>>>21)+(data_in>>>22)+(data_in>>>24)+(data_in>>>25);

endmodule
