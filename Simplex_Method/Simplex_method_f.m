function [max_value,result] = Simplex_method_f(A,b,C)
% Simplex Method �����η�����׼���Թ滮ģ��
%   �������A��b��C ������ž��ߺ�����ֵ
%%
% Author: Amoiensis
% Email: yxp189@portonmail.com
% Data: 2019.10.01
%%
% Structure��Program Simplex_Method��%
%    max CX
% s.t. AX = b
%      X >= 0
% Program to solve the liner-program atomatically
%%
% ���ݻ������� %
Size_A = size(A);
deta = zeros(1,Size_A(2));    %�������б�
sita_arry = zeros(1,Size_A(1));    
sita = 0;   %sitaֵ
Coef = zeros(1,Size_A(1));    %ϵ��ֵ
Base = zeros(1,Size_A(1));  %ѡ��Ļ�
Decsion = b;%zeros(1,Size_A(1));%����ȡֵ

END_deta = ones(1,Size_A(2));   %ʹ��detaֵ�궨�������
ZEROS_ceofA = zeros(Size_A(1),1);   %�����ж�����⣬�޽�

FLAG = 0;   %��������ѭ����0-����//1-Ψһ��(11)or������(12)//2-�޽��//3-�޿��н�
Step = 1;
PUTOUT_R = "<<ROW>>C_B   //  ��   //  b  //   x_1~x_n";
PUTOUT_C = " <<Column>> x_1~x_m   //  deta";
%%
%Operation
%STEP 1 �����α�ʵ��%
 while 1
    %�ҵ���λ����
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

    %Ѱ�ң���������/detaֵ �� sitaֵ
    % ��һ������deta�����sita��������Ƿ����Ż��ռ䣿
    %deta
    for i=1:Size_A(2)
        deta(i) = C(i) - (Coef)*A(:,i);
    end
    [temp_deta,Position_in] = max(deta);
    
    %%%%%%%%%%%%%%
    %��ӡ�����α�%
    PRINT = [];
    PRINT(:,1) =  Coef';
    PRINT(:,2) =  Base';
    PRINT(:,3) =  Decsion;
    PRINT(:,4:3+Size_A(2)) = A;
    PRINT(end+1,4:3+Size_A(2)) = deta;
    PRINT(end,1:3) = [inf inf inf];
    disp(strcat("���裺",num2str(Step)));
    disp(PUTOUT_C);
    disp(PUTOUT_R);
    disp(PRINT);
    Step = Step+1;
    %%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%
    %�����������%
    
    %��ѭ��-�޽������%
    if A(:,Position_in) == ZEROS_ceofA
        FLAG = 2;
        break;
    end
    
    %�������-Ψһ��or������%
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
    end
end
%%
% ������� %
result = Result;
max_value = Coef*Decsion;
end

