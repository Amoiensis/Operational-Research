%测试 Simplex_Method 函数
%%
% Author: Amoiensis
% Email: yxp189@portonmail.com
% Data: 2019.10.01
%%
clear;clc;
%%
% Import Data %
%无穷多最优解%
A = [...
    1	1	1	1	0	0	0
    1	0	0	0	1	0	0
    0	0	1	0	0	1	0
    0	3	1	0	0	0	1;...
    ];
b = [4 2 3 6]';
C = [1 14 6 0 0 0 0];
%可行解无界%
% A = [...
%     4	0	1....
%     ];
% b = [16]';
% C = [2 3 0];
%%
Simplex_method_f(A,b,C);
