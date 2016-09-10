function out = projection( objects,N,dx,gpu )
    %Converts (a cell array of) objects to a 2d Projection

    if gpu
        out=single(gpuArray.zeros(N,N));
    else
        out=single(zeros(N,N));
    end


    for nobj=length(objects):-1:1
        slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
    bd{nobj}=single(-objects{nobj}.delta+1i*objects{nobj}.beta);
    end

    for nz=1:N
        z=(nz-N/2)*dx;%;
        for nobj=length(objects):-1:1
            f=slicefun{nobj};
            out=out+f(z).*bd{nobj};
        end
    end
    %unlock objects
    for nobj=length(objects):-1:1
        objects{nobj}.unlock();
    end
end

