clear;clc;

wavelength=0.405;
x=(-2:0.01:2)+1e-7;
y=x;
[xx yy]=meshgrid(x,y);
r=sqrt(xx.^2+yy.^2);

ctc_distance=[190, 200, 220, 240, 250,270];
%%
for m=1:length(ctc_distance)
    ctc=ctc_distance(m)/1000;
    ds_i=rect(0.05,xx-ctc/2).*rect(2,yy)+rect(0.05,xx+ctc/2).*rect(2,yy);
 
    k=2*pi/wavelength;
    NA_col=0.9; 
    t1=k*NA_col*r;
    psf_collection=(besselj(0,t1)+besselj(2,t1));
    
    Img=abs(conv2(psf_collection,ds_i)).^2;  
    idx = round(801/2)+(1:240)-round(240/2);
    idy = round(801/2)+(1:60)-round(60/2);
    Img = Img(idx, idy);
    
    figure(2)
    imagesc(Img); 

end


