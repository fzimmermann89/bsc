for o=1:3
    tic
    out=zeros(1,4);
    for n=1:4;
        g=gpuDevice();
        a=gpuArray.rand(4096);
        for m=1:200;
            a=fft2(a)./mean(a(:));
        end
        t=gather(mean(a(:)));
        out(n)=t;
    end
    toc
end