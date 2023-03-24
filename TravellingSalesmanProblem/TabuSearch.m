% Tabu Search
clear all 
clc
 
dist(logical(eye(size(dist))))=0;
distOrig = dist;
start_time = cputime;
distM1 = size(dist,1);
distM12 = size(dist);
 
for i=1:distM1
  dist(i,i)=10e+06;
end
    
%_________________Parameters Initialization_____________
dist1=dist;
tour = zeros(distM12);
cost = 0;
minDist=[ ];
shortPath=[ ];
bestNbrCost = 0;
bestNbr = [ ];
 
%_____________Find shortest path & avoid a subtour__________
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
 
%_______________k is the last visited node;
lastIndex = length(shortPath)+1;
shortPath(lastIndex)=1;
tour(k,shortPath(lastIndex))=1;
cost = cost+dist(k,1);
 
currentTour = shortPath;
bestTour = shortPath;
bestObj =cost;
currentTourCost = cost;
 
currentTour
nbrCost=[ ];
 
%_________________Initialize tabuTenure___________
tabuTenure = zeros(distM12);
maxTabuTenure = round(sqrt(distM1));
penalty = zeros(1,(distM1-1)*(distM1-2)/2);
frequency = zeros(distM12);
frequency(1,:)=100000;
frequency(:,1)=100000;
 
for i=1:distM1
    frequency(i,i)=100000;
end
iterSync_lastImprove = 0;
bestNbr = currentTour;
%___________Do the iteration until the program is terminated
for iter=1:10000
    nbr =[];
    % _______________Find all neighbours to current tour 
    % _______________Calculate the object value (cost) for each of the neighbours_
    nbrCost = inf(distM12);
    for i=1:distM1-2
        for j=i+1:distM1-1
            if i==1
                if j-i==1
                    nbrCost(currentTour(i),currentTour(j))=currentTourCost-dist(1,currentTour(i))+dist(1,currentTour(j))- dist(currentTour(j),currentTour(j+1))+dist(currentTour(i),currentTour(j+1));
                    best_i=i;
                    best_j=j;
                    bestNbrCost = nbrCost(currentTour(i),currentTour(j));
                    tabu_node1 = currentTour(i);
                    tabu_node2 = currentTour(j);
                else
                    nbrCost(currentTour(i),currentTour(j))=currentTourCost-dist(1,currentTour(i))+dist(1,currentTour(j))- dist(currentTour(j),currentTour(j+1))+dist(currentTour(i),currentTour(j+1))- dist(currentTour(i),currentTour(i+1))+dist(currentTour(j),currentTour(i+1))-dist(currentTour(j- 1),currentTour(j))+dist(currentTour(j-1),currentTour(i));
                end
            else
                if j-i==1
                    nbrCost(currentTour(i),currentTour(j))=currentTourCost-d(currentTour(i-1),currentTour(i))+d(currentTour(i- 1),currentTour(j))-d(currentTour(j),currentTour(j+1))+d(currentTour(i),currentTour(j+1));
                else
                    nbrCost(currentTour(i),currentTour(j))=currentTourCost-d(currentTour(i-1),currentTour(i))+d(currentTour(i- 1),currentTour(j))-d(currentTour(j),currentTour(j+1))+d(currentTour(i),currentTour(j+1))- d(currentTour(i),currentTour(i+1))+d(currentTour(j),currentTour(i+1))-d(currentTour(j- 1),currentTour(j))+d(currentTour(j-1),currentTour(i));
                end
            end
 
            if nbrCost(currentTour(i),currentTour(j)) < bestNbrCost
                bestNbrCost = nbrCost(currentTour(i),currentTour(j));
                best_i=i;
                best_j=j;
                tabu_node1 = currentTour(i);
                tabu_node2 = currentTour(j);
            end
        end
    end
    %_________Ending of Neighbourhood cost calculation___________
    bestNbr(best_i) = currentTour(best_j);
    bestNbr(best_j) = currentTour(best_i);
    
    while (tabuTenure(tabu_node1,tabu_node2))>0
        if bestNbrCost < bestObj 
            fprintf('\nbest nbr cost = %d\t and best obj = %d\n, hence breaking',bestNbrCost, bestObj);
            break;
        else
            nbrCost(tabu_node1,tabu_node2)=nbrCost(tabu_node1,tabu_node2)*1000;
            bestNbrCost_col = min(nbrCost);
            bestNbrCost = min(bestNbrCost_col);
            [R,C] = find((nbrCost==bestNbrCost),1);
            tabu_node1 = R;
            tabu_node2 = C;
        end
    end
    %______________Continuous diversification__________
    if bestNbrCost > currentTourCost
        min_d_col = min(dist);
        penal_nbrCost = nbrCost + min(min_d_col)*frequency;
        penal_bestNbrCost_col = min(penal_nbrCost);
        penal_bestNbrCost = min(penal_bestNbrCost_col);
        [Rp,Cp] = find((penal_nbrCost==penal_bestNbrCost),1);
        tabu_node1 = Rp;
        tabu_node2 = Cp;
        bestNbrCost = nbrCost(tabu_node1,tabu_node2);
    end
    %______________Decreasing Tabu Tenures_____________
    for row = 1:distM1-1
        for col = row+1:distM1
            if tabuTenure(row,col)>0
                tabuTenure(row,col)=tabuTenure(row,col)-1;
                tabuTenure(col,row)=tabuTenure(row,col);
            end
        end
    end
 
    %_______Enter current moves in Tabu List with tenure = maximum tenure__
    tabuTenure(tabu_node1,tabu_node2)=maxTabuTenure;
    tabuTenure(tabu_node2,tabu_node1)= tabuTenure(tabu_node1,tabu_node2);
    
    %_____Increasing the frequency in Tabu List________
    frequency(tabu_node1,tabu_node2) = frequency(tabu_node1,tabu_node2)+1;
    currentTour=bestNbr;
    currentTourCost=bestNbrCost;
    
    %____________Update best tour___________
    if currentTourCost < bestObj
        bestObj = currentTourCost;
        bestTour = currentTour;
        iterSync_lastImprove = 0;
    else
        iterSync_lastImprove = iterSync_lastImprove + 1;
        if iterSync_lastImprove >= 400
            min_freq_col = min(frequency); %gives minimum of each column
            min_freq = min(min_freq_col);
            [R,C] = find((frequency==min_freq),1); %find the moves with lowest frequency
            freq_indx1 = R
            freq_indx2 = C
            indx_in_currentTour1 = find(currentTour==R); %locate the moves in the crnt tour
            indx_in_currentTour2 = find(currentTour==C);
            
            %Diversify using a move that has the lowest frequency
            temp = currentTour(indx_in_currentTour1);
            currentTour(indx_in_currentTour1) = currentTour(indx_in_currentTour2);
            currentTour(indx_in_currentTour2) = temp;
            tabuTenure = zeros(distM12);
            frequency = zeros(distM12);
            frequency(1,:)=100000;
            frequency(:,1)=100000;
 
            for i=1:distM1
                frequency(i,i)=100000;
            end        
            tabuTenure(R,C)=maxTabuTenure;
            tabuTenure(C,R)=maxTabuTenure;
            frequency(R,C)=frequency(R,C)+1;
            frequency(C,R) = frequency(R,C);
           
            currentTourCost = dist(1,currentTour(1));
 
            for i=1:distM1-1
                currentTourCost = currentTourCost+dist(currentTour(i),currentTour(i+1));
            end        
            iterSync_lastImprove = 0;
 
            if currentTourCost < bestObj
                bestObj = currentTourCost;
                bestTour = currentTour;
            end
        end
    end
 
    data_obj(iter,1)= bestObj;
    data_currentTourCost(iter,1)= currentTourCost;
    
end
 
bestTour
end_time = cputime;
exec_time = end_time - start_time;

