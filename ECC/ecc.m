
clear;
clc;
load('D:\ECC\H.mat');
load('D:\ECC\G.mat');
[info_len,code_len] = size(G);
chk_len = code_len - info_len;
H_c=[H(:,chk_len+1:end),H(:,1:chk_len)];
G_c=[G(:,chk_len+1:end),G(:,1:chk_len)];
clear G;
clear H;
q=mod(G_c*H_c',2);
c1=randi([0,1],1,info_len);
c=mod(c1*G_c,2);
c_in1=c;
clear G_c;
err_num=80;
err=round(rand(1,err_num)*code_len);
for i=1:1:err_num
    if c_in1(1,err(1,i))
        c_in1(1,err(1,i))=0;
    else
        c_in1(1,err(1,i))=1;
    end
end
fid1=fopen('D:\ECC\decodedin80.txt','wt');
fid2=fopen('D:\ECC\decodedin0.txt','wt');
for j=1:1:1152
    for k=1:1:8
        fprintf(fid1,'%d',c_in1(1,8*(j-1)+9-k));
        fprintf(fid2,'%d',c(1,8*(j-1)+9-k));
    end
    fprintf(fid1,'\n');
    fprintf(fid2,'\n');
end
fclose(fid1);
fclose(fid2);

%% NMSÀ„∑®
max_iter = 30;
c_in_llr = 8*(1-2*c_in1);
[ decVec ,iter] = ldpcDecode( c_in_llr, H_c ,max_iter );
err_bit_num2 = sum(decVec~=c)

