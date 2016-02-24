N=256
data=rand(N,'gpuArray');
a=data;
b=gather(data);
% a=gpuArray.zeros(N,N);
% tic
% for n=1:(N*8)
%     a=ft2(a);
%     %a=exp(a);
%     a=ift2(a);
% end
% toc
tic
for n=1:(N*8)
    a=fftshift(fft2(fftshift(a)));
   % b=exp(b);
    a=fftshift(ifft2(fftshift(a)));
   end
toc

% b=zeros(N,N);
tic
for n=1:(N*8)
    b=fftshift(fft2(fftshift(b)));
   % b=exp(b);
    b=fftshift(ifft2(fftshift(b)));
   end
toc
% 
% a=rand(N,'gpuArray');
% a=padarray(a,[N,N]);
% b=rand(N);
% b=padarray(b,[N,N]);
% tic
% for n=1:1024
%     a=ft2(a);
% end
% toc
% tic
% for n=1:1024
%     b=ft2(b);
% end
% toc


> % Pad the high frequency
> padsize = 28/2;
> if mod(length(z),2) % odd
> zp = ifftshift([zeros(1,padsize) fftshift(z) zeros(1,padsize)]);
> else % even
> zp = fftshift(z);
> zp(1) = zp(1)/2;
> zp(end+1) = zp(1);
> zp = ifftshift([zeros(1,padsize) zp zeros(1,padsize-1)]);
> end