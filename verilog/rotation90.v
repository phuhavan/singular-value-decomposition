// -----------------------------------------------------------------------
// EDABK       401 C9 Building, Hanoi University of Science and Technology
//             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
// -----------------------------------------------------------------------
// Project     : Singular Value Decomposition
// Filename    : eda_bidiag.m
// Author      : Van-Phu Ha

// tai sao xoay +-90 do lai ko anh huong den ket qua
// do ta quay tat ca ve goc phan tu 1,4 => 
// chi can quay sao cho x+, ma khi qay 90 do thi x = + - y
//=> nen ta chi can quan tam dau cua y,
// neu y>0 => x=y va ta phai quay x: y= -x
// neu y<0 => ta quay y: x=-y va y=x 
module rotation90
#(
  parameter WIDTH = 24    // Counter width
)
(
  input 								sign_rotation,
  input signed [WIDTH-1 : 0] x_in,
  input signed [WIDTH-1 : 0] y_in,
  output       [WIDTH-1 : 0] x_out,
  output       [WIDTH-1 : 0 ] y_out
);
//  assign x_out = enable ?((y_in[WIDTH-1])? (-y_in) : y_in)  :0;
//  assign y_out = enable ?((y_in[WIDTH-1])? (x_in) : (-x_in)):0;
  assign x_out = (sign_rotation)? (-y_in) : y_in  ;
  assign y_out = (sign_rotation)? (x_in) : (-x_in);
endmodule
