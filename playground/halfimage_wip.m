function out=halfimage_wip(in)
    tbs=512;
    N=length(in)/2;
    
    persistent kernel_col
    if isempty(kernel_col)||~existsOnGPU(kernel_col)
        kernel_col = parallel.gpu.CUDAKernel('halfimage.ptx','halfimage.cu','halfy');
    end
    kernel_col.SharedMemorySize=8*2*tbs+1;
    kernel_col.ThreadBlockSize =[1, tbs,1];
    kernel_col.GridSize=[2*N,ceil(N/tbs),1];
    out_col=
    
    persistent kernel_row
    if isempty(kernel_row)||~existsOnGPU(kernel_row)
        kernel_row = parallel.gpu.CUDAKernel('halfimage.ptx','halfimage.cu','halfx');
    end
    kernel_row.SharedMemorySize=8*2*tbs+1;
    kernel_row.ThreadBlockSize =[tbs, 1,1];
    kernel_row.GridSize=[ceil(N/tbs),N,1];
    out=feval(kernel_row,N,out_col,gpuArray.zeros(N,N));
    
end