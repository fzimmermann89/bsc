function plot_sphere(rad,plot_axes,dens_proj_axes)

[x,y,z] = sphere(100);
x = x*rad;
y = y*rad;
z = z*rad;
 

axes(plot_axes)
p1 = surf(z,x,y);
axis equal
set(p1, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
light('Position',[30 -100 -50],'Color','white');
light('Position',[0 0 1],'Style','infinite','Color','white');
lighting gouraud
material([.1 .8 .4])
xlabel('z');
ylabel('x');
zlabel('y');


axes(dens_proj_axes);
p1 = surf(x,y,z);
axis equal
set(p1, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
light('Position',[30 -100 -50],'Color','white');
light('Position',[0 0 1],'Style','infinite','Color','white');
lighting gouraud
material([.1 .8 .4])
view(2)
grid off
axis off


end
