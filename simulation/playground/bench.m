clear all;
N=2*1024;
g=gpuDevice();
 simabs=false;
%all units are in nm
wavelength=1;
dx=wavelength/2;
dz=dx/2;

objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.radius=50;
objects{1}.beta=1e-2;
objects{1}.delta=1e-2;

% out= singlerun(N,dx,dz,wavelength,objects);

wait(g);
t=tic;
out= singlerun2(N,dx,dz,wavelength,objects,simabs);
toc(t);
% 
% %%
% scale1=out.exitwave.multislice(end/2+5,end/2+5)
% scale2=out.exitwave.FTproj(end/2+5,end/2+5)
% 
% figure(1);imagesc(abs(ft2(out.exitwave.multislice./scale1)));caxis([0,2])
% figure(2);imagesc(abs(ft2(out.exitwave.FTproj./scale2)));caxis([0,2])
% 
% %%
% figure(3);clf;
% hold on;
% semilogy(out.profile_scale,abs(out.profile_error_abs.FTproj));
% semilogy(out.profile_scale,abs(out.profile_error_abs.multislice));
% set(gca,'yscale','log')
% set(gca,'xlim',[0,20])

%%

figure(simabs*10+1)
clf
hold on;
plot(out.profile_scale,out.profile_mie);
plot(out.profile_scale,out.profile_scatter.msft);
set(gca,'yscale','log')
set(gca,'xlim',[0,20])
legend('mie','msft');
title(num2str(simabs))
figure(simabs*10+2)
clf
hold on;
plot(out.profile_scale,out.profile_error_rel.msft);
set(gca,'xlim',[0,20])
title(num2str(simabs))
