%	Simulated Annealing
clear all
clc
 
dist = TSP(10); 
distOrigin = dist;
startTime = cputime;
 
distM1 = size(dist,1);
distM12 = size(dist);
 
for i=1:distM1
    dist(i,i)=10e+06;
end
 
for i=1:distM1-1
    for j=i+1:distM1
        dist(j,i)=dist(i,j);
    end
end
%___________Parameters Initialization___________________
%____________To Initial, temperature is set equal to the initial solution value
dist1=dist;
tour = zeros(distM12);
cost = 0;
minDist=[];
shortPath=[];
 
Tr = 300;            %temperature transitions
ATr = 200;           %Accepted temperature transitions
coolRate = 0.99;     %Temperature decrementing factor
Rf = 0.001;          %Acceptance ratio
iterationMax = 10000;%Max iterations
 
%____________Find shortest path from each node & avoid a subtour_______
k = 1;
for i=1:distM1-1
    minDist(i) = min(dist1(k,:));
    shortPath(i) = find((dist1(k,:)==minDist(i)),1);
    cost = cost+minDist(i);
    k = shortPath(i);
    dist1(k,1)=10e+06;
    
    for visited_node = 1:length(shortPath);
        dist1(k,shortPath(visited_node))=10e+06;
    end
end
tour(1,shortPath(1))=1;
 
for i=2:distM1-1
    tour(shortPath(i-1),shortPath(i))=1;
end
%____________k is the last visited node
lastIndex = length(shortPath)+1;
shortPath(lastIndex)=1;
tour(k,shortPath(lastIndex))=1;
cost = cost+dist(k,1);
 
currentTour = shortPath;
bestTour = shortPath;
bestObject = cost;
currentTourCost = cost;
objectPrev = currentTourCost;
 
currentTour
 
nbr = currentTour;
T0 = 1.5*currentTourCost;
T=T0;
iter = 0;
iterSyncLastChange = 0;
acceptRatio =1;
 
while (iter < iterationMax & acceptRatio > Rf)
    iter = iter+1;
    transTried = 0;
    transAccept = 0;
    while(transTried < Tr & transAccept < ATr)
        transTried = transTried + 1;
        city1 = round(random('uniform', 1, distM1-1));
        city2 = round(random('uniform', 1, distM1-1));
        while (city2 == city1)  city2 = round(random('uniform', 1, distM1-1));
        end
        if (city2>city1)
            i=city1;
            j=city2;
        else
            i=city2;
            j=city1;
        end
        nbr(i)=currentTour(j);
        nbr(j)=currentTour(i);
 
        if i==1
            if j-i==1
                nbrCost=currentTourCost-dist(1,currentTour(i))+dist(1,currentTour(j))- dist(currentTour(j),currentTour(j+1))+dist(currentTour(i),currentTour(j+1));
            else
                nbrCost=currentTourCost-dist(1,currentTour(i))+dist(1,currentTour(j))- dist(currentTour(j),currentTour(j+1))+dist(currentTour(i),currentTour(j+1))- dist(currentTour(i),currentTour(i+1))+dist(currentTour(j),currentTour(i+1))-dist(currentTour(j- 1),currentTour(j))+dist(currentTour(j-1),currentTour(i));
            end
        else
            if j-i==1
                nbrCost=currentTourCost-dist(currentTour(i-1),currentTour(i))+dist(currentTour(i-1),currentTour(j))- dist(currentTour(j),currentTour(j+1))+dist(currentTour(i),currentTour(j+1));
            else
                nbrCost=currentTourCost-dist(currentTour(i-1),currentTour(i))+dist(currentTour(i-1),currentTour(j))- dist(currentTour(j),currentTour(j+1))+dist(currentTour(i),currentTour(j+1))- dist(currentTour(i),currentTour(i+1))+dist(currentTour(j),currentTour(i+1))-dist(currentTour(j- 1),currentTour(j))+dist(currentTour(j-1),currentTour(i));
            end
        end
        delta = nbrCost - currentTourCost;
        prob1 = exp(-delta/T);
        prob2 = random('uniform',0,1);
        
        if(delta < 0 | prob2 < prob1)
            %sum = sum+delta;
            currentTour= nbr;
            currentTourCost = nbrCost;
            transAccept = transAccept + 1;
            if currentTourCost < bestObject
                bestObject = currentTourCost;
                bestTour = currentTour;
            end
         else
            nbr = currentTour;
            nbrCost = currentTourCost;
        end
    end
    acceptRatio = transAccept/transTried;
    fprintf('\niter# = %d\t, T = %2.2f\t, obj = %d\t, accpt ratio=%2.2f', iter,T,currentTourCost,acceptRatio);
    
    dataTemp(iter,1)= T;
    dataObj(iter,1)= currentTourCost;
    dataAcceptRatio(iter,1) = acceptRatio;
    
    if currentTourCost == objectPrev
        iterSyncLastChange = iterSyncLastChange + 1;
    else
        iterSyncLastChange = 0;
    end
    if iterSyncLastChange == 10 break;
    end
    objectPrev = currentTourCost;
    T = coolRate*T;
 
end
end_time = cputime;
exec_time = end_time - startTime;
