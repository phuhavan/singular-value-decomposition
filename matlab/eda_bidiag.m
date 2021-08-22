% -----------------------------------------------------------------------
% EDABK       401 C9 Building, Hanoi University of Science and Technology
%             No 1, Dai Co Viet Street, Hai Ba Trung Dist., Hanoi
% -----------------------------------------------------------------------
% Project     : Singular Value Decomposition
% Filename    : eda_bidiag.m
% Author      : Van-Phu Ha, Van-Binh Truong
% Description : Bidiagonalization using Givens Rotation

function [L B R] = eda_bidiag(A)
[m n] = size(A);
B = A;
L = eye(m);
R = eye(n);
for j = 1:1:n
    % Givens Rotation for Column vector
    for i = (m-1):(-1):j
        [L B] = eda_rot_col(L,B,i,i+1,j);
    end
    % Givens Rotation for Row vector
    if(j<n-1)
        for i = (n-1):(-1):(j+1)
            [B R] = eda_rot_row(B,R,j,i,i+1);
        end
    end
end
