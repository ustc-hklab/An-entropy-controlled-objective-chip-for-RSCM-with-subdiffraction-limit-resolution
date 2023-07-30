function result=fitness(dNA,N,sign,Amplr,Amplz)

[Nx1 Ny1]=size(Amplr);
[Nx2 Ny2]=size(Amplz);

wavelength=0.405;
rindex=1; %refractive index
f=1000;
N=6391;
M=0;
%%
k0=2*pi/wavelength;
sin_theta_max=0.9;
na=sin_theta_max*rindex;
%%
n=1:N;
rho=sqrt((2*M+1)*(wavelength/rindex)*n*f+((2*M+1)*(wavelength/rindex)*n/2).^2);
rho=round(rho*1000)/1000;
NAr=sin(atan(rho/f));
 
NdNA=length(dNA);
NA=zeros(size(dNA));
Nnum=NA;
const=sum(dNA);
for n=1:NdNA
%     NA(n)=sum(dNA(1:n))*(0.9355738382);
  NA(n)=sum(dNA(1:n))/const;
    NAmin=min(abs(NAr-NA(n)));
    Nnum(n)=find(abs(NAr-NA(n))==NAmin);
end
Nnum=unique([0, Nnum]);

Er=zeros(Nx1,1);

Ez=zeros(Nx2,1);

for n=2:length(Nnum)
    if Nnum(n-1)+1==Nnum(n)
        Er=Er+(-1)^(n)*(Amplr(:,Nnum(n)));
        Ez=Ez+(-1)^(n)*(Amplz(:,Nnum(n)));
    else
        Er=Er+(-1)^(n)*sum(Amplr(:,1+Nnum(n-1):Nnum(n)),2);

        Ez=Ez+(-1)^(n)*sum(Amplz(:,1+Nnum(n-1):Nnum(n)),2);
    end
end
Ir=abs(Er).^2;
Ir=Ir/Ir(1);
Iz=abs(Ez).^2; 

x=(0:0.01:1)*(wavelength/rindex);


L=0.5;
z00=(-50:0.1:50)+f;
delta=0.1;
center=round(length(z00)/2);
Iz=Iz/Iz(center-.0);

%%
DOF=(wavelength/rindex)/(1-sqrt(1-sin_theta_max^2));
goal_x=abs(besselj(0,k0*x*na)').^2;
goal_y=(exp(-(z00-f).^2/(DOF)^2))';

result1=sqrt(sum(abs(goal_x-Ir).^2)/(length(x)));
result2=sqrt(sum(abs(goal_y-Iz).^2)/(length(z00)));
result=result1+result2;

if sign==1
   figure(1); plot(x/(wavelength/rindex),Ir/max(Ir),'r'); xlabel('r (\lambda_n)');ylabel('Intensity');
   title(['n=',num2str(rindex),'  lambda=', num2str(wavelength*1000),'nm'])
    figure(2); plot(z00,Iz,'r'); xlabel('z (\mum)');ylabel('Intensity');grid;%axis([5 55 0 1.5])
end
