% -----------------------------------------------------------------------
% EDABK       401 C9 Building, Hanoi University of Science and Technology
%             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
% -----------------------------------------------------------------------
% Project     : Singular Value Decomposition
% Filename    : eda_svd_rot.m
% Author      : Van-Phu Ha, Van-Binh Truong
% Description : SVD using Givens Rotation

function [U S V] = eda_svd_rot(A,loop)
[m n] = size(A);
%Bidiagonalization
[U B V] = eda_bidiag(A);

%Diagonalization
S = B;
for i = 1:1:loop
    [P S Q] = eda_diag(S);
    U = U*P;
    V = Q*V;
end
V = V';

