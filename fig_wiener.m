clear all
addpath('helper');
addpath('reconstruction');
N=1024;
objwidth=80;
objoffset=-150;
objdip=0.5;
refwidth=41;
refoffset=-objoffset;
sigma = 1;
noiselvl=1e-3;

normalize=@(in,ref)in./sum(in).*sum(ref);
ft =@(in) fftshift( fft(ifftshift(in)));
ift=@(in) fftshift(ifft(ifftshift(in)));
gaussFilter = @(in,sigma) normalize(ift(ft(exp( (-(N/2-(1:N)+1).^2) / (2 * sigma ^ 2))).*ft(in)),in);

ramp=linspace(1,objdip,floor(objwidth/4)+1);
rampoffset=objwidth-floor(objwidth/4)*4;
ramps=[ramp(1:end-1),fliplr(ramp(2:end)),ones(1,rampoffset),ramp(2:end-1),fliplr(ramp(1:end))];
obj= ramps;%-.2*sin(linspace(0,3*pi,objwidth));
% obj=obj./sum(obj);
objpad=[zeros(1,ceil((N-objwidth)/2)+objoffset),obj,zeros(1,floor((N-objwidth)/2)-objoffset)];

ref=ones(1,refwidth);
% ref=ref./sum(ref);
refpad=[zeros(1,ceil((N-refwidth)/2)+refoffset),ref,zeros(1,floor((N-refwidth)/2)-refoffset)];
refCentered=pad2size(ref,size(objpad));
refCentered=gaussFilter(refCentered,5);
refpad=gaussFilter(refpad,5);

signal=abs(objpad+refpad);
scatter=(abs(ft(signal)).^2);

noise=@(rel) (noiselvl*rel*(2*rand(1,N)-1));
% scale=1e4./max(scatter);
% scatter=scatter*scale;
% n=noise(max(scatter));
% n=0.5*(1-2*rand(1,N)).*sqrt(scatter);

% n=round(poissrnd(scatter))-scatter;
%  scatter=scatter+n;
% scatter=scatter/scale;
% n=n/scale;
%  n=(ift(n));

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


mse=@(in)mean((objcut(:)-in(:)).^2);

  deconvt=@(w)deconvwnr(cross,refcut,w);
  options = optimset('TolFun',1e-18,'TolX',1e-8);

 o=fminsearch(@(w)mse(deconvt(w)),1,options);
 deconv4=deconvt(o);

figure(2);clf;
plabs=@(data)plot(abs(data));
subplot(711); plabs(objcut)
subplot(712); plabs(cross)
subplot(713); plabs(deconv);title(strcat('nur n ',num2str(mse(deconv))));
subplot(714); plabs(deconv1);title(strcat('wienerauto ',num2str(mse(deconv1))));
subplot(715); plabs(deconv2);title(strcat('auto ',num2str(mse(deconv2))));
subplot(716); plabs(deconv3);title(strcat('objcut ',num2str(mse(deconv3))));
subplot(717); plabs(deconv4);title(strcat('optimis ',num2str(mse(deconv4))));


figure(3);clf
subplot(311);plabs(signal);axis off;
subplot(312);plabs(holo);axis off;
subplot(313); plabs(deconv4);axis off;
print('Tex\images\src\wiener.pdf','-dpdf','-r600');
%  axis([size(deconv,2)/2-100,size(deconv,2)/2+100,0,0.03])
% plot(abs(signal))
% legend({'sig','holo','deconv'})

    