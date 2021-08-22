% -----------------------------------------------------------------------
% EDABK       401 C9 Building, Hanoi University of Science and Technology
%             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
% -----------------------------------------------------------------------
% Project     : Singular Value Decomposition
% Filename    : eda_rot_col.m
% Author      : Van-Phu Ha, Van-Binh Truong
% Description : Givens Rotation for Column vector

function [L, B] = eda_rot_col(Lin, A, row1, row2, col)
[m n] = size(A);
L1 = eye(m);
c = A(row1,col)/sqrt(A(row1,col)^2 + A(row2,col)^2);
s = -A(row2,col)/sqrt(A(row1,col)^2 + A(row2,col)^2);
L1(row1,row1) = c;
L1(row2,row2) = c;
L1(row1,row2) = -s;
L1(row2,row1) = s;
B = L1*A;
L = Lin*L1';
