function plot_tictac(longAxis,shortAxis,alphaZ,alphaY,plot_axes,dens_proj_axes)

pts = 100;
rad = shortAxis;
length = longAxis-shortAxis;

[xs,ys,zs] = sphere(pts);

xs1 = xs(1:pts/2+1,:)*rad;
ys1 = ys(1:pts/2+1,:)*rad;
zs1 = zs(1:pts/2+1,:)*rad-length/2;
xs2 = xs(pts/2+1:end,:)*rad;
ys2 = ys(pts/2+1:end,:)*rad;
zs2 = zs(pts/2+1:end,:)*rad+length/2;

x=[xs1; xs2];
y=[ys1; ys2];
z=[zs1; zs2];


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