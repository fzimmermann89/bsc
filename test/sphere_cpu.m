function slice = sphere_cpu( z,N,radius )
range=1:N;
[xx,yy]=meshgrid(range);
slice=(xx.^2+yy.^2+z^2)<radius^2;
end