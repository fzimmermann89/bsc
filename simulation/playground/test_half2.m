% clear all;
g=gpuDevice();
reset(g);
wavelength=1;
dz=1/4;
dx=1/2
N=4*1024;
radius=200;
beta=1e-4;
delta=1e-4;
maxangle=30;
minangle=2;

gpu=true;
 ldx=[1,1/2,1/4,1/8];
% lbeta=10.^-(2:.5:5);
 for n=1:length(ldx)
%  beta=lbeta(n)
%     delta=beta;
dx=ldx(n)
    objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.radius=radius;
objects{1}.beta=beta;
objects{1}.delta=delta;
%%
tic;
exitM=(multislice(wavelength,objects,N,dx,dz,gpu));
% exitM=exitM-exitM(1);
% exitwave1t=(thibault(wavelength,objects,N,dx,dz,gpu));
toc;
%%
tic;
scatter=(abs(ft2(exitM)).^2*(dx^2));
[~,rM]=rprofil(scatter,N/2);
% clear scatter;
rM=gather(rM);
scatter=gather(scatter);
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

clear exitM
%%
x=asin(((0:N/2-1)*1/(N*dx))*wavelength)';
x2=asin(((0:N-1)*1/(2*N*dx))*wavelength)';
x4=asin(((0:2*N-1)*1/(4*N*dx))*wavelength)';
xHQ=asin(((0:(4*N)-1)*1/(8*N*dx))*wavelength)';
a=single(anglemap(N,dx,wavelength)*180/pi);
a2=single(anglemap(2*N,dx,wavelength)*180/pi);
a4=single(anglemap(4*N,dx,wavelength)*180/pi);

%%
tic
[~,rmie]=mie(wavelength,radius,beta,delta,x);
[~,rmie2]=mie(wavelength,radius,beta,delta,x2);
[~,rmie4]=mie(wavelength,radius,beta,delta,x4);
[~,rmieHQ]=mie(wavelength,radius,beta,delta,xHQ);

imie=mie_scatter(wavelength,radius,beta,delta,N,dx);
imie2=mie_scatter(wavelength,radius,beta,delta,2*N,dx);
imie4=mie_scatter(wavelength,radius,beta,delta,4*N,dx);
toc
%%
scatter=scatter./scatter(end/2+2,end/2+2);
scatterp=scatterp./scatterp(end/2+2,end/2+2);
scatterpp=scatterpp./scatterpp(end/2+2,end/2+2);

imie=imie./imie(end/2+2,end/2+2);
imie2=imie2./imie2(end/2+2,end/2+2);
imie4=imie4./imie4(end/2+2,end/2+2);



err=(scatter-imie)./imie;
err2=(scatterp-imie2)./imie2;
err4=(scatterpp-imie4)./imie4;

% quantile(abs(err(a>minangle&a<maxangle)),.90)
% quantile(abs(err2(a2>minangle&a2<maxangle)),.90)
% quantile(abs(err4(a4>minangle&a4<maxangle)),.90)
median(abs(err(a>minangle&a<maxangle)))
median(abs(err2(a2>minangle&a2<maxangle)))
median(abs(err4(a4>minangle&a4<maxangle)))
wait(g)
reset(g)
wait(g)
cs=icorrectoffsetspan(scatter,imie,a>minangle&a<maxangle);
wait(g)
reset(g)
wait(g)
cs2=icorrectoffsetspan(scatterp,imie2,a2>minangle&a2<maxangle);
wait(g)
reset(g)
wait(g)
cs4=icorrectoffsetspan(scatterpp,imie4,a4>minangle&a4<maxangle);

cerr=(cs-imie)./imie;
cerr2=(cs2-imie2)./imie2;
cerr4=(cs4-imie4)./imie4;

% quantile(abs(cerr(a>minangle&a<maxangle)),.90)
% quantile(abs(cerr2(a2>minangle&a2<maxangle)),.90)
% quantile(abs(cerr4(a4>minangle&a4<maxangle)),.90)
median(abs(cerr(a>minangle&a<maxangle)))
median(abs(cerr2(a2>minangle&a2<maxangle)))
median(abs(cerr4(a4>minangle&a4<maxangle)))


[~,rerr]=rprofil(err,N/2);
[~,crerr]=rprofil(cerr,N/2);

[~,rerr2]=rprofil(err2,N);
[~,crerr2]=rprofil(cerr2,N);

[~,rerr4]=rprofil(err4,2*N);
[~,crerr4]=rprofil(cerr4,2*N);

[~,r]=rprofil(scatter,N/2);
[~,r2]=rprofil(scatterp,N);
[~,r4]=rprofil(scatterpp,2*N);



[~,cr]=rprofil(cs,N/2);
[~,cr2]=rprofil(cs2,N);
[~,cr4]=rprofil(cs4,2*N);
[~,rm]=rprofil(imie4,2*N);

figure(10+n);

clf
subplot(2,1,1);
title(sprintf('direkt-Profile für dx=%.4f',ldx(n)));
hold on; 
% plot(x*180/pi,r,'x');
plot(x2*180/pi,r2,'x');
plot(x4*180/pi,r4,'x');
plot(x4*180/pi,rm);
legend({'rMultislice_{padded}','rMultislice_{doublepadded}','rMie'});%,'rMSFT','rMSFTp'});     
set(gca,'yscale','log');
xlim([0,45])
hold off;

subplot(2,1,2);
hold on;
% plot(x*180/pi,cr,'x');
plot(x2*180/pi,cr2,'x');
plot(x4*180/pi,cr4,'x');
plot(x4*180/pi,rm);
legend({'rMultislice_{padded}','rMultislice_{doublepadded}','rMie'});%,'rMSFT','rMSFTp'});     
set(gca,'yscale','log');
xlim([0,45])
hold off;


figure(20+n)

clf;
subplot(2,1,1)
title(sprintf('direkt-rel.fehler für dx=%.4f',ldx(n)));
hold on;
% plot(x*180/pi,rerr);
plot(x2*180/pi,rerr2);
plot(x4*180/pi,rerr4);
legend({'erp','erpp'})
axis([0,45,-1,1])
hold off;

subplot(2,1,2)
hold on;
% plot(x*180/pi,crerr);
plot(x2*180/pi,crerr2);
plot(x4*180/pi,crerr4);
legend({'cerp','cerpp'})
axis([0,45,-1,1])
hold off;
clear err err2 err4 exitM imie imie2 imie4 scatter scatterp scatterpp cerr cerr2 cerr4 cs cs2 cs4
end