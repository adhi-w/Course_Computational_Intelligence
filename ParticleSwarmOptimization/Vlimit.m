%Function for Velocity Limit
function v = Vlimit(v,iteration)
min_x =-2;  max_x = 2;
min_y =-2;  max_y = 2;
 
for i = 1:iteration
    a(i,:)=v(i,:);   x(i)=a(i,1);  y(i)=a(i,2);
    if (x(i)<=min_x)   x(i)=min_x;
    else 
        if (x(i)>=max_x) x(i)=max_x;
        else
            x(i)=x(i);
        end
    end
    
    if (y(i)<=min_y)  y(i)=min_y;
    else 
        if (y(i)>=max_y)  y(i)=max_y;
        else
            y(i)=y(i);
        end
    end
    v(i,1)=x(i);
    v(i,2)=y(i);
end
