function [intDet,qx,qy] = msft(dens,gridX,gridY,gridZ,lambda,absorptionLength,fftResolution,ax_load)

% shortAxis = 200;
% longAxis = 300;
% alphaY = 90;
% alphaZ = 90;
% absorptionLength=0;
% fftResolution = 1024;
% lambda=13.5;
% 
% [dens, gridX, gridY, gridZ] = dens_tictac(longAxis,shortAxis,alphaY,alphaZ,50);

imDone = imread('scatman_done.jpg');
imWait = imread('scatman_waiting.png');


j=sqrt(-1);
k=2*pi/lambda;
absorptionCoefficient = 1./absorptionLength;
if (absorptionLength == 0)
    absorptionCoefficient = 0.;
end

dGrid = abs(gridX(2)-gridX(1));

dens_proj = sum(dens,3);
dim = length(dens_proj);

FFTlength = fftResolution;
zeroPaddingLength = abs(FFTlength-length(dens_proj))+ 1 - mod(fftResolution,2);

densFFT = zeros(FFTlength,FFTlength);
densFFT(zeroPaddingLength/2+(1:dim),zeroPaddingLength/2+(1:dim)) = dens_proj;


ndim = length(densFFT);
LGrid = ndim*dGrid;
dq = 2*pi/LGrid;

qx = dq*(1:ndim)-ndim/2*dq;
qy = qx;


nSlices = length(gridZ);
maxSlice = max(gridZ);
minSlice = min(gridZ);
dSlice = (maxSlice-minSlice)/nSlices;


[gridX2d, gridY2d] = meshgrid(gridX,gridY);

[QX QY] = meshgrid(qx,qy);
QZ = real(k*(1-(1-(QX.^2+QY.^2)/k^2).^(1/2)));
mask = (QX.^2+QY.^2<k^2);

Q = (QX.^2+QY.^2+QZ.^2).^(1/2);

cos_theta = abs(QX)./Q;
diffCrossSection = (1+cos_theta.^2)/2;

P = exp(-j*QZ*dSlice);
sumDens = zeros(size(dens_proj));
efield = zeros(size(densFFT));
axes(ax_load);
axis off
% hold off
% rectangle('Position',[0 0 1 1],'FaceColor',[1 .25 .3])
imshow(imWait);
axis square;
drawnow

for i=1:nSlices    
    dens_proj = sum(dens(:,:,i),3);
    densFFTSlice = zeros(FFTlength,FFTlength);
    densFFTSlice(zeroPaddingLength/2+(1:dim),zeroPaddingLength/2+(1:dim)) = dens_proj;
    phase = exp(-j*QZ*dSlice*i);
    tmp = fftshift(fft2(densFFTSlice));
    efield = efield + tmp.*phase.*mask * exp(-absorptionCoefficient*gridZ(i));   
end


axes(ax_load);
hold off
% rectangle('Position',[0 0 1 1],'FaceColor',[.2 1 .5])
% axis([0 1 0 1]);
imshow(imDone)
axis square;
drawnow

intDet = conj(efield).*efield.* diffCrossSection;

figure(19)
plot(log10(intDet(end/2,:)/(max(intDet(end/2,:)))));
caxis([-5 0])
colormap(jet(256))

end

