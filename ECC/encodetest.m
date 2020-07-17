load('D:\ECC\G.mat');
G1=G(:,1:1024);
din=rand(1,8192);
for i=1:1:8192
    if din(1,i)>0.5
        din(1,i)=1;
    else
        din(1,i)=0;
    end
end
dout=mod(din*G1,2);
fid0=fopen('D:\ECC\encodedin.txt','wt');
fid1=fopen('D:\ECC\encodedout.txt','wt');
for j=1:1:1024
    for k=1:1:8
        fprintf(fid0,'%d',din(1,8*(j-1)+9-k));
    end
    fprintf(fid0,'\n');
end

for m=1:1:128
     for n=1:1:8
         fprintf(fid1,'%d',dout(1,8*(m-1)+9-n));
     end
     fprintf(fid1,'\n');
end