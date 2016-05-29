% load('dens.mat')
clear all;
N=4*1024;
%all units are in nm
wavelength=1;
dx=wavelength;
dz=dx/2;
nruns=10;
runs=cell(nruns,1);
tic
%% radius
for n=1:nruns;
    rad=n*10;
    objects=cell(1);
    objects{1}=scatterObjects.sphere();
    objects{1}.beta=1e-3;%0.01;%1.78E-4;
    objects{1}.delta=1e-3;%0.01%0.01;%1.34E-5;
    objects{1}.radius=rad;
    currun=singlerun(N,dx,dz,wavelength,objects);
    runs{n}=currun;
end

%%
for n=1:nruns
    runs{n}.errors_rms
end
toc