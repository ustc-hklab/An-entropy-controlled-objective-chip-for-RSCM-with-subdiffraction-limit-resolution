clear;
rindex=1;          %refractive index
wavelength=0.405;  %working wavelength, unit:micron
M=0;
N=6391;         %the total number of corresponding FZP
f=1000;         %focus length, unit:micron
k=2*pi/(wavelength/rindex);
%% calculate the radius of FZP
n=0:N; 
rho=sqrt((2*M+1)*(wavelength/rindex)*n*f+((2*M+1)*(wavelength/rindex)*n/2).^2);
rho=round(rho*1000)/1000;
theta=0;
%%   calculate Amplr
rou=(0:0.01:1)*(wavelength/rindex);
delta=[ 0 0; ]*0.1;
z=f;

for nc=1:1
    count=1;
   for n=2:1:length(rho) 
     r1=rho(n-1)+delta(nc,1);r2=rho(n)+delta(nc,2);
      parfor nr=1:length(rou)
            r0=rou(nr);
            F=@(x,y) 1/2/pi.*exp(1i*k.*sqrt(r0.^2+x.^2+z.^2-2*r0.*x.*cos(theta-y)))...
                ./(r0.^2+x.^2+z.^2-2*r0.*x.*cos(theta-y)).*(1i*k-1./sqrt(r0.^2+x.^2+z.^2-2*r0.*x.*cos(theta-y))).*z.*x;
            Amplr(nr,count,nc)=integral2(F,r1,r2,0,2*pi);
      end
      fprintf('%d  %d  \n',nc,n);
         count=count+1;
   end
end
save Amplr Amplr;
%%  calcualte Amplz

z0=(-50:0.1:50)+f;
delta=[ 0 0]*0.1;
r0=0;

for nc=1:1
    count=1;
   for n=2:1:length(rho) 
     r1=rho(n-1);r2=rho(n);
      parfor nz=1:length(z0)
            z=z0(nz);
            F=@(x,y) 1/2/pi.*exp(1i*k.*sqrt(r0.^2+x.^2+z.^2-2*r0.*x.*cos(theta-y)))...
                ./(r0.^2+x.^2+z.^2-2*r0.*x.*cos(theta-y)).*(1i*k-1./sqrt(r0.^2+x.^2+z.^2-2*r0.*x.*cos(theta-y))).*z.*x;
            Amplz(nz,count,nc)=integral2(F,r1,r2,0,2*pi);
      end
      fprintf('%d  %d  \n',nc,n); 
         count=count+1;
   end
end
save Amplz Amplz;



