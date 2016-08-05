function out=mie_scatter(wavelength,radius,beta,delta,N,dx,offset)
    %Calculate a 2D scatter image using mie. Uses symmetry to save memory.
    
    if nargin<7;offset=0;end
    out=zeros(N,N);
    
    %calculate unique angles in first quadrant
        range=linspace(-N/2+offset,offset,N/2+1).^2;
        [XX,YY]=meshgrid(range,range);
        R=(sqrt(XX+YY));
        [uR,~,idx]=unique(R,'sorted');
        angle=asin(min(1,(uR/(N*dx)*wavelength)));
    %mie scattering for first quadrant using the unique angles
        [~,mieval]=mie(wavelength,radius,beta,delta,angle);
        mieval=reshape(mieval(idx),[N/2+1,N/2+1]);
    
    %set first quadrant
        out(1:N/2+1,1:N/2+1)=mieval;
    %mirror for other quadrants
        out(N/2+2:end,1:N/2+1)=flipud(mieval(2:end-1,1:end));
        out(1:end,end/2+2:end)=fliplr(out(1:end,2:end/2));
end