function [ decVec ,iter] = ldpcDecode( c_in_llr, H_c ,max_iter )
% ͳ��У������еķ���Ԫ�ظ���
numEntries = nnz(H_c);
[chk_len,code_len] = size(H_c);
%% Initialization

% ��ʼ��У��ڵ���Ϣ����
Rcv = spalloc(chk_len, code_len, numEntries);

% LDPC�������룬����������ΪMaxIterNum
for iter=1:max_iter
    for j=1:chk_len
        idx = (H_c(j,:)==1); %У��ڵ��Ӧ�ı����ڵ�����
        S = c_in_llr(idx)-Rcv(j,idx);%���±����ڵ���Ϣ
        
        %����У��ڵ��Ӧ�ı����ڵ����С�ʹ�С����ֵ
        Stmp_abs = abs(S);
        [Stmp_abs_min, min_position] = min(Stmp_abs);
        Stmp_abs_without_min = Stmp_abs;
        Stmp_abs_without_min(min_position) = 1e10;
        Stmp_abs_second_min = min(Stmp_abs_without_min);
        Magnitude = Stmp_abs_min*ones(1,length(Stmp_abs_without_min));
        Magnitude(min_position) = Stmp_abs_second_min;
        
        %min-sum�㷨��Ӧ���ڵ����ֵ
        Stmp_sign_1 = sign(S);
        Stmp_sign_1(Stmp_sign_1==0) = 1;
        Stmp_sign_prod = prod(Stmp_sign_1)* Stmp_sign_1;
        
        %У��ڵ���Ϣ����
        Rcv(j,idx) = Stmp_sign_prod.*Magnitude*0.75;
        %�������LLR����
        c_in_llr(idx) = S + Rcv(j,idx);
    end
    %������ǰ��ֹ�ж�
    if(nnz(mod(H_c*(c_in_llr<0).',2))==0)
        break;
    end   
end
%Ӳ�о����
decVec = double(c_in_llr<0);  
