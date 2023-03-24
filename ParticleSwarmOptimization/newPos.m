%Function for update position
function [newpos] = newPos(pBest,vNew,iteration,Var)
for i = 1:iteration
    for j = 1:Var
        xnewPos(i,j)=pbest(i,j)+vNew(i,j);
    end
end
poslim = locationlimit(xnewPos,iteration);
newpos = poslim;
