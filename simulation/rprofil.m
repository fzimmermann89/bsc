function [rout,out]=rprofil(data,limit,precision)
    if nargin<2;limit=Inf;end
    if nargin<3;precision=0;end
    Nx=size(data,1);
    Ny=size(data,1);
    centerx=Nx/2+1;
    centery=Ny/2+1;
    [XX,YY]=meshgrid((1:Nx)-centerx,(1:Ny)-centery);
    R=round(hypot(XX,YY),precision);
    [rout,~,iR]=unique(R(R<limit),'sorted');
    out = accumarray(iR,data(R<limit),[],@sum);
    N=accumarray(iR,data(R<limit)-data(R<limit)+1,[],@sum);
    out=gather(out./N);
end