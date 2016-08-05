function [Rout,meanData,stdData,minData,maxData]=rprofil(data,limit,precision,offset)
   % Calculates radial profile of an image (with GPU sopport)
   % Returns an array of distances and corresponding array of mean values at
   % those distances as well as standard deviation, min/max value for each
   % distance. Limit limits the distance (e.g. to N/2, default: all), precision controls
   % which pixels are binned (number of decimal places of the distances, default:0)
   % ffz2016
   
    if nargin<2;limit=Inf;end
    if nargin<3;precision=0;end
    if nargin<4;offset=0;end
    
    Nx=size(data,1);
    Ny=size(data,1);
    centerx=Nx/2+1+offset;
    centery=Ny/2+1+offset;
    
    %calculate distances of each pixel
    if isa(data,'gpuArray')
        [XX,YY]=meshgrid(gpuArray.linspace(1-centerx,Nx-centerx,Nx),gpuArray.linspace(1-centery,Ny-centery,Ny));
        R=round(hypot(XX,YY)*10^precision)./10^precision;
    else
        [XX,YY]=meshgrid(linspace(1-centerx,Nx-centerx,Nx),linspace(1-centery,Ny-centery,Ny));
        R=round(hypot(XX,YY),precision);
    end
    
    %apply distance limit
    data=data(R<limit);
    R=R(R<limit);
    
    %unique distances
    [Rout,~,iR]=unique(R,'sorted');
    
    %calculate mean
    sumData = accumarray(iR,data);
    N=accumarray(iR,1);
    meanData=sumData./N;
    
    if nargout > 2
        %calculate standard deviation
        sumData2 = accumarray(iR,data.^2);
        stdData=sqrt(abs(sumData2./N-meanData.^2));
        if nargout >3
            %calculate min and max
            minData=accumarray(iR,data,[],@min);
            maxData=accumarray(iR,data,[],@max);
        end
    end
end