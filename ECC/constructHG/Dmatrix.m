load('D:\ECC\H.mat');
d0=H(1,1:256);
d1=H(257,257:512);
d2=H(513,513:768);
d3=H(769,769:1024);
D0=[];D1=[];D2=[];D3=[];
for i=1:1:256
    if d0(1,i)
        D0=[D0,i];
    end
    if d1(1,i)
        D1=[D1,i];
    end
    if d2(1,i)
        D2=[D2,i];
    end
    if d3(1,i)
        D3=[D3,i];
    end
end
D=cat(1,D0,D1,D2,D3);
    