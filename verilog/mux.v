// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module mux
#(
	parameter WIDTH =24
)
(
	input 	clk,
	input		rst,
	input	[WIDTH-1:0]	in0,
	input	[WIDTH-1:0]	in1,
	input					sel,
	input                    ce,	
	output reg [WIDTH-1:0]	out,
	output				msb
);
assign msb= out[WIDTH-1];
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		out<=0;
	end
	else begin 
		if(ce) begin
			if(sel) begin	
				out<= in1;
			end	
			else begin
				out<=in0;
			end
		end
		
		
	end
end
endmodule
