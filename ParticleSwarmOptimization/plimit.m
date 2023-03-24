% Function limit position
function poslimit = plimit(newpos,iteration)
min_x =-1;  max_x = 1;
min_y =-1;  max_y = 2; 

for i = 1:iteration
    a(i,:) = newpos(i,:);
    x(i) = a(i,1);    y(i)= a(i,2);
    if (x(i)<=min_x)  x(i)=min_x;
    else 
        if (x(i)>=max_x)  x(i)=max_x;
        else   x(i)=x(i);
        end
    end
    
    if (y(i)<=min_y)  y(i)=min_y;
    else 
        if (y(i)>=max_y)  y(i)=max_y;
        else  y(i)=y(i);
        end
    end
    poslimit(i,1)=x(i);  poslimit(i,2)=y(i);
end
