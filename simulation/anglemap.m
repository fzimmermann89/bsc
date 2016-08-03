function out=anglemap(N,dx,wavelength)
    range=gpuArray(-N/2:N/2-1)*(wavelength/(N*dx));
[x,y]=meshgrid(range.^2);
tmp=sqrt(x+y);
tmp(tmp>1)=NaN;
out=gather(asin(tmp));
end
