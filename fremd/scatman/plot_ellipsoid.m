function plot_ellipsoid(longAxis,shortAxis,alphaZ,alphaY,plot_axes,dens_proj_axes)

b = shortAxis/longAxis;
c = 1.;
a = shortAxis/longAxis;

[x,y,z] = ellipsoid(0,0,0,a,b,c,100);
x = x*longAxis/2;
y = y*longAxis/2;
z = z*longAxis/2;

[x,y,z] = rotateY(x,y,z,alphaY);
[x,y,z] = rotateZ(x,y,z,alphaZ);


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

