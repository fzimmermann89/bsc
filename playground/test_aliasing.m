N=32;
    nx=linspace(-N/2,N/2-1,N);
    nsq = nx.^2;
    wt = 0.25*N;%0.25*N;
    w = exp(-nsq.^8/wt^16);
%
% rinput1=zeros(1,N);
% rinput1(N/4+1:3*N/4+1)=1;
% finput1=fftshift(fft(fftshift(rinput1)));
% foutput1=finput1.*w;
% routput1=fftshift(ifft(fftshift(foutput1)));
rinput1=ones
figure(1)
subplot(2,2,1);plot(rinput1);title('rinput1');
subplot(2,2,2);plot(abs(finput1));title('finput1');
subplot(2,2,3);plot(abs(routput1));title('routput1');
subplot(2,2,4);plot(abs(foutput1));title('foutput1');

finput2=ones(1,N);
rinput2=fftshift(ifft(fftshift(finput2)));
foutput2=finput2.*w;
routput2=fftshift(ifft(fftshift(foutput2)));

figure(2)
subplot(2,2,1);plot(rinput2);title('rinput2');
subplot(2,2,2);plot(abs(finput2));title('finput2');
subplot(2,2,3);plot(abs(routput2));title('routput2');
subplot(2,2,4);plot(abs(foutput2));title('foutput2');


fconvf_input=conv(finput1,finput2,'same');
rconvf_input=fftshift(ifft(fftshift(fconvf_input)));

rmulr_input=rinput1.*rinput2;
fmulr_input=fftshift(fft(fftshift(rmulr_input)));

fconvf_output=conv(foutput1,foutput2,'same');
rconvf_output=fftshift(ifft(fftshift(fconvf_output)));

rmulr_output=routput1.*routput2;
fmulr_output=fftshift(ifft(fftshift(rmulr_output)));

figure(3);

subplot(2,2,1);plot(abs(rconvf_input));title('rconvf input');
subplot(2,2,2);plot(abs(fconvf_input));title('fconvf input');
subplot(2,2,3);plot(abs(rmulr_input));title('rmulr input');
subplot(2,2,4);plot(abs(fmulr_input));title('fmulr input');

figure(4);

subplot(2,2,1);plot(abs(rconvf_output));title('rconvf output');
subplot(2,2,2);plot(abs(fconvf_output));title('fconvf output');
subplot(2,2,3);plot(abs(rmulr_output));title('rmulr output');
subplot(2,2,4);plot(abs(fmulr_output));title('fmulr output');



