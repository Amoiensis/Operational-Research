function [matrix,Zeros_position] = Hungary_fuction(Matrix)
%Hungary_fuction (匈牙利算法)_Author: Amoiensis
%%
% Author: Amoiensis
% Email: Amoiensis@outlook.com
% Data: 2019.10.28
% Course: Operational Research
% Dtailed: Hungary (匈牙利算法)
%%
% e.g Data
% eg.1
% Matrix = [...
%          0  8   2   5;
%          11 0   5   4;
%          2  3   0   0;
%          0  11  4   5;...
%          ];
% eg.2
% Matrix = [...
%          2  10  9   7;
%          15 4   14  8;
%          13 14  16  11;
%          4  15  13  9;...
%          ];
% eg.3
% Matrix = [...
%          3  8   2   10  3;
%          8  7   2   9   7;
%          6  4   2   7   5;
%          8  4   2   3   5;
%          9  10  6   9   10;...
%          ];
% eg.4
% Matrix = [...
%          377 329 338 370 344;
%          434 331 422 347 358;
%          333 285 389 304 306;
%          292 272 296 285 301;
%          0   0   0   0   0;...
%          ];
%%
% Operation
Size_matrix = size(Matrix);
% Pre_operate
for i=1:Size_matrix(1)
    Matrix(i,:) =  Matrix(i,:) - min( Matrix(i,:));
end
disp(Matrix);
for i=1:Size_matrix(2)
    Matrix(:,i) =  Matrix(:,i) - min( Matrix(:,i));
end
disp(Matrix);
% Main_operate
flag = 0;
while ~flag
    matrix = Matrix;
    Zeros_position = nan(Size_matrix);
    pre_matrix = [];
    while ~isequal(isnan(pre_matrix),isnan(matrix))
        % 查看行，变更列
        pre_matrix = matrix;
        for i=1:Size_matrix(1)
            temp_zeros_num = 0;
            temp_j = 0;
            for j=1:Size_matrix(2)
                if matrix(i,j) == 0
                    temp_j = j;
                    Zeros_position(i,j) = 0;
                    temp_zeros_num = temp_zeros_num + 1;
                    if temp_zeros_num>1
                        Zeros_position(i,:) = nan(1,Size_matrix(2));
                        temp_j = 0;
                        break;
                    end
                end
            end
            if temp_j ~= 0
                matrix(:,temp_j) = nan(Size_matrix(1),1);
            end
        end

        % 产看列，变更行；
        for j=1:Size_matrix(2)
            temp_zeros_num = 0;
            temp_i = 0;
            for i=1:Size_matrix(1)
                if matrix(i,j) == 0
                    temp_i = i;
                    Zeros_position(i,j) = 0;
                    temp_zeros_num = temp_zeros_num + 1;
                    if temp_zeros_num>1
                        Zeros_position(:,j) = nan(Size_matrix(1),1);
                        temp_i = 0;
                        break;
                    end
                end
            end
            if temp_i ~= 0
                matrix(temp_i,:) = nan(1,Size_matrix(2));
            end
        end
    end

    flag = isequal(sum(Zeros_position == zeros(Size_matrix)),ones(1,Size_matrix(2)));

    if flag
        disp('求解完毕');
        disp('matrix');
        disp(matrix);
        disp('zeros position');
        disp(Zeros_position);
    else
        disp('进一步运算');
        disp('matrix');
        disp(matrix);
        disp('zeros position');
        disp(Zeros_position);
        operator_r = zeros(1,Size_matrix(2));
        operator_c = zeros(Size_matrix(1),1);
        min_value = min(min(matrix));
        for i=1:Size_matrix(1)
            if ~(sum(isnan(matrix(i,:))) == Size_matrix(2))
                Matrix(i,:) = Matrix(i,:) - min_value;
            end
%             disp(Matrix);
            if sum(isnan(matrix(:,i))) == Size_matrix(2)                
                Matrix(:,i) = Matrix(:,i) + min_value;
            end
%             disp(Matrix);
        end
    end
    disp('位势变换');
    disp(Matrix);
    %flag =  det(double(~Matrix));       
end

end

