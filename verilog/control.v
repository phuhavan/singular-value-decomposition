// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module control
#(
	parameter 	WIDTH=24,
	parameter	WIDTH_SHIFT_BIT= 4
)
(
	input 		rst_n,
	input 		clk,
	input			start,	// cho phep bat dau dem
	output 		sel,
	output reg	[WIDTH_SHIFT_BIT-1:0]	shift_bit,count
);

//reg	counter;
always @(posedge clk) begin
	if(!rst_n) begin
		count	<=	4'b0000;
		shift_bit<=4'b0000;
	end
	else begin
		if(start) begin
		//	count	<=	4'b0000;
		//	shift_bit<=4'b0000;
		//end
		//else begin
			count<=count+4'b1;
			shift_bit<=count;
		end
	end
end

assign sel=(count==4'b0000)?1'b0:1'b1;
endmodule

