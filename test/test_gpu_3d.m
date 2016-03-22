function test_gpu_3d
    function ret=returnMatrix(z)
        ret=ones(N,N)*z;
    end
testz=gpuArray(1:100);
test=pagefun(@returnMatrix,testz);
end