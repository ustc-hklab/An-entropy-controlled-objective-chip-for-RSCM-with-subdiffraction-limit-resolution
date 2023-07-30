%%  test r
clc;clear;load R;
% R(2:2:end)=R(2:2:end)-0.0375;  % insufficient etching width
% R(3:2:end)=R(3:2:end)+0.0375;

PP=1; % if the overetch depth, such as 1.23*pi, then change PP into PP=1.23;

rindex=1;
wavelength=0.405;
f=1000;
x_o=(-0.6:0.01:0.6);
y_o=0;
z=f;
parfor n=2:length(R)
    Ux(:,n-1)=squeeze(RSintegral(exp(1i*PP*pi*(1+(-1)^n)/2),wavelength,x_o,y_o,z,R(n-1),R(n),rindex));
end
Ix=abs(sum(Ux,2)).^2;
Ix=Ix/max(Ix);

figure(2)
plot(x_o,Ix);
xlabel('x(\mum)');
title(['lambda=', num2str(wavelength),'   n=',num2str(rindex)]);
axis tight


%%
x_o=0;
y_o=0;
z=(-50:0.1:50)+f;
parfor n=2:length(R)
    Uz(:,n-1)=squeeze(RSintegral(exp(1i*PP*pi*(1+(-1)^n)/2),wavelength,x_o,y_o,z,R(n-1),R(n),rindex));
end
Iz=abs(sum(Uz,2)).^2;
Iz=Iz/max(Iz);
figure(3)
plot(z,Iz);
xlabel('z(\mum)');
title(['lambda=', num2str(wavelength),'   n=',num2str(rindex)]);
axis([990 1010 0 1])


