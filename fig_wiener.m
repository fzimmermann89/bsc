% Draws graphs for the illustration of deconvolution

clear all
addpath('helper');
addpath('reconstruction');

N=1024;
objwidth=80;
objoffset=-150;
objdip=0.5;
objsum=1e6;
refsum=5e5;
refwidth=43;
refoffset=-objoffset;
noiselvl=1e-3;

normalize=@(in,ref)in./sum(in).*sum(ref);
ft =@(in) fftshift( fft(ifftshift(in)));
ift=@(in) fftshift(ifft(ifftshift(in)));
gaussFilter = @(in,sigma) normalize(ift(ft(exp( (-(N/2-(1:N)+1).^2) / (2 * sigma ^ 2))).*ft(in)),in);

ramp=linspace(1,objdip,floor(objwidth/4)+1);
rampoffset=objwidth-floor(objwidth/4)*4;
ramps=[ramp(1:end-1),fliplr(ramp(2:end)),ones(1,rampoffset),ramp(2:end-1),fliplr(ramp(1:end))];
obj= ramps;%-.2*sin(linspace(0,3*pi,objwidth));
obj=objsum*obj./sum(obj);
objpad=[zeros(1,ceil((N-objwidth)/2)+objoffset),obj,zeros(1,floor((N-objwidth)/2)-objoffset)];
objpad=gaussFilter(objpad,2);

ref=ones(1,refwidth);
ref=refsum*ref./sum(ref);
refpad=[zeros(1,ceil((N-refwidth)/2)+refoffset),ref,zeros(1,floor((N-refwidth)/2)-refoffset)];
refCentered=pad2size(ref,size(objpad));
refCentered=gaussFilter(refCentered,3);
refpad=gaussFilter(refpad,3);

signal=abs(objpad+refpad);
scatter=(abs(ft(signal)).^2);

noise=@(rel) (noiselvl*rel*(2*rand(1,N)-1));
holo=(ift(scatter));
n=noise(max(holo));
holo=holo+n;

cutsize=2*objwidth;
auto=pad2size(holo(1+end/2-objwidth:end/2+objwidth),[1,N]);
cross=pad2size(holo(1+end/2-abs(refoffset-objoffset)-cutsize:end/2-abs(refoffset-objoffset)+cutsize),[1,N]);
refcut=pad2size(refCentered(1+end/2-cutsize:end/2+cutsize),[1,N]);
objcut=pad2size(signal(1+end/2+objoffset-objwidth:1+end/2+objoffset+objwidth),size(cross));
autoref=ift(abs(ft(refcut)).^2);

deconv=abs(wiener(cross,refcut,abs(ft(n)).^2));%./sqrt(numel(n)));
deconv1=abs(wiener(cross,refcut,abs(ft(n)).^2,ft(auto)));
deconv2=deconvwnr(cross,refcut,(ift(abs(ft(n)).^2)),auto);
deconv3=deconvwnr(cross,refcut,(ift(abs(ft(n)).^2)),ift(abs(ft(objcut)).^2));
directdeconv=(ift(ft(cross)./(1e-5+ft(refcut))));

mse=@(in)mean((objcut(:)-in(:)).^2);
deconvt=@(w)deconvwnr(cross,refcut,w);
options = optimset('TolFun',1e-18,'TolX',1e-8);
o=fminsearch(@(w)mse(deconvt(w)),1,options);
deconv4=deconvt(o);

% figure(2);clf;
% plabs=@(data)plot(abs(data));
% subplot(711); plabs(objcut)
% subplot(712); plabs(cross)
% subplot(713); plabs(deconv);title(strcat('nur n ',num2str(mse(deconv))));
% subplot(714); plabs(deconv1);title(strcat('wienerauto ',num2str(mse(deconv1))));
% subplot(715); plabs(deconv2);title(strcat('auto ',num2str(mse(deconv2))));
% subplot(716); plabs(deconv3);title(strcat('objcut ',num2str(mse(deconv3))));
% subplot(717); plabs(deconv4);title(strcat('optimis ',num2str(mse(deconv4))));


figure(1);clf
blue=[48,38,131]./255;
green=[0,150,64]./255;
red=[227,5,19]./255;
yellow=[249,178,51]./255;

subplot(321);hold on;axis off;
plot(abs(objpad),'Color',green);
plot(abs(refpad),'Color',blue);
legend({'Objekt','Referenz'},'Interpreter','latex');
legend boxoff
zeroline = refline([0 0]);zeroline.Color = 'black';

subplot(322);hold on;axis off;
plot(log10(abs(ft(objcut))),'Color',green);
plot(log10(abs(ft(refcut))),'Color',blue);
xlim([N/8,7*N/8]);
a=ylim;ylim([a(1),a(2)*1.5]);
legend({'$\log \left|\mathcal{F}\left(\textrm{Objekt}\right)\right|$','$\log \left|\mathcal{F}\left(\textrm{Referenz}\right)\right|$'},'Interpreter','latex');
legend boxoff
zeroline = refline([0 0]);zeroline.Color = 'black';

subplot(323);hold on;axis off;
plot(abs(holo),'Color',red);
legend({'$\mathcal{F}^{-1}\left({\left|\mathcal{F}\left(\textrm{Objekt}+\textrm{Referenz}\right)\right|}^2\right)$'},'Interpreter','latex');
legend boxoff
zeroline = refline([0 0]);zeroline.Color = 'black';

subplot(324);hold on;axis off;
plot(log10(abs(ft(cross))),'Color',red);
plot(log10(abs(ft(refcut))),'Color',blue);
plot(log10(abs(ft(objcut))),'Color',green);
legend({'$\log \left|\mathcal{F}\left(\textrm{Kreuzkorrelation}\right)\right|$','$\log \left|\mathcal{F}\left(\textrm{Referenz}\right)\right|$','$\log \left|\mathcal{F}\left(\textrm{Objekt}\right)\right|$'},'Interpreter','latex');
legend boxoff
xlim([N/8,7*N/8]);
a=ylim;ylim([a(1),a(2)*1.5]);
zeroline = refline([0 0]);zeroline.Color = 'black';

subplot(325);axis off; hold on;
plot(abs(directdeconv./max(directdeconv).*max(objcut)),'Color',red);
plot(abs(deconv4),'Color',yellow);
legend({'direkte Entfaltung','Wiener Entfaltung'},'Interpreter','latex');
legend boxoff
zeroline = refline([0 0]);zeroline.Color = 'black';

subplot(326);hold on;axis off;
plot(log10(abs(ft(objcut))),'Color',green);
plot(log10(abs(ft(cross)))-log10(abs(ft(refcut))),'Color',red)
plot(log10(abs(ft(deconv4))),'Color',yellow);
legend({'$\log \left|\mathcal{F}\left(\textrm{Objekt}\right)\right|$','$\log \left|\mathcal{F}\left(\textrm{direkte Entfaltung}\right)\right|$','$\log \left|\mathcal{F}\left(\textrm{Wiener Entfaltung}\right)\right|$'},'Interpreter','latex');
legend boxoff
xlim([N/8,7*N/8]);
a=ylim;ylim([a(1),a(2)*1.5]);
zeroline = refline([0 0]);zeroline.Color = 'black';

print('Tex\images\src\wiener.pdf','-dpdf','-r600');

