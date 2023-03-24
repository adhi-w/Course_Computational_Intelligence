%Initialize PArameters
Var = 2;                      
Swarm_Pop = 60;                     
Iteration_max = 100;                
acc1=1.2;                       
acc2=1.2;                       
wI = linspace(1,0,itmax);   
 
%%Upper & Lower Bound for var x and y
a(1:Swarm_Pop,1)=-1;  b(1:Swarm_Pop,1)=1;   
a(1:Swarm_Pop,2)=3;  b(1:Swarm_Pop,2)=6;   
d=(b-a);   m=a; n=b; 
%Initial velocity
q=(n-m)/10;                
 
%random initialization
x=a+d.*rand(Swarm_Pop,Var); %Position
vnew=q.*rand(Swarm_Pop,Var);
v0=vnew;                    %Initial velocity
Fitness=function4(x,Swarm_Pop);      %Calculate Fitness
 
pBest(1:Swarm_Pop,1:Var)=x;      
pBest(1:Swarm_Pop,Var+1)=Fitness;
%pBest
pBesti=pBest;               
pBest0=pBest;               
sum=max(Fitness);             
 
%gBest
[rowx colx]=find(sum==pBest);
gBest=pBest(rowx,1:colx);
gBest0=gBest;              
 
%Iteration
for i=1:Iteration_max
    w=wI(i);                
    
    %Generate and Update velocity
    [vnew] = Updatevelocity(pBest,pBesti,gBest,w,vnew,acc1,acc2,Swarm_Pop,Var,rowx);
    vdata(:,2*i-1:2*i)=vnew;
    
    %Generate new location of pBest
    [xnew] =newPos(pBest,vnew,Swarm_Pop,Var);
    x=xnew;
    
    %calculate Fitness
    Fitness=function4(x,Swarm_Pop);              
    pBesti= [x(:,1:2) Fitness(:,1)];    
    pBestidata(i,:)=pBesti(:,3);   
    
    %update pbest
    pBest = update(pBest,pBesti,Swarm_Pop);
   
    b=max(pBest(:,3));  %Determine gbest
    [rowx colx]=find(b==pBest(:,3));
    
    j = size(rowx);
    if (j(1,1)>1)
       rowx1(1:j(1,1),1:2)=[rowx(1:j(1,1),1) rand(j(1,1),1)];
       [row col]= find(max(rowx1(:,2))==rowx1(:,2));
       rowx(1,1)=rowx1(row,1);
    end
    gBest=pBest(rowx(1,1),1:3);
    gBestdata(i,:) =gBest;              %update gbest
    
end
