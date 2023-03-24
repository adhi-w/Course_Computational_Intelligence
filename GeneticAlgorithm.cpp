//-------Header LIbrary
#include <string>
#include <stdlib.h>
#include <iostream>
#include<conio.h>
#include <time.h>
#include <math.h>

//-----Defining Static Variable Value
#define CROSSOVER_RATE		0.7
#define MUTATION_RATE		0.01
#define POP_SIZE			10           
#define CHROMO_LENGTH		11
#define X_GENE_LENGTH		5
#define Y_GENE_LENGTH		6
#define GENERATIONS			300

//returns a float between 0 & 1
#define RANDOM_NUM      ((float)rand()/(RAND_MAX+1))

using namespace std;
//------Function 
float F(float x, float y)
{
	return (y+exp(-2*3.14*pow(((x-0.5)/10),2)*pow(sin(5*3.14*x),6)));
}
//----Set the variable
int pop[POP_SIZE][CHROMO_LENGTH];
int npop[POP_SIZE][CHROMO_LENGTH];
int tpop[POP_SIZE][CHROMO_LENGTH];

int m_max=1,ico=0,ico1,it=0;
float x[POP_SIZE], y[POP_SIZE], fx[POP_SIZE];

//Set the sub routine for easy to use
void iter(int [POP_SIZE][CHROMO_LENGTH]);
int u_rand(int);
void tour_sel();
void cross_ov();
void mutat(int);
//---Main Program
void main()
{	
	time_t t;
	srand((unsigned) time(&t));

	int s,ss,k,m,j,i,p[10],n=0,a[10],nit;

	float xx, yy;

 	for(int i=0; i<POP_SIZE; i++)
 	{
 		for(int j=CHROMO_LENGTH-1; j>=0; j--)
 		{
 		
 			pop[i][j]=u_rand(2);	//Initialize Random value
 
 		}
 	}
  	cout<<"\nIteration "<<it<<" is :\n";
  	iter(pop);		//Evaluation
  	it++;
 	getch();

 	while(it<GENERATIONS)
	{	
		time_t t;
		srand((unsigned) time(&t));
  		it++;
	   	cout<<"\nIteration "<<it<<" is :\n";
  		tour_sel();		//Tournament Selection
  		iter(pop);		//Return to Evaluation 
 		getch();
 	}
 	cout<<"\n\nAfter the "<<ico1<<" Iteration, the Maximum Value is : "<<(int)m_max;
 	getch();
}
void iter(int pp[POP_SIZE][CHROMO_LENGTH])
{
	int i,j,sum,avg,max=1;
	float dx[POP_SIZE], dy[POP_SIZE];
	
	FILE *fp;
	fp=fopen("D:\\Courses\\Computational Intelligence\\GA\\hasil.txt","w");

	for(i=0;i<POP_SIZE;i++)
	{
		x[i]=0; y[i]=0;
		dx[i]=0; dy[i]=0;
		
		//Converting chromosome bit length to decimal 
		for(j=0;j<X_GENE_LENGTH;j++)		
		{
			dx[i]=dx[i]+(pp[i][j]*pow(2,(double)X_GENE_LENGTH-1-j));
			x[i]=-1+dx[i]*(1/pow(2,(double)X_GENE_LENGTH-1));
		}

		for(j=X_GENE_LENGTH;j<CHROMO_LENGTH;j++)
		{
			dy[i]=dy[i]+(pop[i][j]*pow(2,(double)CHROMO_LENGTH-1-j));
			y[i]= 3 + dy[i]*(3/pow(2,(double)CHROMO_LENGTH-1));
		}

		//Fitness of objective function
		fx[i]=F(x[i],y[i]);

		sum=sum+fx[i];
		if (max<=fx[i])
			max=fx[i];
	}
	avg=sum/POP_SIZE;
	cout<<"\n\nS.No.\t Population\t dx\t dy\t X\t Y\t\t f(X)\n\n";
	for(i=0;i<POP_SIZE;i++)
	{
		cout<<ico<<"\t";
		ico++;
		for(j=0;j<CHROMO_LENGTH;j++)
			cout<<pp[i][j];
		cout<<"\t"<<dx[i]<<"\t"<<dy[i]<<"\t"<<x[i]<<"\t"<<y[i]<<"\t\t"<<fx[i]<<"\n";
		
		fprintf(fp, "%f\t %f\t %f\t \n", x[i],y[i],fx[i]);
	}
	cout<<"\n\t Sum : "<<sum<<"\tAverage : "<<avg<<"\tMaximum : "<<max<<"\n";
		if (m_max<max)
		{
			m_max=max;
			ico1=it;
		}
}

//--Random Subroutine --> generate random value
int u_rand(int x)
{
	int y;
	y=rand()%x;
	return(y);
}

//--Tournament Selection Subroutine
void tour_sel()
{
	int i,j,k,l,co=0,cc;
	time_t t;
	srand((unsigned) time(&t));
	while(co<POP_SIZE)
	{
		k=u_rand(POP_SIZE);
		while(cc!=0)
		{
			cc=0;
			l=u_rand(POP_SIZE);
			if (k==l)
				cc++;
		}
		if (fx[k]>fx[l])
		{
			for(j=0;j<CHROMO_LENGTH;j++)
				npop[co][j]=pop[k][j];
		}
		else if (fx[k]<fx[l])
		{
			for(j=0;j<CHROMO_LENGTH;j++)
				npop[co][j]=pop[l][j];
		}
		co++;
	}
	getch();
	cross_ov();
	getch();
}

//---Cross Over Subroutine
void cross_ov()
{
	int i,j,k,l,co,temp;
	//time_t t;
	//srand((unsigned) time(&t));
	i=0;
	
	if(RANDOM_NUM < CROSSOVER_RATE)
	{
	while(i<POP_SIZE)
	{
		k=rand()%2;
		while(co!=0)
		{
			co=0;
			l=u_rand(CHROMO_LENGTH);
			if (((k==0) && (l==0)) || ((k==1) && (l==CHROMO_LENGTH)))
				co++;
		}
		if ((k==0) && (l!=0))
		{
			for(j=0;j<l;j++)
			{
				temp=npop[i][j];
				npop[i][j]=npop[i+1][j];
				npop[i+1][j]=temp;
			}
		}
		else if ((k==1) && (l!=CHROMO_LENGTH))
		{
			for(j=l;j<CHROMO_LENGTH;j++)
			{
				temp=npop[i][j];
				npop[i][j]=npop[i+1][j];
				npop[i+1][j]=temp;
			}
		}
		i=i+2;
	}
	for(i=0;i<POP_SIZE;i++)
	{
		for(j=0;j<CHROMO_LENGTH;j++)
		{
			tpop[i][j]=npop[i][j];
			//pop[i][j]=tpop[i][j];
		}
	}
	}
	mutat(POP_SIZE);
}

//---Mutation Subroutine
void mutat(int np)
{
	int i,j,r,temp,k,z;
	i=0;

	if (RANDOM_NUM < MUTATION_RATE)
	{
	while(i<np)
	{
		for(k=0;k<np;k++)
		{
			r=0;
			if (i!=k)
			{
				for(j=0;j<CHROMO_LENGTH;j++)
				{
					if (tpop[i][j]==tpop[k][j])
						r++;
				}
				if (r!=CHROMO_LENGTH-1)
				{
					z=u_rand(CHROMO_LENGTH);
					if (tpop[i][z]==0)
						tpop[i][z]=1;
					else
						tpop[i][z]=0;
					if (npop[k][u_rand(CHROMO_LENGTH)]==0)
						npop[k][u_rand(CHROMO_LENGTH)]=1;
					else
						npop[k][u_rand(CHROMO_LENGTH)]=0;
					mutat(k);
				}
			}}
		i++;
	}
	for(i=0;i<np;i++)
	{
		for(j=0;j<CHROMO_LENGTH;j++)
		{
			pop[i][j]=tpop[i][j];
		}
	}
	}
}
