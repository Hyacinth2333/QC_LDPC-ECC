%function [H]=getH(row,col,col_weight)
load('D:\ECC\E.mat')
M=PEGgetM(4,32,3);

h1=cell(4,32);
I=eye(256);
for i=1:1:4
    for j=1:1:32
        if M(i,j)==1
            h1{i,j}=circshift(I,E(i,j),2);
        else
            h1{i,j}=zeros(256);
        end
    end
end
H1=cell2mat(h1);
h2=cell(4);
for i=1:1:4
    for j=1:1:4
        if i==j
            h2{i,j}=getD;
        else
            h2{i,j}=zeros(256);
        end
    end
end
H2=cell2mat(h2);
H=[H2 H1];
zhi=rank(H);
[rows,cols] = size(H);
girth_four_num = 0;   % 环四的计数器

for i = 1:rows
    for j = 1:cols
        if H(i,j) == 1
            x1 = i;y1 = j;   % 找到第一个1(x1,y1)(i,j)
            for j1 = j+1:cols      
                if H(i,j1) == 1        % 在同一行找另一个1
                    x2 = i;y2 = j1;   % 同一行的第二个1（x2,y2)(i,j1)
                    for i1 = i+1:rows
                        if H(i1,j1) == 1
                            x3 = i1; y3 = j1;  % 在第二个1所在的列找到另一个1(x3,y3)(i3,j)
                            if H(i1,j) == 1       % 环四计数
                                x4=i1;y4=j1;
                                girth_four_num = girth_four_num+1;
                            end
                        end
                    end
                end
            end
        end
    end
end

%H=[H1 H2];
%end








