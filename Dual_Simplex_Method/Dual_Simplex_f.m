function [max_value,result,PRINT] = Dual_Simplex_f(A,b,C)
% Dual Simplex Method ��ż�����η� //����ֵ��(���ž���/����ֵ/���յ����α�)
%   �������A��b��C �����أ����ž���/����ֵ/���յ����α�
%% IMFORMATION
% Author: Amoiensis
% Email: Amoiensis@outlook.com
% Course: Operational Reaserch
% Case: Dual Simplex Method
% Data: 2019.11.11
%% Structure
% Dual Simplex Method
%% Pre_OPERATION
% ���ݻ������� %
Size_A = size(A);
deta = zeros(1,Size_A(2));    %�������б�
% sita_arry = zeros(1,Size_A(1));    
sita = 0;   %sitaֵ
Coef = zeros(1,Size_A(1));    %ϵ��ֵ
Base = zeros(1,Size_A(1));  %ѡ��Ļ�
Decsion = b;%zeros(1,Size_A(1));%����ȡֵ

END_deta = ones(1,Size_A(1));   %ʹ��detaֵ�궨�������
% ZEROS_ceofA = zeros(Size_A(1),1);   %�����ж�����⣬�޽�

FLAG = 0;   %��������ѭ����0-����//1-Ψһ��(11)or������(12)//2-�޽��//3-�޿��н�
Step = 1;
PUTOUT_R = "<<ROW>>C_B   //  ��   //  b  //   x_1~x_n";
PUTOUT_C = " <<Column>> x_1~x_m   //  deta";
%% OPERATION
%Operation
%STEP 1 �����α�ʵ��%
 while 1
    %�ҵ���λ����
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
%     �ҵ��滻λ�� Position_out
    [~,Position_out] = min(Decsion);   
%     Ѱ�ң���������/detaֵ �� sitaֵ
%     deta
    for i=1:Size_A(2)
        deta(i) = C(i) - (Coef)*A(:,i);
    end
    %%%%%%%%%%%%%%
    %��ӡ�����α�%
    PRINT = zeros(1+Size_A(1),3+Size_A(2));
    PRINT(1,1:3+Size_A(2)) =  [nan(1,3),C];
    PRINT(2:end,1) =  Coef';
    PRINT(2:end,2) =  Base';
    PRINT(2:end,3) =  Decsion;
    PRINT(2:end,4:3+Size_A(2)) = A;
    PRINT(end+1,4:3+Size_A(2)) = deta;
    PRINT(end,1:3) = [nan nan nan];
    disp(strcat("���裺",num2str(Step)));
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
    % ������Ҫע�⣬����ѡ���˹�������
    [sita,Position_in] = min(sita_arry);
    
    if sita == inf
        FLAG = 2;
        break;
    end
    
    %�������-Ψһ��or������%
    if isequal(Decsion>=0,END_deta')
        FLAG = 1;
        break;
    end
    temp_num = A(Position_out,Position_in);
    %%%%%%%%%%%%%%
    %�г��ȱ任
    Decsion(Position_out) = Decsion(Position_out)/temp_num;
    A(Position_out,:) = A(Position_out,:)/temp_num;
    for i=1:Size_A(1)
       if i~=Position_out
            Decsion(i) = Decsion(i)- A(i,Position_in)*Decsion(Position_out);
            A(i,:) = A(i,:)- A(i,Position_in)*A(Position_out,:);
       end
    end
end

%STEP 2 �������%
%��Ϊ��Ψһ���Ž⡢��������Ž⡢�޽�⡢�޿��н�
Result = zeros(1,Size_A(2));
Result(Base) = Decsion;
if FLAG == 1
    for i=1:Size_A(2)
        if deta(i)==0 && sum((sita>0))
             FLAG = 12;   %�����
             break;
        end

    end
    if FLAG ==12
        disp("�����Թ滮���⣬���ڡ�����ࡱ���Ž�.");
        disp("����һ�������Ž����Ϊ��(x1~xn)");
        disp(Result);
        disp("����Ŀ�꺯��ֵΪ��");
        disp(Coef*Decsion);
    else
        disp("�����Թ滮���⣬����Ψһ���Ž�.");
        disp("���Ž����Ϊ��(x1~xn)");
        disp(Result);
        disp("����Ŀ�꺯��ֵΪ��");
        disp(Coef*Decsion);
    end
   
else
    if FLAG == 2
        disp("�����Թ滮���⣬����޽磨���޴�.");
    else
        if FLAG == 3
            disp("�����Թ滮���⣬�޿��н�.");
        end
    end
end
%% RETUERN RESULT
% ������� %
result = Result;
max_value = Coef*Decsion;
end

