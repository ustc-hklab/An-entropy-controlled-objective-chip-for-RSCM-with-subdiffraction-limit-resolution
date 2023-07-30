wavelength=0.405;
M=0;
N=6391;
f=1000;
rindex=1; %refractive index
%%
n=1:N;
rho=sqrt((2*M+1)*(wavelength/rindex)*n*f+((2*M+1)*(wavelength/rindex)*n/2).^2);
rho=round(rho*1000)/1000;
NAr=sin(atan(rho/f));
 
NdNA=length(pg);
NA=zeros(size(pg));
Nnum=NA;
for n=1:NdNA
    NA(n)=sum(pg(1:n))*(0.9355738382);
    NAmin=min(abs(NAr-NA(n)));
    Nnum(n)=find(abs(NAr-NA(n))==NAmin);
end
Nnum=unique([0, Nnum]);

save('Nnum.mat','Nnum');
%% 计算位相mask反转之后的环带
Nnum=Nnum(2:end);
b=ones(1,length(rho));
if Nnum(end)==length(rho)
    b(Nnum(1:end-1))=0;
else
    b(Nnum)=0;
end
rho(b==0)=[];
R=[0,rho];  %最终结果
save('R.mat','R');
min(diff(R));