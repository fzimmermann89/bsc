load('dens.mat')
N=1024;
%all units are in nm
wavelength=1;
dx=wavelength/2;

gpu=parallel.gpu.GPUDevice.isAvailable;
gpu=true;
tmp=false; %just an addition var for debugging
distanceDetektor=0; %not yet used
maxXY=N/2*dx;
%fprintf('max x/y dim: %f (nm)\n',maxXY);

%create one object
objects=cell(1);
% objects{1}=scatterObjects.cube();
% objects{1}.rotationX=15*pi/180;
% objects{1}.rotationY=15*pi/180;
% objects{1}.rotationZ=15*pi/180;
% objects{1}.beta=1e-2;
% objects{1}.radius=maxXY/2;
% objects{2}=scatterObjects.dodecahedron();
% objects{2}.beta=1e-6;
% objects{2}.radius=maxXY/2;
% objects{2}.positionZ=-maxXY/4;

objects{1}=scatterObjects.matrix(dens);
 objects{1}.beta=1e-6;

tic
m=scatterObjects.toMatrix(objects,N,dx,gpu);
exit;
ftproject=abs(ft2(sum(m,3)));
ftproject(end/2+1,end/2+1)=0;
ftproject=log(ftproject./max(ftproject(:)));

figure(1);subplot(3,1,1);
imagesc(ftproject);axis square;
caxis([-5,0]);
colorbar;
toc

% objects{1}.positionZ=maxXY/4;

% objects{2}=scatterObjects.sphere();
% objects{2}.beta=1e-6;
% objects{2}.radius=maxXY/16;
% objects{2}.positionZ=-maxXY/4;
%

tic;
exitwave=multislice(wavelength,objects,N,dx,gpu,tmp);

%
% figure(9);
% imagesc(abs(exitwave));
% colorbar;
%
%
%projection on detector is (currently) just ft of exitwave

streubild=exitwave;
streubild=ft2(streubild)*(dx^2);
streubild=abs(streubild);
streubild(end/2+1,end/2+1)=0;
streubild=streubild./max(streubild(:));
streubild=log(streubild);

figure(1);subplot(3,1,2);
% range=linspace(-N/2,N/2-1,N)*(1/(N*dx));
imagesc(streubild);axis square;
caxis([-10,0]);
colorbar;
toc

tic
msft=(msft2(wavelength,objects,N,dx,gpu,tmp));

msft_streubild=(abs(msft).^2);
msft_streubild(end/2+1,end/2+1)=0;
msft_streubild=log(msft_streubild./max(msft_streubild(:)));

figure(1);subplot(3,1,3);
imagesc(msft_streubild);axis square;
colorbar;
caxis([-20,0]);
toc