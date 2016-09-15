function out=halfimage(in)
    persistent kernel;
     try
        N=floor(length(in)/2);
        if isempty(kernel)||~existsOnGPU(kernel)
            kernel = parallel.gpu.CUDAKernel('halfimage.ptx','halfimage.cu','halfimage');
        end
        kernel.ThreadBlockSize =[4, 8,1];
        kernel.GridSize=[ceil(N/4),ceil(N/8),1];
        if isreal(in);
            out=feval(kernel,N,gpuArray(double(in)),gpuArray.zeros(N,N));
        else
            out=feval(kernel,N,gpuArray(double(real(in))),gpuArray.zeros(N,N));
            out=out+1i*feval(kernel,N,gpuArray(double(imag(in))),gpuArray.zeros(N,N));
        end
        if ~isa(in,'gpuArray')
            out=gather(out);
        end;
     catch
        clear kernel;
        error('error running halfimage kernel');
    end
end