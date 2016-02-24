%http://www.tnw.tudelft.nl/fileadmin/Faculteit/TNW/Over_de_faculteit/Afdelingen/Imaging_Science_and_Technology/Research/Research_Groups/Optics/Publications/Per_Year/doc/2005.029.pdf

tic
N=256;
lambda=1;

dx=lambda;

maxz=N*dx; %/2 wegen padding
dz=lambda/2;
m=maxz/dz;
% m=512;
% dz=maxz/m;
k=2*pi/lambda;

maxX=dx*N/2;
padX=dx*N;
fprintf('maxX=%f, padX=%f\n',maxX,padX');
fprintf('schrittweite=%f, gesammtz=%f\n',maxz/m,maxz);

%super gaussian window
[nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
nsq = nx.^2 + ny.^2;
wt = 0.1*N;
w = exp(-nsq.^8/wt^16);

% %circular window
% [nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
% radius=N/2*(6/16)+5;
% w=nx.^2+ny.^2<radius^2;
% % w=imgaussfilt(double(w),5);


% kreisförmiger input
[nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
radius=N/2;
rinput=(nx.^2+ny.^2)>radius^2;

% % punktförmiger input
% rinput=zeros(N);
% rinput(N/2+1,N/2+1)=1;

% %gleichmäßgier input
% rinput=ones(N,N);

finput=ft2(((rinput)))*(dx^2);

[X,Y]=meshgrid(linspace(-N/2,N/2-1,N)*dx);
[U,V]=meshgrid(linspace(-N/2,N/2-1,N)/(N*dx));

%Propagation durch Faltung mit RS-Term (definiert im Fourierraum)
% =PWP =AS-RS
evanescence_mask=lambda^-2>(U.^2+V.^2);

P=exp(1i*maxz*2*pi*sqrt(lambda^-2-U.^2-V.^2)).*evanescence_mask; %RS
% P=exp((U.^2+V.^2)*(-1i*pi*lambda*maxz)).*w; %FK
rP=ift2(((P)))/(dx^2);

fout_P=finput.*P;
rout_P=ift2(((fout_P)))/(dx^2);


%propagation um ein m-tel der gesamtstrecke
P_short=exp(1i*(maxz/m)*2*pi*sqrt(lambda^-2-U.^2-V.^2)); %RS
% P_short=exp((U.^2+V.^2)*(-1i*pi*lambda*(maxz/m))); %FK
rP_short=ift2(((P_short)))/(dx^2);

%wiederholte anwengung führt zur gesamt propagation
  %propagator
% dx=gpuArray(dx);
 rP_repeat=(rP_short);
for n=1:m-1
       P_repeat=ft2(((rP_repeat)))*(dx^2);
       P_repeat=P_repeat.*P_short;
       rP_repeat=ift2(((P_repeat)))/(dx^2).*w;
 
end
rP_repeat=gather(rP_repeat);
P_repeat=gather(P_repeat);

%output
rout_P_repeat=rinput;
for n=1:m
    fout_P_repeat=ft2(((rout_P_repeat)))*(dx^2);
    fout_P_repeat=fout_P_repeat.*P_short;
    rout_P_repeat=ift2(((fout_P_repeat)))/(dx^2);
end
rout_P_repeat=gather(rout_P_repeat);
fout_P_repeat=gather(fout_P_repeat);
dx=gather(dx);
%     p_repeat=gpuArray(p_short);
%     for nfft=1:m-1
%         Fp_repeat=ft2(((p_repeat)))*dx^2;
%         Fp_repeat=Fp_repeat.*Fp_short;
%         p_repeat=ift2(((Fp_repeat))).*1/dx^2.*w;
%     end
%     Fp_repeat=gather(ft2(((p_repeat)))*(dx^2));
%      p_repeat=gather(p_repeat./max(real(p_repeat(:))));
%   %output
%     out_p_repeat=gpuArray(input);
%     Fp_short=gpuArray(Fp_short);
%     for n=1:m
%         %faltung mit p_short
%         out_p_repeat=ift2(((Fp_short.*ft2(((out_p_repeat))))));
%         out_p_repeat=out_p_repeat.*w;
%     end
%     Fp_short=gather(Fp_short);
%     out_p_repeat=gather(out_p_repeat);
%Anzeigen der Propagatoren
figure(3);
subplot(3,2,1); imagesc(real(rP)); axis square; colorbar;title('Propagator Real gesammt')
subplot(3,2,2); imagesc(real(P)); axis square; colorbar;title('Propagator Fourier gesammt')
subplot(3,2,3); imagesc(real(rP_repeat)); axis square; colorbar;title('Propagator Real alle Schritte')
subplot(3,2,4); imagesc(real(P_repeat)); axis square; colorbar;title('Propagator Fourier alle Schritte')
subplot(3,2,5); imagesc(real(rP_short)); axis square; colorbar;title('Propagator Real einzelschritt');caxis([-1,1]);
subplot(3,2,6); imagesc(real(P_short)); axis square; colorbar;title('Propagator Fourier einzelschritt')

colormap jet;


%anzeigen der bilder
figure(4);
subplot(3,2,1);imagesc(rinput);axis square;title('input real');
subplot(3,2,2);imagesc(real(finput));axis square;title('input fourier');
subplot(3,2,3);plot(w(N/2,:));axis square;title('window at center');
subplot(3,2,4);imagesc(w);axis square;title('window');
subplot(3,2,5);imagesc(real(rout_P));axis square;title('real out P gesammt');
subplot(3,2,6);imagesc(real(rout_P_repeat));axis square;title('real out P schrittweise');

figure(2)
imagesc(real(rout_P_repeat));axis square;title('real out P schrittweise');

toc
% Fp_repeat=Fp_short.^m;
% p_repeat=ift2(((Fp_repeat)))./dx^2;
% k*(2*max(X(:)))/(2*dz)




%  Pmask=lambda^-2>(U.^2+V.^2);
%    P=P.*Pmask;
%    figure(1)
%    imagesc(Pmask);
% P=imgaussfilt(real(P),2)+1i*imgaussfilt(imag(P),2);

%     w=padarray(tukeywin(1*N/2,0.2)*tukeywin(1*N/2,.2)',[N/4,N/4]);
%      P=P.*w;
%      p=p.*w;
%  P=ift2(((w.*ft2(((P))))));

% iFP=ift2(((P)));
% iFP=iFP./abs(max(iFP(:)));

% pi*lambda*dz*(2*max(U(:)))


%
%
% figure(2142355);
% subplot(221); imagesc(angle(p)); axis square; colorbar;
% subplot(222); imagesc(angle(Fp)); axis square; colorbar;
% subplot(223); imagesc(angle(iFP)); axis square; colorbar;
% subplot(224); imagesc(angle(P)); axis square; colorbar;
% colormap hsv;

% figure(2142355);
% subplot(221); compleximagesc((p)); axis square;
% subplot(222); compleximagesc((Fp)); axis square;
% subplot(223); compleximagesc((iFP)); axis square;
% subplot(224); compleximagesc((P)); axis square;
% % colormap jet;


% figure(2142355);
% subplot(221); imagesc(angle(p)); axis square; colorbar;
% subplot(222); imagesc(angle(Fp)); axis square; colorbar;
% subplot(223); imagesc(angle(iFP)); axis square; colorbar;
% subplot(224); imagesc(angle(P)); axis square; colorbar;
% colormap hsv;


%  p=exp(-1i*k*(X.^2+Y.^2)/(2*dz*500));
% Fp=ft2(((p)));
% 
% % P=(exp(1i*pi*lambda*dz*500*(U.^2+V.^2)));
% P=P.^500;
% 
% iFP=ift2(((P)));
% 
% % iFP=iFP./abs(max(iFP(:)));
% 
% figure(2142356);
% subplot(221); compleximagesc((p)); axis square;
% subplot(222); compleximagesc((Fp)); axis square;
% subplot(223); compleximagesc((iFP)); axis square;
% subplot(224); compleximagesc((P)); axis square;
% figure(2142357);
% subplot(221); imagesc(real(p)); axis square;
% subplot(222); imagesc(real(Fp)); axis square;
% subplot(223); imagesc(real(iFP)); axis square;
% subplot(224); imagesc(real(P)); axis square;
% % colormap jet;