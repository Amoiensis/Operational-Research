% Daul Simplex Method mian.m
%% CLEAR
clear;clc;
%% IMFORMATION
% Author: Amoiensis
% Email: Amoiensis@outlook.com
% Course: Operational Reaserch
% Case: Dual Simplex Method
% Data: 2019.11.11
%% IMPORT DATA
format short 
A = [...
    -2  -4  0   1   0;
    -2  0   -5  0   1;...
    ];
b = [-2 -3]';
C = [-12 -16 -15 0 0];
%% OPERATION
[~,Best_plan,RESULT]  =Dual_Simplex_f(A,b,C);