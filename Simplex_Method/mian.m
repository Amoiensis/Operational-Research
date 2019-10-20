%���� Simplex_Method ����
%%
% Author: Amoiensis
% Email: yxp189@portonmail.com
% Data: 2019.10.01
clear;clc;
%%
% Import Data %
%��������Ž�%
% A = [...
%     1	1	1	1   0	0	0;
%     -2	1	-1	0	-1	1	0;
%     0	3	1	0	0	0	1;...
%     ];
% b = [4  1   9]';
% C = [-3	0	1	0	0	-100  -1];

A = [...
    1	1	1	1	0	0	0
    1	0	0	0	1	0	0
    0	0	1	0	0	1	0
    0	3	1	0	0	0	1;...
    ];
b = [4 2 3 6]';
C = [1 14 6 0 0 0 0];

% %���н��޽�%
% A = [...
%     4	0	1....
%     ];
% b = [16]';
% C = [2 3 0];

[~,~,RESULT] = Simplex_method_f(A,b,C);