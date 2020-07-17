function [ decVec ,iter] = ldpcDecode( c_in_llr, H_c ,max_iter )
% 统计校验矩阵中的非零元素个数
numEntries = nnz(H_c);
[chk_len,code_len] = size(H_c);
%% Initialization

% 初始化校验节点信息矩阵
Rcv = spalloc(chk_len, code_len, numEntries);

% LDPC迭代译码，迭代次数设为MaxIterNum
for iter=1:max_iter
    for j=1:chk_len
        idx = (H_c(j,:)==1); %校验节点对应的变量节点索引
        S = c_in_llr(idx)-Rcv(j,idx);%更新变量节点信息
        
        %计算校验节点对应的变量节点的最小和次小绝对值
        Stmp_abs = abs(S);
        [Stmp_abs_min, min_position] = min(Stmp_abs);
        Stmp_abs_without_min = Stmp_abs;
        Stmp_abs_without_min(min_position) = 1e10;
        Stmp_abs_second_min = min(Stmp_abs_without_min);
        Magnitude = Stmp_abs_min*ones(1,length(Stmp_abs_without_min));
        Magnitude(min_position) = Stmp_abs_second_min;
        
        %min-sum算法对应各节点符号值
        Stmp_sign_1 = sign(S);
        Stmp_sign_1(Stmp_sign_1==0) = 1;
        Stmp_sign_prod = prod(Stmp_sign_1)* Stmp_sign_1;
        
        %校验节点信息更新
        Rcv(j,idx) = Stmp_sign_prod.*Magnitude*0.75;
        %更新码块LLR度量
        c_in_llr(idx) = S + Rcv(j,idx);
    end
    %迭代提前终止判定
    if(nnz(mod(H_c*(c_in_llr<0).',2))==0)
        break;
    end   
end
%硬判决输出
decVec = double(c_in_llr<0);  
