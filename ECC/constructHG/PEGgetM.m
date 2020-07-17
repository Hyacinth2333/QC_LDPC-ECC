
function [M]=PEGgetM(m,n,col_weight)
M=zeros(m,n);
%给定变量节点度分布序列 dv=0.38354*x+0.04237*x^2+0.57409*x^3
%为了得到更好的性能，此处的度分布序列采用密度进化理论选取
%dv=inline('0.38354*x+0.04237*x.^2+0.57409*x.^3','x');6
%计算每个度分布的节点数
%indv=quadl(dv,0,1);
% a2=round(n*(0.38354/2/indv));
% a3=round(n*(0.04273/3/indv));
% ds(1:a2)=2;
% ds(a2+1:a3+a2)=3;
%ds(a2+a3+1:n)=4;
%这里不考虑校验节点的度分布序列，构造新Tanner图时，均为0
dc=zeros(1,m);
l=zeros(1,n);
%下面展开PEG算法，将每一个变量节点展成l层子图，构造Tanner图
for j=1:n            %对于每一个变量节点循环
      for k=1:col_weight
    % for k=1:ds(j)    %对于度分布循环，控制边的数目
        if k==1
            %若为第一条边，直接寻找最小度分布的校验节点
            k1=find(dc==min(dc));
            M(k1(1),j)=1;
            dc(k1(1))=dc(k1(1))+1;
        else %若不是第一条边，则展成l层子图，寻找在l层最小度分布的校验节点
            flag=1;
            l(j)=1;
            %这里对每一个校验节点是否存在于第l层做标记,最大展开层数待定
            dcf=zeros(1000,m);
            row=find(M(:,j));   %列搜索，搜索为1的行标
            dcf(l(j),row)=1;       %展开第一层
            while(flag)
                l(j)=l(j)+1;
                h_row=M(row,:);
                if  length(row)==1
                    col=find(h_row);
                else
                    col=find(any(h_row(:,1:n)));    %行搜索，寻找为1的列标
                end
                h_col=(M(:,col))';
                if length(col)==1
                    row1=find(h_col);        
                else
                    row1=find(any(h_col(:,1:m)));
                end
                row=row1;
                dcf(l(j),row)=1; 
                if l(j)>=2 
                    %停止展开第一种条件：集合元素停止增长
                   if dcf(l(j),:)==dcf(l(j)-1,:)
                      nc_all=find(dcf(l(j),:)==0);
                      ndc=dc(nc_all);
                      nc=find(ndc==min(ndc));
                      M(nc_all(nc(1)),j)=1;
                      dc(nc_all(nc(1)))=dc(nc_all(nc(1)))+1;
                       break;
                    %停止展开第二种情况：集合元素饱和
                   elseif (sum(dcf(l(j)-1,:))<m) && (sum(dcf(l(j),:))==m)
                      nc1_all=find((dcf(l(j)-1,:)&dcf(l(j),:))==0);
                      ndc1=dc(nc1_all);
                      nc1=find(ndc1==min(ndc1));
                      M(nc1_all(nc1(1)),j)=1;
                      dc(nc1_all(nc1(1)))=dc(nc1_all(nc1(1)))+1;
                      break;
                   end
              end
          end
       end 
    end
end
end


 