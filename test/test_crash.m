function test_crash
N=2048;
Nz=5000;
a=rand(N,N,'gpuArray');
b=rand(N,N,'gpuArray');
tic
  for n=1:Nz
 a=ft2(a);
% d=fftshift(fft2(fftshift(a)));
%a=gather(a);
%pause(0.1);
a=a.*b;
% d=d.*b;
 a=ift2(a);
% d=ifftshift(ifft2(ifftshift(d)));
end
a=gather(a);
 toc
%  end
imagesc(1:N,1:N,abs(a));
% tic
%  for n=1:Nz
% c=fft2(fftshift(a));
% c=c.*ifftshift(b);
% c=ifftshift(ifft2(c));
%  end
% toc
%
% [min(min(imag(c-d))), min(min(real(c-d))), min(min(imag(c-d))),min(min(real(c-d)))]