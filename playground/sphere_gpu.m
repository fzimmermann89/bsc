function slice = sphere_gpu( z,N,radius )
range=gpuArray.linspace(0,N-1,N);
[xx,yy]=meshgrid(range);
tmp=(xx.^2+yy.^2+z^2)<radius^2;
slice=gather(tmp);
end

