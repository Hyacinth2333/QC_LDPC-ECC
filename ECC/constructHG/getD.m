function [D]=getD
A=eye(256);
    D=zeros(256);
    m1=round(rand(1,1)*63);  
    m2=64+m1;
    m3=128+m1;
    m=[m1,m2,m3];
    
    for i=1:1:3
        D=D+circshift(A,m(1,i),2);
    end
 x=rank(D) 

 
 
end
