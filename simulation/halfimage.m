function out=halfimage(in)
    persistent kernel;
    N=floor(length(in)/2);
    if isempty(kernel)||~existsOnGPU(kernel)
        kernel = parallel.gpu.CUDAKernel('halfimage.ptx','halfimage.cu','halfimage');
    end
    kernel.ThreadBlockSize =[4, 8,1];
    kernel.GridSize=[ceil(N/4),ceil(N/8),1];
    
    out=feval(kernel,N,in,gpuArray.zeros(N,N));
end