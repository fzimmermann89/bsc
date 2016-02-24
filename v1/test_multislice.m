tic;
N=512;
gpu=true;
tmp=true; %just an addition var for debugging
distanceDetektor=0; %not yet used

o=scatterObjects.cube();
o.rotationX=15*pi/180;
o.rotationY=15*pi/180;
o.rotationZ=15*pi/180;
o.beta=1e-3;
o.radius=100;


wavelength=1;
dx=wavelength;

figure(7)

image1=multislice(wavelength,o,N,dx,distanceDetektor,gpu,tmp);
%(wavelength,objects,N,dx,distanceDetektor,gpu,maskactive)
image_cpu1=gather(image1);
imagesc(abs(image_cpu1));
caxis([0.9 1.1]);
colorbar;
toc

figure(8)
imagesc(log(abs(ft2(image1))))
colorbar;
caxis([-5,5])