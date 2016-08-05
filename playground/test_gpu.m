obj=scatterObjects.sphere(1000,30);

f=obj.getslicefunc;
tic
a=0;
for z=0:10000
a=a+f(z);
end
toc
% gpu=gpuDevice(1);
% display('start')
% tic
%
% a=gpuArray(1:100000000);
% fft(a);
% wait(gpu)
% toc
% display('end')