function out=test(N)
kern=parallel.gpu.CUDAKernel('kernel.ptx','kernel.cu','addKernel');
kern.ThreadBlockSize = [6,1,1];
a=gpuArray(int32([1;2;3;4]));
b=gpuArray(int32([10;20;30;40]));
c=gpuArray(int32(zeros(6,1)));
d=feval(kern,a,b,c);
a
b
c
d
end