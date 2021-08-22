// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

module mux8_1
(
	input 			a0,a1,a2,a3,a4,a5,a6,a7,
	input		[2:0] sel,
	output 	reg	res
);
	always @ (a0,a1,a2,a3,a4,a5,a6,a7,sel)begin
		case(sel)
			3'b000: res = a0;
			3'b001: res = a1;
			3'b010: res = a2;
			3'b011: res = a3;
			3'b100: res = a4;
			3'b101: res = a5;
			3'b110: res = a6;
			default:res = a7;
		endcase
	end

endmodule

