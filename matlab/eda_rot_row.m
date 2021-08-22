% -----------------------------------------------------------------------
% EDABK       401 C9 Building, Hanoi University of Science and Technology
%             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
% -----------------------------------------------------------------------
% Project     : Singular Value Decomposition
% Filename    : eda_rot_row.m
% Author      : group 14 embedded
% Description : Givens Rotation for Row vector

function [B R] = eda_rot_row(A, Rin, row, col1, col2)
[m n] = size(A);
R1 = eye(n);
c = A(row,col1)/sqrt(A(row,col1)^2 + A(row,col2)^2);
s = -A(row,col2)/sqrt(A(row,col1)^2 + A(row,col2)^2);
R1(col1,col1) = c;
R1(col2,col2) = c;
R1(col1,col2) = s;
R1(col2,col1) = -s;
B = A*R1;
R = R1'*Rin;