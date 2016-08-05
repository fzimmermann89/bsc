N=2048;
dx=0.5;
wavelength=1;
beta=1e-3;
delta=beta;
radius=25;

 direkt=mie_scatter3(wavelength,radius,beta,delta);


range=-N/2:N/2-1;
dscale=(wavelength/(N*dx));
[xx,yy]=meshgrid(range);
r=hypot(xx,yy);
angle=asin(min(r*dscale,1));
[uangle,~,iangle]=unique(angle,'sorted');
[~,mieval]=mie(wavelength,radius,beta,delta,uangle);
out=reshape(mieval(iangle),[N,N]);
out=halfimage(out);
rout=rprofil(out,N/2);
rdirekt=rprofil(direkt,N/2);