function plot_dumbbell(longAxis,shortAxis,depth,alphaZ,alphaY,plot_axes,dens_proj_axes)


% longAxis = 150;
% shortAxis = 70;
% alphaY = 90;
% alphaZ = 0.;
% depth = 1;

pts = 100;
rad = shortAxis/2;

a = rad/depth;
% c = sqrt(a^2*dist^2/(rad^2-a^2));

zm = (longAxis-shortAxis)/2;
c = sqrt((a^2+zm^2-rad^2)*a^2/(rad^2-a^2));
dist = zm/(a^2/c^2+1);


[xs,ys,zs] = sphere(pts);

% U = -dist_tang:2*dist_tang/pts:dist_tang;
U = -dist:2*dist/pts:dist;
V = 0:2*pi/pts:2*pi;

[zh,phi] = meshgrid(U,V);

zh = sort(zh);

r = (1+(zh/c).^2).^(1/2)*a;

xh = r.*cos(phi);
yh = r.*sin(phi);


% xs1 = xs(1:pts/2+1,:)*rad;
% ys1 = ys(1:pts/2+1,:)*rad;
% zs1 = zs(1:pts/2+1,:)*rad-dist;
% xs2 = xs(pts/2+1:end,:)*rad;
% ys2 = ys(pts/2+1:end,:)*rad;
% zs2 = zs(pts/2+1:end,:)*rad+dist;

xs1 = xs*rad;
ys1 = ys*rad;
zs1 = zs*rad-zm;
xs2 = xs*rad;
ys2 = ys*rad;
zs2 = zs*rad+zm;

% mask1 = abs(zs1) >= dist_tang;
% mask2 = zs2 >= dist_tang;
% mask1 = zs1 <= dist;
% mask2 = zs2 >= dist;


% mask1 = mask1+0;
% mask2 = mask2+0;

% mask1(mask1==0) = NaN;
% mask2(mask2==0) = NaN;


% xs1 = xs1.*mask1;
% ys1 = ys1.*mask1;
% zs1 = zs1.*mask1;
% xs2 = xs2.*mask2;
% ys2 = ys2.*mask2;
% zs2 = zs2.*mask2;



[xh,yh,zh] = rotateY(xh,yh,zh,alphaY);
[xh,yh,zh] = rotateZ(xh,yh,zh,alphaZ);

[xs1,ys1,zs1] = rotateY(xs1,ys1,zs1,alphaY);
[xs1,ys1,zs1] = rotateZ(xs1,ys1,zs1,alphaZ);

[xs2,ys2,zs2] = rotateY(xs2,ys2,zs2,alphaY);
[xs2,ys2,zs2] = rotateZ(xs2,ys2,zs2,alphaZ);

axes(plot_axes)
% figure
p2 = surf(zs1,xs1,ys1);
hold on
p3 = surf(zs2,xs2,ys2);
p1 = surf(zh,xh,yh);
axis equal
set(p1, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
set(p2, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
set(p3, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
light('Position',[30 -100 -50],'Color','white');
light('Position',[0 0 1],'Style','infinite','Color','white');
lighting gouraud
material([.1 .8 .4])
xlabel('z');
ylabel('x');
zlabel('y');
hold off

axes(dens_proj_axes);
p1 = surf(xh,yh,zh);
hold on
p2 = surf(xs1,ys1,zs1);
p3 = surf(xs2,ys2,zs2);
axis equal
set(p1, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
set(p2, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
set(p3, 'FaceColor', [0.8 .8 0.3], 'EdgeColor', 'none');
light('Position',[30 -100 -50],'Color','white');
light('Position',[0 0 1],'Style','infinite','Color','white');
lighting gouraud
material([.1 .8 .4])
view(2)
grid off
axis off
hold off


end