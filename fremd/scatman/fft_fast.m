function [intDet, qx, qy] = fft_fast(dens,gridX,gridY,lambda,fftResolution)

    dens_proj = sum(dens,3);
    dim = length(dens_proj);
    FFTlength = fftResolution;
    zeroPaddingLength = abs(FFTlength-length(dens_proj))+1;

    densFFT = zeros(FFTlength,FFTlength);
    densFFT(zeroPaddingLength/2+(1:dim),zeroPaddingLength/2+(1:dim)) = dens_proj;

    efield=zeros(size(densFFT));
    k=2*pi/lambda;
    ndim = length(efield);

    dGrid = abs(gridX(2)-gridX(1));

    LGrid = ndim*dGrid;
    dq = 2*pi/LGrid;
    qx = dq*(1:ndim)-ndim/2*dq;
    qy = qx;    
    [QX QY] = meshgrid(qx,qy);
    mask = (QX.^2+QY.^2<k^2);
    QZ = real(k*(1-(1-(QX.^2+QY.^2)/k^2).^(1/2)));
    Q = (QX.^2+QY.^2+QZ.^2).^(1/2);
    cos_theta = abs(QX)./Q;
    diffCrossSection = (1+cos_theta.^2)/2;


    efield = (fftshift(fft2(densFFT))).*mask;
    intDet = conj(efield).*efield.*diffCrossSection;

end

