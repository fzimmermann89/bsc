function matrix = toMatrix( objects,N,dx,gpu )
%Converts (a cell array of) objects to a 3d-Matrix describing the presence of an object
%   (For usage of scatterObjects with streuOmat)
%will in most cases be a lot slower than using the objects slicewise..
matrix=false(N,N,N);
if gpu
    falsematrix=gpuArray.false(N,N);
else
    falsematrix=false(N,N);
end


for nobj=length(objects):-1:1
    slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
end
for nz=1:N
    z=(nz-N/2)*dx;
    slice=falsematrix;
    for nobj=length(objects):-1:1
        f=slicefun{nobj};
        idx=(f(z));
        slice(idx)=true;
    end
    if any(slice(:))
        matrix(:,:,nz)=gather(slice);
    end
end
%unlock objects
for nobj=length(objects):-1:1
    objects{nobj}.unlock();
end
end

