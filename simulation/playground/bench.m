clear all;
N=2*1024;
g=gpuDevice();

%all units are in nm
wavelength=1;
dx=wavelength/2;
dz=dx/2;

objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.radius=50;
objects{1}.beta=1e-4;
objects{1}.delta=1e-4;

% out= singlerun(N,dx,dz,wavelength,objects);

wait(g);
tic;
out= singlerun2(N,dx,dz,wavelength,objects);
wait(g)
toc;
