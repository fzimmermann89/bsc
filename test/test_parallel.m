clear all
N=800;
d=512;
%in=zeros(d,d);
%out=zeros(N,d,d);
tmp=0;
%in=rand(N,d,d);
tic
%parfor n = 1:N, out(n,:,:)=fft2(squeeze(in(n,:,:))),end;
% parfor n = 1:N, in=rand(d,d), tmp=tmp+sum(sum(fft2(in)));end;
for n=1:N
    in=rand(d,d);
     tmp=tmp+sum(sum(fft2(in)));
     % out(n,:,:)=fft2(squeeze(in(n,:,:)));
 end
toc