%Function for updating pBest
function pBest = update(pBest,pBesti,iteration);
for i = 1:iteration
    if (pBesti(i,3)>pBest(i,3))
        pBest(i,1:3)=pBesti(i,1:3);
    else
        pBest(i,1:3)=pBest(i,1:3);
    end
end
