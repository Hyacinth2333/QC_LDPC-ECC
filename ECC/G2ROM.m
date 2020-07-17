load('D:\ECC\G.mat')
matrix0=G(:,1:256);
matrix1=G(:,257:512);
matrix2=G(:,513:768);
matrix3=G(:,769:1024);
fid0=fopen('D:\ECC\G2ROM0.txt','wt');
fid1=fopen('D:\ECC\G2ROM1.txt','wt');
fid2=fopen('D:\ECC\G2ROM2.txt','wt');
fid3=fopen('D:\ECC\G2ROM3.txt','wt');
for i=1:256:8192
    for j=1:1:256
        if j==256
             fprintf(fid0,'%d\n',matrix0(i,257-j));
             fprintf(fid1,'%d\n',matrix1(i,257-j));
             fprintf(fid2,'%d\n',matrix2(i,257-j));
             fprintf(fid3,'%d\n',matrix3(i,257-j));
        else
             fprintf(fid0,'%d',matrix0(i,257-j));
             fprintf(fid1,'%d',matrix1(i,257-j));
             fprintf(fid2,'%d',matrix2(i,257-j));
             fprintf(fid3,'%d',matrix3(i,257-j));
        end
    end
end
fclose(fid0);
fclose(fid1);
fclose(fid2);
fclose(fid3);



