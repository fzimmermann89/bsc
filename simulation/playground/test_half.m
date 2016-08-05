g=gpuDevice();
reset(g);
clear all;
dx=1/2;
wavelength=1;
dz=1/4;
N=2048;
radius=25;
beta=1e-3;
delta=1e-3;

gpu=true;
objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.radius=radius;
objects{1}.beta=beta;
objects{1}.delta=delta;
%%
tic;
exitwave2=(multislice(wavelength,objects,2*N,dx,dz,gpu,false));
exitwave2=exitwave2-exitwave2(1);
toc;
%%
tic;
scatter2=(abs(ft2(exitwave2)).^2*(dx^2));
exitwave2=gather(exitwave2);
[~,r2]=rprofil(scatter2,N);

scatter2h=halfimage(scatter2);
scatter2=gather(scatter2);
[~,r2h]=rprofil(scatter2h,N/2);
scatter2h=gather(scatter2h);

r2=gather(r2);
r2h=gather(r2h);
toc;
%%
tic;
exitwave1=(multislice(wavelength,objects,N,dx,dz,gpu));
exitwave1=exitwave1-exitwave1(1);
% exitwave1t=(thibault(wavelength,objects,N,dx,dz,gpu));
toc;
%%
tic;
scatter1=(abs(ft2(exitwave1)).^2*(dx^2));
exitwave1=gather(exitwave1);
[~,r]=rprofil(scatter1,N/2);
scatter1=gather(scatter1);
r=gather(r);
r(1)
toc;

%%
tic
exitwavep=pad2size(exitwave2,8*N,exitwave2(1));
scatterp=(abs(ft2(exitwavep)).^2*(dx^2));
scatterp=gather(scatterp);
[~,rp]=rprofil(scatterp,4*N);
scatterp=gather(scatterp);
exitwavep=gather(exitwavep);
rp=gather(rp);
toc
%%
x=asin(((0:N/2-1)*1/(N*dx))*wavelength)';
x2=asin(((0:N-1)*1/(2*N*dx))*wavelength)';
x4=asin(((0:2*N-1)*1/(4*N*dx))*wavelength)';
x8=asin(((0:4*N-1)*1/(8*N*dx))*wavelength)';

%%
[~,rmie]=mie(wavelength,radius,beta,delta,x);
% ende=1000;
% start=800;
% spanm=max(rmie(start:ende))-min(rmie(start:ende))
%             offsetm=mean(rmie(start:ende))
%             offsetr=mean(r2(start:ende))
%             spanr=max(r2(start:ende))-min(r2(start:ende))
%             rmie=((rmie-offsetm)*(spanr/spanm))+offsetr;
% x2(start)
% x2(ende)

figure(1);
clf
hold on; 
r=r./max(r(2:end/2));
r2h=r2h./max(r2h(2:end/2));
r2=r2./max(r2(2:end/2));
rp=rp./max(rp(2:end/2));
rmie=rmie./max(rmie(2:end/2));



plot(x,r);plot(x,r2h);plot(x,r2(1:2:end));plot(x,rp(1:8:end));plot(x,rmie);


legend({'r','r2h','r2','rp','mie'});     
set(gca,'yscale','log');
hold off;
% 
% multislice 4k
% halfimage
% rprofil
% multislice 2k
% rprofil
% 
% mie
% mie sampled
% mie oversampled