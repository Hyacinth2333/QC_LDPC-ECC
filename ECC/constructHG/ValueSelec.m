function flag=ValueSelec(E_in1,E_in2,A,L)
if L>=1
        for y=1:1:L
            if abs(E_in1-E_in2)==A(y)
                flag=1;
                break;
            end
            if y==L
                flag=0;
            end
        end
else
        flag=0;
end
end
                