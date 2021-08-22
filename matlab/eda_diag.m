% -----------------------------------------------------------------------
% EDABK       401 C9 Building, Hanoi University of Science and Technology
%             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
% -----------------------------------------------------------------------
% Project     : Singular Value Decomposition
% Filename    : eda_diag.m
% Author      : Van-Phu Ha, Van-Binh Truong
% Description : Diagonalization using Givens Rotation

function [P S Q] = eda_diag(B)
[m n] = size(B);
S = B;
P = eye(m);
Q = eye(n);
for i = 1:1:(n-1)
    % Givens Rotation for Row vector
    [S Q] = eda_rot_row(S,Q,i,i,i+1);
    % Givens Rotation for Column vector
    [P S] = eda_rot_col(P,S,i,i+1,i);
end
