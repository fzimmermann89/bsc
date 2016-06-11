% load('dens.mat')
clear all;
N=2*1024;
%all units are in nm
wavelength=1;
dx=wavelength;
dz=dx/2;
anglerange=asin(((-N/2:N/2-1)*1/(N*dx))*wavelength);



anglerangeRad=asin(linspace(0,N/2-1,N/2-1) *1/(N*dx)*wavelength);
% anglerangeRad=asin(linspace(0,1/(2*dx),N/2)*wavelength);
% anglerangeRad=anglerangeRad(1:end-1);

gpu=parallel.gpu.GPUDevice.isAvailable;

tmp=false; %just an addition var for debugging

maxXY=N/2*dx;


%% objects
objects=cell(1);
objects{1}=scatterObjects.sphere();
% 0.000177973081  1.34400088E-05
  objects{1}.beta=1e-3;%0.01;%1.78E-4;
  objects{1}.delta=1e-3;%0.01%0.01;%1.34E-5;
objects{1}.radius=100;%maxXY/32;
% objects{1}.positionX=maxXY/4;
% objects{1}.positionY=maxXY/4;
% objects{1}.positionZ=maxXY/4;
% objects{1}.rotationX=45/180*pi;
% objects{1}.rotationY=45/180*pi;
% objects{1}.rotationZ=45/180*pi;
% fprintf('pixel radius %f\n',objects{1}.radius/dx);

% objects{2}=scatterObjects.sphere();
% % objects{2}.delta=1e-5;
% objects{2}.delta=1e-3;
% objects{2}.radius=maxXY/24;%24
% objects{2}.positionX=-4*maxXY/8;
% objects{2}.positionY=-4*maxXY/8;
% objects{2}.positionZ=-maxXY/8;

% objects{1}=scatterObjects.matrix(dens);
%  objects{1}.beta=1e-6;

 %% ft projection
% tic
% proj=gather(abs(scatterObjects.projection(objects,N,dx,gpu)));
% streubildFTProj=abs(ft2(proj)).^2*(dx^2);
% 
% streubildFTProj_Disp=streubildFTProj;
% streubildFTProj_Disp(end/2+1,end/2+1)=0;
% streubildFTProj_Disp=log(streubildFTProj_Disp./max(streubildFTProj_Disp(:)));
% 
% figure(1);subplot(2,2,1);
% imagesc(anglerange,anglerange,streubildFTProj_Disp);
% axis square;caxis([-20,0]);colorbar;title('ft proj');
% toc
% 
% figure(5);
% imagesc(abs(proj));title('abs projection')
% 
% drawnow;

%% multislice
tic;
exitwaveMulti=gather(multislice(wavelength,objects,N,dx,dz,gpu,false));

figure(9);
% imagesc(abs(exitwave));title('abs exitwave multislice')
cimagesc(exitwaveMulti,'mutlislice');
axis square;colorbar;

%projection on detector is (currently) just ft of exitwave

streubildMulti=abs(ft2(exitwaveMulti)*(dx^2)).^2;

streubildMulti_Disp=streubildMulti;
streubildMulti_Disp(end/2+1,end/2+1)=0;
streubildMulti_Disp=streubildMulti_Disp./max(streubildMulti_Disp(:));
streubildMulti_Disp=log(streubildMulti_Disp);

figure(1);subplot(2,2,2);
% range=linspace(-N/2,N/2-1,N)*(1/(N*dx));
imagesc(anglerange,anglerange,streubildMulti_Disp);axis square;title('multislice');
caxis([-20,0]);
colorbar;
toc

drawnow;
% %% multislice filtered
% tic;
% exitwaveMultiF=gather(multislice(wavelength,objects,N,dx,gpu,true));
%
% figure(10);
% % imagesc(abs(exitwave));title('abs exitwave multislice')
% cimagesc(exitwaveMultiF,'mutlislice filt');
% axis square;colorbar;
%
% %projection on detector is (currently) just ft of exitwave
%
% streubildMultiF=abs(ft2(exitwaveMultiF)*(dx^2)).^2;
%
% streubildMultiF_Disp=streubildMultiF;
% streubildMultiF_Disp(end/2+1,end/2+1)=0;
% streubildMultiF_Disp=streubildMultiF_Disp./max(streubildMultiF_Disp(:));
% streubildMultiF_Disp=log(streubildMultiF_Disp);
%
% % figure(1);subplot(2,2,2);
% % range=linspace(-N/2,N/2-1,N)*(1/(N*dx));
% % imagesc(anglerange,anglerange,streubildMulti_Disp);axis square;title('multislice');
% % caxis([-20,0]);
% % colorbar;
%  toc
%
% drawnow;

%% thibault
tic;
exitwaveT=gather(thibault(wavelength,objects,N,dx,dz,gpu));

figure(10);
% imagesc(abs(exitwaveT));title('abs exitwave thibault')
cimagesc(exitwaveT,'thibault');
axis square;colorbar;

streubildT=abs(ft2(exitwaveT)*(dx^2)).^2;

streubildT_Disp=streubildT;
streubildT_Disp(end/2+1,end/2+1)=0;
streubildT_Disp=streubildT_Disp./max(streubildT_Disp(:));
streubildT_Disp=log(streubildT_Disp);

figure(1);subplot(2,2,4);
imagesc(anglerange,anglerange,streubildT_Disp);title('thibault')
axis square;caxis([-20,0]);colorbar;
toc

drawnow;

%% msft 
tic
msft=gather(msft2(wavelength,objects,N,dx,dz,gpu));

streubildMSFT=(abs(msft).^2);
streubildMSFT_Disp=streubildMSFT;
streubildMSFT_Disp(end/2+1,end/2+1)=0;
streubildMSFT_Disp=log(streubildMSFT_Disp./max(streubildMSFT_Disp(:)));

figure(1);subplot(2,2,3);
imagesc(anglerange,anglerange,streubildMSFT_Disp);title('msft');
axis square;colorbar;caxis([-20,0]);
toc

drawnow;

%% mie
tic
[angleMie,streubildMie]=mie(wavelength,objects{1}.radius,objects{1}.beta,objects{1}.delta,10000); %radius-dx/8
% [S,~,angleMie]=calcmie(objects{1}.radius,1-objects{1}.delta+1i*objects{1}.beta,1,wavelength,1000);
% streubildMie=(squeeze((S(1,1,:)+ S(2,2,:))/2));
% streubildMie=streubildMie./max(streubildMie(:));
% angleMie=angleMie./180*pi;
toc

%% rayleigh
tic
[angleRayleigh,streubildRayleigh]=rayleigh(objects{1}.radius,wavelength,100000);
toc
%% plot radialprofile
tic
figure(2);
subplot(1,1,1)
% semilogy(anglerangeRad, rscan(normalize( streubildFTProj) ,'dispflag',0,'xavg',N/2+1,'yavg',N/2+1));hold on;
semilogy(anglerangeRad, rscan(normalize( streubildMulti)  ,'dispflag',0,'xavg',N/2+1,'yavg',N/2+1));hold on;
semilogy(anglerangeRad, rscan(normalize( streubildMSFT)   ,'dispflag',0,'xavg',N/2+1,'yavg',N/2+1));hold on;
semilogy(anglerangeRad, rscan(normalize( streubildT)      ,'dispflag',0,'xavg',N/2+1,'yavg',N/2+1));hold on;
semilogy(angleMie,      streubildMie        ./max(streubildMie(:))                                );hold off;
% semilogy(angleRayleigh, streubildRayleigh   ./max(streubildRayleigh(:))                           );hold off;
axis([0 pi/2 1E-10 1])
legend('multi','msft','thibault','mie');
% legend('multi','thibault','mie');

title('Radialprofile');
toc
%% plot radialprofile2 %TODO
tic
precision=0;
limit=N/2;
[rMulti,pMulti,eMulti]=rprofil(normalize(gpuArray(streubildMulti)),limit,precision); angleMulti=gather(asin(rMulti/(N*dx)*wavelength));
[rMSFT,pMSFT,eMSFT]=rprofil(normalize(gpuArray(streubildMSFT)),limit,precision); angleMSFT=asin(rMSFT/(N*dx)*wavelength);
[rT,pT,eT]=rprofil(normalize(gpuArray(streubildT)),limit,precision); angleT=asin(rT/(N*dx)*wavelength);
[angleMie,streubildMie]=mie(wavelength,objects{1}.radius,objects{1}.beta,objects{1}.delta,angleT);
pMie=(streubildMie        ./max(streubildMie(:)));
figure(123)
subplot(1,1,1)
semilogy(angleMulti,pMulti,'x');hold on
% errbar(angleMulti,pMulti,[0;diff(angleMulti)],[diff(angleMulti);0],'horiz','r--');hold on
% errbar(angleMulti,pMulti,eMulti,'r');hold on

semilogy(angleMSFT,pMSFT,'x');hold on
% errbar(angleMSFT,pMSFT,[0;diff(angleMSFT)],[diff(angleMSFT);0],'horiz','g:');hold on
% errbar(angleMSFT,pMSFT,eMSFT,'g');hold on

semilogy(angleT,pT,'x');hold on
% errbar(angleT,pT,[0;diff(angleT)],[diff(angleT);0],'horiz','b-.');hold on
% errbar(angleT,pT,eT,'b');hold on


plot(angleMie,      pMie,'kx'                               );hold off;
set(gca,'YScale','log');
% axis([0 .1 1E-10 1])
legend('multi','msft','thibault','mie');
toc

%% plot differences
tic

[xMulti,absMulti,relMulti]=difference(gpuArray(angleMulti),pMulti,gpuArray(angleMie),pMie);
[xMSFT,absMSFT,relMSFT]=difference(gpuArray(angleMSFT),pMSFT,gpuArray(angleMie),pMie);
[xT,absT,relT]=difference(gpuArray(angleT),pT,gpuArray(angleMie),pMie);

xerrors=gather([xMulti,xMSFT,xT]);
yerrors=gather([relMulti,relMSFT,relT]);
yerrors=(yerrors);
syerrors=arrayfun(@(n)smooth(xerrors(:,n),yerrors(:,n),0.001,'rloess'),1:3,'UniformOutput', false);
figure(456);
subplot(1,1,1);
for n=1:length(syerrors)
    plot(xerrors(:,n),syerrors{n});hold on;
end
hold off;
% axis([0,0.3,1e-4,1])
legend('multi','msft','thibault');

figure(789);
subplot(1,1,1);
for n=1:length(syerrors)
    plot(xerrors(:,n),yerrors(:,n));hold on;
end
hold off;
% axis([0,0.3,1e-4,1])
% semilogy(xMulti,smooth(xMulti,abs(relMulti)));hold on
% semilogy(xMSFT,smooth(xMSFT,abs(relMSFT)));hold on
% semilogy(xT,smooth(xT,abs(relT)));hold off

% axis([0,0.5,-1,1])

% set(gca,'YScale','log');
legend('multi','msft','thibault');

toc
% 
% tic
% figure(2);
% subplot(1,1,1)
% n1=(normalize( streubildMulti));
% n2=normalize(streubildT);
% semilogy(anglerangeRad,n1(end/2+1,end/2+1:end-1));hold on;
% semilogy(anglerangeRad,n2(end/2+1,end/2+2:end));hold on;
% semilogy(angleMie,      streubildMie        ./max(streubildMie(:))                                );hold on;
% axis([0 pi/2 1E-10 1])
% legend('multi','t','mie','rayleigh');
% title('Radialprofile');
% toc
fprintf('\n fertig \n');