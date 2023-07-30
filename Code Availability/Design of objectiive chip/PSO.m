clear all;
clc;
format long;

c1=1.4962*1;    
c2=1.4962*1;

load Amplz;
load Amplr;

Amplz(:,1:2:end)=-Amplz(:,1:2:end);
Amplr(:,1:2:end)=-Amplr(:,1:2:end);
 
MaxDT=500;

w=0.7298;

D=5;
N=20;
eps=10^(-6);
rng('default');

ss=0;
x=zeros(N,D);
v=zeros(N,D);
for i=1:N
    %     for j=1:D
    s1=rand(1,D)*0.5;
    s2=(rand(1,D)-0.5)*2*1;
    if ss==1
        x(i,1:D)=pg;
    else
        x(i,1:D)=s1;
    end
    v(i,1:D)=s2;
    
    %     end
end
%%----------------------------

p=zeros(N,1);
for i=1:N
    p(i)=fitness(x(i,:),D,0,Amplr,Amplz);
end 
y=x;
pg=x(1,:);

fitness_p=p;
fitness_pg=p(1);

for i=2:N
    if fitness_p(i)<fitness_pg
        pg=x(i,:);
    end
end
tic
for t=1:MaxDT
    
    for i=1:N
        v(i,:)=w(1)*v( i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:));
        if mean(v(i,:))<=1e-2
            v(i,1:D)=(rand(1,D)-0.5)*0.1;
        end
       x(i,:)=(x(i,:)+v(i,:));
       for d=1:D
            if x(i,d)<0
                x(i,d)=0.000001;
           elseif x(i,d)>0.2
              x(i,d)=rand*0.2;  
            end
        end
        x(i,:)=x(i,:)/sum(x(i,:));
  
        fit=fitness(x(i,:),D,0,Amplr,Amplz);
        if fit<p(i)
            p(i)=fit;
            y(i,:)=x(i,:);
        end
        if p(i)<fitness_pg
            pg=y(i,:);
            fitness_pg=p(i);
            save pg pg;
            count=0;
        end
    end
    count=count+1;
    fprintf('%d  fitness=%f \n',t,fitness_pg)
    if count>100
        for i=1:N
            x(i,1:D)=pg;
                s2=(rand(1,D)-0.5)*2*1;
             v(i,1:D)=s2;   
        end
        count=0;
    end 
end
toc
fitness(pg,D,1,Amplr,Amplz);
run addmask;

