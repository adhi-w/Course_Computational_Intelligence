%function for Update Velocity
function [vNew,ta,tb,tc] = Updatevelocity(pBest,pBesti,gBest,w,vNew,c1,c2,Iteration,Var,row)
gbestmatrix=repmat(gbest(1,1:2),N,1);
for i = 1:Iteration;
    for j = 1:Var;
        ta(i,j) = w*vNew(i,j);
        tb(i,j) = rand*c1*(pBest(i,j)-pbesti(i,j));
        tc(i,j) = rand*c2*(gBestmatrix(i,j)-pBesti(i,j));
        vUpdate(i,j) = ta(i,j) + tb(i,j)+tc(i,j);       
    end
end
 
%new velocity for gbest
vUpdate(rowx,1:2)=1*vNew(rowx,1:2);
 
vNew=vUpdate;
vNew = Vlimit(vNew)
