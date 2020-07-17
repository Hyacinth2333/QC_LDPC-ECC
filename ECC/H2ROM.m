load('D:\ECC\E.mat');
load('D:\ECC\D.mat');
A=cat(2,E,D);
[m,n]=size(A);

fid=fopen('D:\ECC\H2nmsROM.txt','wt');


for i=1:1:4
    for j=1:1:35
        if j==35
            fprintf(fid,'%s\n',dec2bin(A(i,36-j),8));
        else
            fprintf(fid,'%s',dec2bin(A(i,36-j),8));
        end
    end
end


fclose(fid);




            
            
        
