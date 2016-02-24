N=32;
range1=floor(linspace(-N/4,N/4-1/2,N))*2;
range2=linspace(-N/2,N/2-1,N);
frange1=fftshift(fft(fftshift(range1)));
frange2=fftshift(fft(fftshift(range2)));
frange3=frange2;
frange3([1:N/4 3*N/4+1:end])=0;
range3=fftshift(ifft(fftshift(frange3)));
subplot(3,2,1)
plot(1:N,range1);
subplot(3,2,2)
plot(1:N,real(frange1),'b',1:N,imag(frange1),'r',1:N,abs(frange1),'g');
subplot(3,2,3)
plot(1:N,range2);
subplot(3,2,4)
plot(1:N,real(frange2),'b',1:N,imag(frange2),'r',1:N,abs(frange2),'g');
subplot(3,2,5)
plot(1:N,range3);
subplot(3,2,6)
plot(1:N,real(frange3),'b',1:N,imag(frange3),'r',1:N,abs(frange3),'g');
% % % a=rand(16*1024,16*1024);
% % % 
% % % tic
% % % c=gather(ft2(a));
% % % t1=toc
% % % tic
% % % d=conv2(a,b);yy
% % % t2=toc
% % % 
% % % t2/t1
% % y=[5 2 5 3 1 0 1 2];
% % y2=[zeros(1,10) y zeros(1,10)];
% % 
% % y2f=fftshift(fft(fftshift(y2)));
% % y2f(1)=y2f(1)/2;
% % y2f(end+1)=y2f(1);
% % y2fs=fftshift([zeros(1,1024) y2f  zeros(1,1023)]);
% % y2=fftshift(ifft(y2fs));
% % figure(1)
% % subplot(1,2,1)
% % plot(1:length(y),y)
% % subplot(1,2,2)
% % plot(1:length(y2),y2)
% % % N=1024;
% % % a=rand(N,N);
% % % tic
% % % for n=1:N
% % % a=fftshift(a);
% % % %    index= mod((0:N-1)-double(rem(floor(N/2),N)), N)+1;
% % % %     a = a(index,index);
% % % end
% % % b=gather(a);
% % % toc
% % % 
% % % 
% % % a=rand(N,N,'gpuArray');
% % % tic
% % % for n=1:N
% % % a=fftshift(a);
% % %    index= mod((0:N-1)-double(rem(floor(N/2),N)), N)+1;
% % %     a = a(index,index);
% % % end
% % % b=gather(a);
% % % toc
% % % 
% % % function pad
% % %     data(1)=data(1)/2
% % %     data(end+1)=data(1)
% % %     data=
% function test_conv
%     gpu=true;
% x=gpuArray([1 0 2 2 5 4 2 4 ]);
% y=getPropagator(8,1,1);
% 
% c=x;
% tic
% for z=1:1;
% c=conv(c,y,'same');
% c=c./max(c);
% end
% toc
% subplot(2,1,1)
% plot(1:length(c),c)
% 
% c2=padarray(x,[0,length(x)/2]);
% y2=padarray(fft(ifft(x)),[0,length(y)/2]);
% tic
% % n=length(x)/2;
% % for z=1:1000;
% % c2=conv2(c2,y,n);
% % c2=c2./max(c2);
% % end
% 
% n=length(x)*2;
% mask=getmask(n);
% c2=conv3(c2,y2);
% c2(mask)=0;
% c2=c2./max(c2);
% c2=c2(1+n/4:end-n/4);
% toc
% subplot(2,1,2)
% plot(1:length(c2),c2)
% end 
% 
% function out=conv2(v1,v2,n)
%     v1=padarray(v1,[0,n]);
% v2=padarray(v2,[0,n]);
% f1=fftshift(fft(fftshift(v1)));
% f2=fftshift(fft(fftshift(v2)));
% cf=f1.*f2;
% c=fftshift(ifft(fftshift(cf)));
% out=c(1+n:end-n);
% end
% 
% function out=conv3(v1,v2)
% 
% f1=fftshift(fft(fftshift(v1)));
% f2=fftshift(fft(fftshift(v2)));
% cf=f1.*f2;
% out=fftshift(ifft(fftshift(cf)));
% 
% end
% function out=getmask(n)
% out=false(1,n);
% out(1:n/4)=true;
% out(end-n/4+1:end)=true;
% end
% 
% 
%    function propagator=getPropagator(N,wavelength,deltaz)
%         %seperate function to create closure for tmp variables
%         if gpu
%             range=gpuArray.linspace(-1/2,1/2,N);
%         else
%             range=gpuArray.linspace(-1/2,1/2,N); %TODO
%         end
%         %TODO x,y skalieren
%         [uu,vv]=meshgrid(range,range);
%         propagator=exp((uu.^2+vv.^2)*(1i*pi*wavelength*deltaz));
%    end
%     
%    