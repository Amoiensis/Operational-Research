clear;clc;
%%
% Author: Amoiensis
% Email: Amoiensis@outlook.com
% Data: 2019.10.27
% Course: Operational Research
% Dtailed:Tabular Method (表上作业法 -- Vogel法)
%%
% e.g 1
% import data
% Supply = [7 4 9];
% Demand = [3 6 5 6];
% Cost = [...
%         3   11  3   10;
%         1   9   2   8;
%         7   4   10  5;...
%         ];
%% 
% e.g 2
% Supply = [...
%         15 25  5;...
%          ];
% Demand = [...
%         5 15  15	10;...
%         ];
% Cost = [...
%         10  2   20  11;
%         12  7   9   20;
%         2   14  16  18;...
%         ];    
%%
% e.g 3
Supply = [...
        7   25  26;...
         ];
Demand = [...
        10  10  20  15  3;...
        ];
Cost = [...
        8   4   1   2   0;
        6   9   4   7   0;
        5   3   4   3   0;...
        ];
Cost(3,:) = Cost(3,:) + 100;
%%
Result = [];
%%
% Operation
% Vogel
supply = Supply;
demand = Demand;
cost = Cost;

Size_cost = size(cost);
Result = nan(Size_cost);

% 列计算，data值
while ~isequal(isnan(cost),ones(Size_cost))
        %%%%%%%%%%%%%%%%%
        disp('***************************')
        disp(Result);
        %%%%%%%%%%%%%%%%%
    temp = sort(cost);
    if ~isequal(isnan(temp(2:end,:)),ones(Size_cost(1)-1,Size_cost(2)))
        column_min_value = temp(1,:);   %该列最小值
        column_deta = temp(2,:) - temp(1,:);    %最小值和次小值差值deta
        column_max_deta_value = max(column_deta);   %找到差值deta的最大
        colum_operation_idex = [];
        colum_operation_num = 1;
        for i=1:Size_cost(2)    %找到最大data值所在位置
            if column_deta(i) == column_max_deta_value
                colum_operation_idex(colum_operation_num) = i;
                colum_operation_num = colum_operation_num + 1;
            end
        end
        colum_Size_idex = size(colum_operation_idex);
        [colum_min,colum_idex] = min(column_min_value(colum_operation_idex));
        colum_position = colum_operation_idex(colum_idex);  %待处理列位置

        [~,row_position] = min(cost(:,colum_position));
    else
        [~,colum_position] = min(temp(1,:));
        for i=1:Size_cost(1)
            if ~isequal(isnan(cost(i,:)),ones(1,Size_cost(2)))
                row_position = i;
            end
        end
    end
        
        %%%%%%%%%%%%%%%%%
        disp(column_deta);
        disp(cost);
        %%%%%%%%%%%%%%%%%
    
    if supply(row_position) >= demand(colum_position)
        Result(row_position,colum_position) = demand(colum_position);
        supply(row_position)= supply(row_position) - demand(colum_position);
        demand(colum_position) = 0;
        cost(:,colum_position) = nan(Size_cost(1),1);
    else
    %     if supply(row_position) < demand(colum_position)
             Result(row_position,colum_position) = supply(row_position);
             demand(colum_position) = demand(colum_position) - supply(row_position);
             supply(row_position) = 0;
             cost(row_position,:) = nan(1,Size_cost(2));
    end
    
end
%%
% 输出结果 Putout
%%%%%%%%%%%%%%%%%
disp('***************************')
disp(Result);
disp(column_deta);
disp(cost);
%%%%%%%%%%%%%%%%%