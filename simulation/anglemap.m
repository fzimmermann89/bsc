function out=anglemap(N,dx,wavelength)
    % creates a NxN matrix with the scatter angles
    
    range=gpuArray(single(-N/2:N/2-1))*(wavelength/(N*dx));
    [x,y]=meshgrid(range.^2);
    tmp=sqrt(x+y);
    tmp(tmp>1)=NaN;
    out=gather(asin(tmp));
end
