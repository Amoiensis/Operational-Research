function [max_value,result,PRINT] = Simplex_method_f(A,b,C)
% Simplex Method 单纯形法求解标准线性规划模型
%   传入变量A、b、C 求解最优决策/最优值/最终单纯形表
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

    %寻找，最大检验数/deta值 和 sita值
    % 这一步是先deta最大，再sita最大？这里是否有优化空间？
    %deta
    for i=1:Size_A(2)
        deta(i) = C(i) - (Coef)*A(:,i);
    end
    [temp_deta,Position_in] = max(deta);    %找到换入位置
    
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
    sita_arry = Decsion./A(:,Position_in);
    Size_sita_arry = size(sita_arry);
    for i=1:Size_sita_arry(1)
        if sita_arry(i)<=0
            sita_arry(i) = nan;
        end
    end
    % 这里需要注意，先挑选出人工变量；
    [sita,Position_out] = min(sita_arry);
    
    for i=1:Size_sita_arry(1)
        if sita_arry(i) == sita
               Base(Position_out) < Base(i);
               Position_out = i;
        end
    end
%     Position_out = Size_sita_arry(1)+1-Position_out;
%     temp_num = A(Position_out,Position_in);
    %%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%
    %程序结束条件%
    
    %死循环-无界解跳出%
%     @@这里的无界条件存在问题
%     if A(:,Position_in) == ZEROS_ceofA
%         FLAG = 2;
%         break;
%     end
    
%     if sum(deta>0) == Size_A(2)
    %无界解
%         for i=1:Size_A(2)
%             if  deta(i)>0 && isequal(A(:,i),ZEROS_ceofA)
%                 FLAG = 2;
%                 break;
%             end
%         end
%         if FLAG == 2
%             break;
%         end
        if sita == inf
            FLAG = 2;
            break;
        end
%     end
    
    %正常求解-唯一解or无穷多解%
    if isequal(deta<=0,END_deta)
        FLAG = 1;
        break;
    end
    
    %无解
%     for i=1:Size_A(2)
%         if  deta(i)==0 && (sum(A(:,i)==1)~=1||sum(A(:,i)==0)~=(Size_A(1)-1))
%             FLAG = 3;
%             break;            
%         end
%     end
%        if FLAG == 3
%             break;
%         end
    
    %%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%
%     %sita
%     sita_arry = Decsion./A(:,Position_in);
%     Size_sita_arry = size(sita_arry);
%     for i=1:Size_sita_arry(1)
%         if sita_arry(i)<=0
%             sita_arry(i) = inf;
%         end
%     end
%     [sita,Position_out] = min(sita_arry);
%     
    temp_num = A(Position_out,Position_in);
%     %%%%%%%%%%%%%%

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
        if deta(i)==0 && sum((sita>0))
             FLAG = 12;   %无穷多
             break;
        end
%        if  temp_tell(i)
%            if sum((A(:,i)>0))
%                FLAG = 12;   %无穷多
%            end
%        end
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
%%
% 结果返回 %
result = Result;
max_value = Coef*Decsion;
end

