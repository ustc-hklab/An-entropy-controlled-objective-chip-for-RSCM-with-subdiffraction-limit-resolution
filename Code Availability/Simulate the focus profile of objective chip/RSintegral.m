function Eout = RSintegral(U,lambda,x_o,y_o,z,r1,r2,rindex)
%x_o,y_o are the output plane coordinates;
% z is propagation distance
% r1, r2 are the radius of input ring
% NOTE: calculated in polar coordinates

[X_o, Y_o]=meshgrid(x_o,y_o);  % output plane
phi=atan2(Y_o,X_o);
rou=sqrt(X_o.^2+Y_o.^2);
[row,col]=size(rou);

k=2*pi/(lambda/rindex);
Eout=zeros(row,col,length(z));
for t=1:length(z)
    for m=1:row
        for n=1:col
            R=@(theta,r) sqrt(r.^2+rou(m,n)^2+z(t)^2-2.*r.*rou(m,n).*cos(theta-phi(m,n)));
            fun=@(theta,r) U.*exp(1i*k*R(theta,r))./R(theta,r).^2.*(1i*k-1./R(theta,r)).*z(t).*r;
            Eout(m,n,t)=(-1)/2/pi*integral2(fun,0,2*pi,r1,r2,'AbsTol',1e-12,'RelTol',1e-9 );
        end
    end
end

end

