function [max_value,result,PRINT] = Dual_Simplex_f(A,b,C)
% Dual Simplex Method 对偶单纯形法 //返回值：(最优决策/最优值/最终单纯形表)
%   传入变量A、b、C ，返回：最优决策/最优值/最终单纯形表
%% IMFORMATION
% Author: Amoiensis
% Email: Amoiensis@outlook.com
% Course: Operational Reaserch
% Case: Dual Simplex Method
% Data: 2019.11.11
%% Structure
% Dual Simplex Method
%% Pre_OPERATION
% 数据基础操作 %
Size_A = size(A);
deta = zeros(1,Size_A(2));    %最优性判别
% sita_arry = zeros(1,Size_A(1));    
sita = 0;   %sita值
Coef = zeros(1,Size_A(1));    %系数值
Base = zeros(1,Size_A(1));  %选择的基
Decsion = b;%zeros(1,Size_A(1));%决策取值

END_deta = ones(1,Size_A(1));   %使用deta值标定程序结束
% ZEROS_ceofA = zeros(Size_A(1),1);   %用来判断所求解，无界

FLAG = 0;   %用于跳出循环；0-正常//1-唯一解(11)or无穷多解(12)//2-无界解//3-无可行解
Step = 1;
PUTOUT_R = "<<ROW>>C_B   //  基   //  b  //   x_1~x_n";
PUTOUT_C = " <<Column>> x_1~x_m   //  deta";
%% OPERATION
%Operation
%STEP 1 单纯形表实现%
 while 1
    %找到单位矩阵
    if Size_A(1) == 1
        Position(find(A == 1)) = 1;
    else
        Position = ((sum(A) == 1)&(min(A) == 0));
    end
    index_I = zeros(1,Size_A(1));
    for i=1:Size_A(2)
       if  Position(i) 
           [~,temp] = max(A(:,i));
           index_I(temp) = i;
       end
    end

    Base = index_I;
    Coef = C(index_I);
%     找到替换位置 Position_out
    [~,Position_out] = min(Decsion);   
%     寻找，最大检验数/deta值 和 sita值
%     deta
    for i=1:Size_A(2)
        deta(i) = C(i) - (Coef)*A(:,i);
    end
    %%%%%%%%%%%%%%
    %打印单纯形表%
    PRINT = zeros(1+Size_A(1),3+Size_A(2));
    PRINT(1,1:3+Size_A(2)) =  [nan(1,3),C];
    PRINT(2:end,1) =  Coef';
    PRINT(2:end,2) =  Base';
    PRINT(2:end,3) =  Decsion;
    PRINT(2:end,4:3+Size_A(2)) = A;
    PRINT(end+1,4:3+Size_A(2)) = deta;
    PRINT(end,1:3) = [nan nan nan];
    disp(strcat("步骤：",num2str(Step)));
    disp(PUTOUT_C);
    disp(PUTOUT_R);
    disp(PRINT);
    %%%%%%%%%%%%%%
    Step = Step+1;    
    %%%%%%%%%%%%%%
    %sita
    sita_arry = deta./A(Position_out,:);
    Size_sita_arry = size(sita_arry);
    for i=1:Size_sita_arry(2)
        if A(Position_out,i)>=0
            sita_arry(i) = nan;
        end
    end
    % 这里需要注意，先挑选出人工变量；
    [sita,Position_in] = min(sita_arry);
    
    if sita == inf
        FLAG = 2;
        break;
    end
    
    %正常求解-唯一解or无穷多解%
    if isequal(Decsion>=0,END_deta')
        FLAG = 1;
        break;
    end
    temp_num = A(Position_out,Position_in);
    %%%%%%%%%%%%%%
    %行初等变换
    Decsion(Position_out) = Decsion(Position_out)/temp_num;
    A(Position_out,:) = A(Position_out,:)/temp_num;
    for i=1:Size_A(1)
       if i~=Position_out
            Decsion(i) = Decsion(i)- A(i,Position_in)*Decsion(Position_out);
            A(i,:) = A(i,:)- A(i,Position_in)*A(Position_out,:);
       end
    end
end

%STEP 2 结果检验%
%分为：唯一最优解、无穷多最优解、无界解、无可行解
Result = zeros(1,Size_A(2));
Result(Base) = Decsion;
if FLAG == 1
    for i=1:Size_A(2)
        if deta(i)==0 && sum((sita>0))
             FLAG = 12;   %无穷多
             break;
        end

    end
    if FLAG ==12
        disp("该线性规划问题，存在“无穷多”最优解.");
        disp("其中一个，最优解决策为：(x1~xn)");
        disp(Result);
        disp("最优目标函数值为：");
        disp(Coef*Decsion);
    else
        disp("该线性规划问题，存在唯一最优解.");
        disp("最优解决策为：(x1~xn)");
        disp(Result);
        disp("最优目标函数值为：");
        disp(Coef*Decsion);
    end
   
else
    if FLAG == 2
        disp("该线性规划问题，其解无界（无限大）.");
    else
        if FLAG == 3
            disp("该线性规划问题，无可行解.");
        end
    end
end
%% RETUERN RESULT
% 结果返回 %
result = Result;
max_value = Coef*Decsion;
end

