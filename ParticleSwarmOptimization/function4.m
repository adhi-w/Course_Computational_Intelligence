%Function 4
function f=function4(x,iteration)    
for i=1:iteration
xx=x(i,1);
yy=x(i,2);
f(i,:)=yy+exp(-2*pi*((xx-0.5)/10)^2)*sin(5*pi*xx)^6;
end
