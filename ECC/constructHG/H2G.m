%function [G,valid]=H2G(H)
%  H=x;
load('D:\ECC\H.mat')
[m,n]=size(H);
valid=1;
for k=1:m                                %���н��и�˹��Ԫ,ʹǰm�С�m���γɵ�λ��,�Ӷ�ʹУ�����д��[I|P]��ʽ
    vec=[k:n];                  
    if (H(k,k)==0)                       %��˹��ԪʹH(k,k)==1
        a=find(H(k+1:m,k)~=0);
        if isempty(a)
            valid=0;
            break
        end
        a_major=a(1);
        x=k+a_major;
        H(k,vec)=rem(H(x,vec)+H(k,vec),2);
    end
    a=find(H(:,k)~=0)';                  %��˹��Ԫʹ�ĵ�k�г�H(k,k)==1������λ��Ϊ0
    for x=a
          if x~=k
             H(x,vec)=rem(H(x,vec)+H(k,vec),2);
          end
    end
end
P=H(:,m+1:n);
I=eye(n-m);
G=cat(2,P',I);         %[P'|I]��Ϊ���ɾ���
%G=cat(2,I,P');
%t=mod(G'*H,2);      
%end
