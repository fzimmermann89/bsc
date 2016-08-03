clear all;
g=gpuDevice();
reset(g);
dx=1/4;
wavelength=1;
dz=1/4;
N=2*1024;
radius=20;
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
exitM=(multislice(wavelength,objects,N,dx,dz,gpu));
exitM=exitM-exitM(1);
% exitwave1t=(thibault(wavelength,objects,N,dx,dz,gpu));
toc;
%%
tic;
scatter1=(abs(ft2(exitM)).^2*(dx^2));
[~,rM]=rprofil(scatter1,N/2);
clear scatter1;
rM=gather(rM);
exitM=gather(exitM);
toc;

%%
tic
exitMp=pad2size((exitM),2*N,exitM(1));
scatterp=(abs(ft2(exitMp)).^2*(dx^2));
[~,rMp]=rprofil(scatterp,N);
clear exitMp
toc

tic
exitMpp=pad2size((exitM),4*N,exitM(1));
scatterpp=(abs(ft2(exitMpp)).^2*(dx^2));
[~,rMpp]=rprofil(scatterpp,2*N);
clear exitMpp
toc



% %%half
% %%
% tic;
% exitMh=(multislice(wavelength,objects,N/2,dx,dz,gpu));
% exitMh=exitMh-exitMh(1);
% % exitwave1t=(thibault(wavelength,objects,N,dx,dz,gpu));
% toc;
% %%
% tic;
% scatter1h=(abs(ft2(exitMh)).^2*(dx^2));
% [~,rMh]=rprofil(scatter1h,N/4);
% scatter1h=gather(scatter1h);
% rMh=gather(rMh);
% exitMh=gather(exitMh);
% toc;
% reset(g);
% %%
% tic
% exitMhp=pad2size((exitMh),N,exitMh(1));
% scatterhp=(abs(ft2(exitMhp)).^2*(dx^2));
% exitMhp=gather(exitMhp);
% [~,rMhp]=rprofil(scatterhp,N/2);
% scatterhp=gather(scatterhp);
% rMhp=gather(rMhp);
% toc
% %%
% tic
% exitMhpp=pad2size((exitMh),4*N,exitMh(1));
% scatterhpp=(abs(ft2(exitMhpp)).^2*(dx^2));
% exitMhpp=gather(exitMhpp);
% [~,rMhpp]=rprofil(scatterhpp,2*N);
% scatterhpp=gather(scatterhpp);
% rMhpp=gather(rMhpp);
% toc
%%
% tic
%        exitMSFT=ift2(msft2(wavelength,objects,N,dx,dz,gpu)/(dx^2));
%        exitMSFT=exitMSFT-exitMSFT(1);
%        scatterMSFT=(abs(ft2(exitMSFT)).^2*(dx^2));
%        exitMSFT=gather(exitMSFT);
%        
%        [~,rMSFT]=rprofil(scatterMSFT,N/2);
%        scatterMSFT=gather(scatterMSFT);
%        
%        exitMSFTp=pad2size((exitMSFT),2*N,exitMSFT(1));
%        scatterMSFTp=(abs(ft2(exitMSFTp)).^2*(dx^2));
% 
%        [~,rMSFTp]=rprofil(scatterMSFTp,N);
% toc
%%
xh=asin(((0:N/4-1)*1/(N/2*dx))*wavelength)';
x=asin(((0:N/2-1)*1/(N*dx))*wavelength)';
x2=asin(((0:N-1)*1/(2*N*dx))*wavelength)';


x4=asin(((0:2*N-1)*1/(4*N*dx))*wavelength)';
xHQ=asin(((0:(4*N)-1)*1/(8*N*dx))*wavelength)';
% x4=asin(((0:2*N-1)*1/(4*N*dx))*wavelength)';
% x8=asin(((0:4*N-1)*1/(8*N*dx))*wavelength)';

%%
[~,rmieh]=mie(wavelength,radius,beta,delta,xh);
[~,rmie]=mie(wavelength,radius,beta,delta,x);
[~,rmie2]=mie(wavelength,radius,beta,delta,x2);
[~,rmie4]=mie(wavelength,radius,beta,delta,x4);
[~,rmieHQ]=mie(wavelength,radius,beta,delta,xHQ);

% ende=1000;
% start=800;
% spanm=max(rmie(start:ende))-min(rmie(start:ende))
%             offsetm=mean(rmie(start:ende))
%             offsetr=mean(r2(start:ende))
%             spanr=max(r2(start:ende))-min(r2(start:ende))
%             rmie=((rmie-offsetm)*(spanr/spanm))+offsetr;
% x2(start)
% x2(ende)


% rMh=rMh./max(rMh(2:end/2));
% rMhp=rMhp./max(rMhp(2:end/2));
% rMhpp=rMhpp./max(rMhpp(2:end/2));
rM=rM./max(rM(2:end/2));
rMp=rMp./max(rMp(2:end/2));
rMpp=rMpp./max(rMpp(2:end/2));
rmieh=rmieh./max(rmieh(2:end/2));
rmie=rmie./max(rmie(2:end/2));
rmie2=rmie2./max(rmie2(2:end/2));
rmie4=rmie4./max(rmie4(2:end/2));
rmieHQ=rmieHQ./max(rmieHQ(2:end/2));
% rMSFT=rMSFT./max(rMSFT(2:end/2));
% rMSFTp=rMSFTp./max(rMSFTp(2:end/2));
maxangle=30;
minangle=2;
% crMh=correctoffsetspan(rMh,rmieh,sum(xh*180/pi<20));
% crMhp=correctoffsetspan(rMhp,rmie,sum(x*180/pi<20));
% crM=correctoffsetspan(rM,rmie,sum(x*180/pi<20));
% crMhpp=correctoffsetspan(rMhpp,rmie4,sum(x4*180/pi<20));
crM=correctoffsetspan(rM,rmie,(x*180/pi>minangle&x*180/pi<maxangle));
crMp=correctoffsetspan(rMp,rmie2,(x2*180/pi>minangle&x2*180/pi<maxangle));
crMpp=correctoffsetspan(rMpp,rmie4,(x4*180/pi>minangle&x4*180/pi<maxangle));
figure(1);
clf
subplot(2,1,1);
hold on; 
% plot(xh,crMh,'x');

% plot(x,rMhp,'x');
% plot(x*180/pi,rM,'x');
plot(x2*180/pi,rMp,'x');
plot(x4*180/pi,rMpp,'x');
% plot(x2,crMp,'x');
% plot(x4,rMhpp,'x');
% plot(x,rmie);
plot(xHQ*180/pi,rmieHQ);
% plot(x,rMSFT);
% plot(x2,rMSFTp);
legend({'rMultislice_{padded}','rMultislice_{doublepadded}','rMie'});%,'rMSFT','rMSFTp'});     
set(gca,'yscale','log');
xlim([0,45])
hold off;

subplot(2,1,2);
hold on;
% plot(x*180/pi,crM,'x');
plot(x2*180/pi,crMp,'x');
plot(x4*180/pi,crMpp,'x');

% plot(xh,crMh,'x');
% 
% plot(x,crMhp,'x');
% plot(x,crM,'x');
% % plot(x2,crMp,'x');
% plot(x4,crMhpp,'x');
% % plot(x,rmie);
 plot(xHQ*180/pi,rmieHQ);
% plot(x,rMSFT);
% plot(x2,rMSFTp);
legend({'rMultislice_{padded}','rMultislice_{doublepadded}','rMie'});%,'rMSFT','rMSFTp'});     

% legend({'rMultislice_{half}','rMultislice_{half+padded}','rMultislice','rMultislice_{half+doublepadded}','rMie'});%,'rMSFT','rMSFTp'});     
set(gca,'yscale','log');
xlim([0,45])
hold off;




% erM=(rM-rmie)./rmie;
% erMhp=(rMhp-rmie)./rmie;
% erMhpp=(rMhpp-rmie4)./rmie4;
% erMh=(rMh-rmieh)./rmieh;

erM=(rM-rmie)./rmie;
erMp=(rMp-rmie2)./rmie2;
erMpp=(rMpp-rmie4)./rmie4;
figure(2)
clf;
subplot(2,1,1)
hold on;
% plot(x*180/pi,erM);
plot(x2*180/pi,erMp);
plot(x4*180/pi,erMpp);
disp('err')
median(abs(erM(x*180/pi>minangle&x*180/pi<maxangle)))
median(abs(erMp(x2*180/pi>minangle&x2*180/pi<maxangle)))
median(abs(erMpp(x4*180/pi>minangle&x4*180/pi<maxangle)))
legend({'erMp','erMpp'})
axis([0,45,-1,1])


% cerM=(crM-rmie)./rmie;
% cerMhp=(crMhp-rmie)./rmie;
% cerMhpp=(crMhpp-rmie4)./rmie4;
% cerMh=(crMh-rmieh)./rmieh;
cerM=(crM-rmie)./rmie;
cerMp=(crMp-rmie2)./rmie2;
cerMpp=(crMpp-rmie4)./rmie4;
hold off;
subplot(2,1,2)
hold on;
% plot(x*180/pi,cerM);
% plot(x*180/pi,cerMhp);
% plot(x4*180/pi,cerMhpp);
% plot(xh*180/pi,cerMh);
% plot(x*180/pi,cerM);
plot(x2*180/pi,cerMp);
plot(x4*180/pi,cerMpp);

axis([0,45,-1,1])
disp('c')
median(abs(cerM(x*180/pi>minangle&x*180/pi<maxangle)))
median(abs(cerMp(x2*180/pi>minangle&x2*180/pi<maxangle)))
median(abs(cerMpp(x4*180/pi>minangle&x4*180/pi<maxangle)))
% legend({'erM','erMhp','erMhpp','erMh'})


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