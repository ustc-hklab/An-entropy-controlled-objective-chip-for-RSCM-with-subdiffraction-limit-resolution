clear;clc;
load Exy_4umRange;
[Xo,Yo]=meshgrid(x_o,x_o);
Exy=Exy/max(max(abs(Exy)));

wavelength=0.405;
x=(-2:0.01:2)+1e-7;
y=x;
[xx yy]=meshgrid(x,y);
r=sqrt(xx.^2+yy.^2);

PSF_2Dlens=interp2(Xo,Yo,Exy,xx,yy);
PSF_2Dlens(isnan(PSF_2Dlens))=0;

ctc_distance=[190, 200, 220, 240, 250,270];
%%

for m=1:length(ctc_distance)
    ctc=ctc_distance(m)/1000;
    ds_i=rect(0.01,xx-ctc/2).*rect(2,yy)+rect(0.01,xx+ctc/2).*rect(2,yy);
    %     figure(1);imagesc(x,y,ds_i');axis([-1.2 1.2 -0.3 0.3]);colormap gray
    ds_o=zeros(801,801);
    ds_o((-200:200)+401,(-200:200)+401)=ds_i;
    k=2*pi/wavelength;
    
    M=100;
    NA_col=0.8343;
    t1=k*NA_col*r;
    psf_collection=(besselj(0,t1)+besselj(2,t1));
    
    NA_obj=0.9;
    t2=k*NA_obj*r;
    PSF_objective=(besselj(0,t2)+besselj(2,t2));
    
    
    xs=-1.2:0.02:1.2;  % scan range
    ys=-0.3:0.02:0.3;
    Is_2Dlens=zeros(length(xs),length(ys));
    Is_objective=zeros(length(xs),length(ys));
    pupil=zeros(801,801);
    [xp yp]=meshgrid((-400:400),(-400:400));
    rp=sqrt(xp.^2+yp.^2);
    pupil(rp<=500)=1;
    
    for nx=1:length(xs)
        tic
        for ny=1:length(ys)
            ds=ds_o((-200:200)+401-round(xs(nx)/0.01),(-200:200)+401-round(ys(ny)/0.01));
            
            I2Dlens=conv2(psf_collection,ds.*(PSF_2Dlens));
            Is_2Dlens(nx,ny)=sum(sum(abs(I2Dlens.*pupil).^2));
            
            
            Iobjective=conv2(PSF_objective,ds.*(PSF_objective));
            Is_objective(nx,ny)=sum(sum(abs(Iobjective.*pupil).^2));
        end
        toc
        fprintf('%d \n',nx);
    end
        
    figure;imagesc(ys,xs,Is_2Dlens);
    %     title(num2str(nn))
    figure;imagesc(ys,xs,Is_objective);
    %     title(num2str(nn))
end

