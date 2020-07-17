%function [E]=getE(M)

M=PEGgetM(4,32,3);
E=M;
G=cell(4);
for i=1:1:4
    if M(i,1)==1
        E(i,1)=round(rand(1,1)*255);
    end
end

for i=1:1:4
    if M(i,1)==1
        for j=1:1:4
            if M(j,1)==1&&(j~=i)
                G{i,j}=[abs(E(i,1)-E(j,1)),256-abs(E(i,1)-E(j,1))];
            end
        end
    end
end
hwait=waitbar(0,'plz wait ...');
for i=2:1:32
    n=0;
    m=0;
    g=0;
    waitbar(i/32,hwait,num2str(i));
    for j=1:1:4
        if M(j,i)==1
            n=j;
            E(n,i)=round(rand(1,1)*255);
            break;
        end
    end
    
    for k=1:1:4
        if M(k,i)==1
            if k==n
                continue;
            else
                m=k;
                break;
            end
        end
    end
    
    for h=1:1:4
        if M(h,i)==1
            if h==n
                continue;
            else
                if h==m
                    continue;
                else
                    g=h;
                    break;
                end
            end
        end
    end
    
    Lmn=length(G{m,n});
    for z=1:1:255
        flag0=ValueSelec(z,E(n,i),G{m,n},Lmn);
        if flag0==1
            continue
        end
        E(m,i)=z;
        break;
    end
    if Lmn>=1
        G{m,n}=[G{m,n},abs(E(m,i)-E(n,i)),256-abs(E(m,i)-E(n,i))];
    else
        G{m,n}=[abs(E(m,i)-E(n,i)),256-abs(E(m,i)-E(n,i))];
    end
     
     Lgn=length(G{g,n});
     Lgm=length(G{g,m});
     for x=1:1:255
         flag1=ValueSelec(x,E(n,i),G{g,n},Lgn);
         if flag1==1
             continue;
         end
         flag2=ValueSelec(x,E(m,i),G{g,m},Lgm);
         if flag2==1
             continue;
         end
         E(g,i)=x;
         break;
     end
     if Lgn>=1
         G{g,n}=[G{g,n},abs(E(g,i)-E(n,i)),256-abs(E(g,i)-E(n,i))];
     else
         G{g,n}=[abs(E(g,i)-E(n,i)),256-abs(E(g,i)-E(n,i))];
     end
     
     if Lgm>=1
         G{g,m}=[G{g,m},abs(E(g,i)-E(m,i)),256-abs(E(g,i)-E(m,i))];
     else
         G{g,m}=[abs(E(g,i)-E(m,i)),256-abs(E(g,i)-E(m,i))];
     end
end
close(hwait);

            
         
        
                        
                 
        
    



                    
                
        
        
            
                
        
