tic
N=512;
lambda=1;

dx=lambda/2;
dz=lambda*64;
maxz=N*dx/2; %/2 wegen padding
m=maxz/dz;
k=2*pi/lambda;

maxX=dx*N/2;
padX=dx*N;
fprintf('maxX=%f, padX=%f\n',maxX,padX');
fprintf('schrittweite=%f, gesammtz=%f\n',maxz/m,maxz);

%super gaussian window
[nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
nsq = nx.^2 + ny.^2;
wt = 0.25*N;
w = gpuArray(exp(-nsq.^8/wt^16));

%kreisförmiger input
% radius=N/8;
% input=(nx.^2+ny.^2)<radius^2;

% % punktförmiger input
% input=zeros(N);
% input(N/2+1,N/2+1)=1;

%gleichmäßgier input
input=ones(N,N);

[X,Y]=meshgrid(linspace(-N/2,N/2-1,N)*dx);
[U,V]=meshgrid(linspace(-N/2,N/2-1,N)/(N*dx));

% p=exp(-1i*k*(X.^2+Y.^2)/(2*dz));

%Propagation durch Faltung mit RS/FK-Term (definiert im realraum)
r=sqrt(maxz^2+X.^2+Y.^2);
% p=-1/(2*pi)*(1i*k-1./r).*exp(1i*k.*r)./r.^2*maxz; 
p=exp(-1i*k*(X.^2+Y.^2)/(2*maxz)); 
p=p.*w;
Fp=fftshift(fft2(fftshift(p)))*(dx^2);
p=p./max(real(p(:)));

out_p=fftshift(ifft2(fftshift(Fp.*fftshift(fft2(fftshift(input))))));

%propagation um ein m-tel der gesamtstrecke
r_short=sqrt((maxz/m)^2+X.^2+Y.^2);
% p_short=-1/(2*pi)*(1i*k-1./r_short).*exp(1i*k.*r_short)./r_short.^2*(maxz/m);%RS
p_short=exp(-1i*k*(X.^2+Y.^2)/(2*(maxz/m))).*w; %FK
Fp_short=fftshift(fft2(fftshift(p_short)))*(dx^2);

%wiederholte anwengung führt zur gesamt propagation
  %propagator
    p_repeat=gpuArray(p_short);
    for nfft=1:m-1
        Fp_repeat=fftshift(fft2(fftshift(p_repeat)))*dx^2;
        Fp_repeat=Fp_repeat.*Fp_short;
        p_repeat=fftshift(ifft2(fftshift(Fp_repeat))).*1/dx^2.*w;
    end
    Fp_repeat=gather(fftshift(fft2(fftshift(p_repeat)))*(dx^2));
     p_repeat=gather(p_repeat./max(real(p_repeat(:))));
  %output
    out_p_repeat=gpuArray(input);
    Fp_short=gpuArray(Fp_short);
    for n=1:m
        %faltung mit p_short
        out_p_repeat=fftshift(ifft2(fftshift(Fp_short.*fftshift(fft2(fftshift(out_p_repeat))))));
        out_p_repeat=out_p_repeat.*w;
    end
    Fp_short=gather(Fp_short);
    out_p_repeat=gather(out_p_repeat);
%Anzeigen der Propagatoren
figure(2142354);
subplot(3,2,1); imagesc(real(p)); axis square; colorbar;title('Propagator Real gesammt')
subplot(3,2,2); imagesc(real(Fp)); axis square; colorbar;title('Propagator Fourier gesammt')
subplot(3,2,3); imagesc(real(p_repeat)); axis square; colorbar;title('Propagator Real alle Schritte')
subplot(3,2,4); imagesc(real(Fp_repeat)); axis square; colorbar;title('Propagator Fourier alle Schritte')
subplot(3,2,5); imagesc(real(p_short)); axis square; colorbar;title('Propagator Real einzelschritt');caxis([-1,1]);
subplot(3,2,6); imagesc(real(Fp_short)); axis square; colorbar;title('Propagator Fourier einzelschritt')

colormap jet;

%anzeigen der bilder
figure(1);
subplot(2,2,1);imagesc(input);axis square;title('input');
subplot(2,2,2);plot(w(N/2,:));axis square;title('window');
subplot(2,2,3);imagesc(real(out_p));axis square;title('out p gesammt');
subplot(2,2,4);imagesc(real(out_p_repeat));axis square;title('out p schrittweise');


toc
% Fp_repeat=Fp_short.^m;
% p_repeat=fftshift(ifft2(fftshift(Fp_repeat)))./dx^2;
% k*(2*max(X(:)))/(2*dz)

% P=(exp(1i*pi*lambda*dz*(U.^2+V.^2)));

% P=exp(1i*dz*2*pi*sqrt(lambda^-2-U.^2-V.^2));
%  Pmask=lambda^-2>(U.^2+V.^2);
%    P=P.*Pmask;
%    figure(1)
%    imagesc(Pmask);
% P=imgaussfilt(real(P),2)+1i*imgaussfilt(imag(P),2);

%     w=padarray(tukeywin(1*N/2,0.2)*tukeywin(1*N/2,.2)',[N/4,N/4]);
%      P=P.*w;
%      p=p.*w;
%  P=fftshift(ifft2(fftshift(w.*fftshift(fft2(fftshift(P))))));

% iFP=fftshift(ifft2(fftshift(P)));
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
% Fp=fftshift(fft2(fftshift(p)));
% 
% % P=(exp(1i*pi*lambda*dz*500*(U.^2+V.^2)));
% P=P.^500;
% 
% iFP=fftshift(ifft2(fftshift(P)));
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