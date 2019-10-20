% Simplex Method Code
%%
% Author: Amoiensis
% Data: 2019.10.01
%%
% Structure（Program Simplex_Method）%
%    max CX
% s.t. AX = b
%      X >= 0
% Program to solve the liner-program atomatically
%%
clear;clc;
% Import Data %
%%
%无穷多最优解 %
A = [...
    2	2	1	0	0;
    4	0	0	1	0;
    0	5	0	0	1;...
    ];
b = [12 16 15]';
C = [2 3 0 0 0];

% 无界解 %
% A = [...
%     4	0	1....
%     ];
% b = [16]';
% C = [2 3 0];

% 无解 %
% A = [...
%     1	1	1	1	0	0	0;
%     -2	1	-1	0	-1	1	0;
%     0	3	1	0	0	0	1;...
%     ];
% b = [4 1 9]';
% % C = [-3	0	1	0	0	-inf -inf];
% C = [0	0	0	0	0	-1 -1];
%%
% 数据基础操作 %
Size_A = size(A);
deta = zeros(1,Size_A(2));    %最优性判别
sita_arry = zeros(1,Size_A(1));    
sita = 0;   %sita值
Coef = zeros(1,Size_A(1));    %系数值
Base = zeros(1,Size_A(1));  %选择的基
Decsion = b;%zeros(1,Size_A(1));%决策取值

END_deta = ones(1,Size_A(2));   %使用deta值标定程序结束
ZEROS_ceofA = zeros(Size_A(1),1);   %用来判断所求解，无界

FLAG = 0;   %用于跳出循环；0-正常//1-唯一解(11)or无穷多解(12)//2-无界解//3-无可行解
Step = 1;
PUTOUT_R = "<<ROW>>C_B   //  基   //  b  //   x_1~x_n";
PUTOUT_C = " <<Column>> x_1~x_m   //  deta";
%%
%Operation
%STEP 1 单纯形表实现%
 while 1
    %找到单位矩阵
    if Size_A(1) == 1
        Position(find(A == 1)) = 1;
    else
        Position = (sum(A) == 1);
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

    %寻找，最大检验数/deta值 和 sita值
    % 这一步是先deta最大，再sita最大？这里是否有优化空间？
    %deta
    for i=1:Size_A(2)
        deta(i) = C(i) - (Coef)*A(:,i);
    end
    [temp_deta,Position_in] = max(deta);
    
    %%%%%%%%%%%%%%
    %打印单纯形表%
    PRINT = [];
    PRINT(:,1) =  Coef';
    PRINT(:,2) =  Base';
    PRINT(:,3) =  Decsion;
    PRINT(:,4:3+Size_A(2)) = A;
    PRINT(end+1,4:3+Size_A(2)) = deta;
    PRINT(end,1:3) = [inf inf inf];
    disp(strcat("步骤：",num2str(Step)));
    disp(PUTOUT_C);
    disp(PUTOUT_R);
    disp(PRINT);
    Step = Step+1;
    %%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%
    %程序结束条件%
    
    %死循环-无界解跳出%
    if A(:,Position_in) == ZEROS_ceofA
        FLAG = 2;
        break;
    end
    
    %正常求解-唯一解or无穷多解%
    if isequal(deta<=0,END_deta)
        FLAG = 1;
        break;
    end
    %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%
    %sita
    sita_arry = Decsion./A(:,Position_in);
    [sita,Position_out] = min(sita_arry);
    
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
Result(Base) = Coef;
if FLAG == 1
    temp_tell = deta == 0;
    for i=1:Size_A(2)
       if  temp_tell(i)
           if sum((A(:,i)>0))
               FLAG = 12;
           end
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
        disp(Decsion*(Coef'));
    end
   
else
    if FLAG == 2
        disp("该线性规划问题，其解无界（无限大）.");
    end
end
