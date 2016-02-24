function plot_wheel(longAxis,shortAxis,alphaZ,alphaY,plot_axes,dens_proj_axes)

rad = (longAxis-shortAxis)/2;
radInner = shortAxis/2;
pts = 50; 

u=0:2*pi/pts:2*pi;
v=-pi/2:pi/pts:pi/2;
[U,V] = meshgrid(u,v);

X=(rad+radInner.*cos(V)).*cos(U);
Y=(rad+radInner.*cos(V)).*sin(U);
Z=radInner.*sin(V);

XC1 = (0:0.1:rad)' * cos(u);
YC1 = (0:0.1:rad)' * sin(u);
ZC1 = ones(size(XC1))*radInner;

XC2 = (0:0.1:rad)' * cos(u);
YC2 = (0:0.1:rad)' * sin(u);
ZC2 = -ones(size(XC1))*radInner;

x=[XC1; X; XC2];
y=[YC1; Y; YC2];
z=[ZC1; Z; ZC2];



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
