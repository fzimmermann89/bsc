function [out,resolution]=frc(image1,image2)
    Nx=size(image1,1);
    Ny=size(image1,2);
    centerx=Nx/2+1;
    centery=Ny/2+1;
    limit=min(Nx-centerx,Ny-centery);
    precision=0;
    
    %calculate distances of each pixel
    if isa(image1,'gpuArray')||isa(image2,'gpuArray')
        image1=gpuArray(image1);
        image2=gpuArray(image2);
        [XX,YY]=meshgrid(gpuArray.linspace(1-centerx,Nx-centerx,Nx),gpuArray.linspace(1-centery,Ny-centery,Ny));
        R=round(hypot(XX,YY)*10^precision)./10^precision;
    else
        [XX,YY]=meshgrid(linspace(1-centerx,Nx-centerx,Nx),linspace(1-centery,Ny-centery,Ny));
        R=round(hypot(XX,YY),precision);
    end
    
    
    
    Fimage1=ft2(image1);
    Fimage2=ft2(image2);
    
    %apply distance limit
    Fimage1=Fimage1(R<limit);
    Fimage2=Fimage2(R<limit);
    R=R(R<limit);
        [uR,~,iR]=unique(round(R),'sorted');
      out=accumarray(iR,Fimage1.*conj(Fimage2)) ...
            ./sqrt(...
                  accumarray(iR,Fimage1.*conj(Fimage1)).*accumarray(iR,Fimage2.*conj(Fimage2))...
                  );
    resolution=limit./uR;
%     %unique 1/distances
%     [resolution,~,iresolution]=unique(round(max(R(:))./R),'sorted');
%     
% %     calculate frc
%     out=accumarray(iresolution,Fimage1.*conj(Fimage2)) ...
%         ./sqrt(...
%         accumarray(iresolution,Fimage1.*conj(Fimage1)).*accumarray(iresolution,Fimage2.*conj(Fimage2))...
%         );
%     
    out=smooth(out,32,'moving');
end