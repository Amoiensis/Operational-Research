%Hungary_main (�������㷨)_Author: Amoiensis
%%
% Author: Amoiensis
% Email: Amoiensis@outlook.com
% Data: 2019.10.28
% Course: Operational Research
% Dtailed: Hungary (�������㷨)
%%
clear;clc;
%%
% Import data
Matrix = [...
         2  10  9   7;
         15 4   14  8;
         13 14  16  11;
         4  15  13  9;...
         ];
[marix,zeros_position] = Hungary_fuction(Matrix);