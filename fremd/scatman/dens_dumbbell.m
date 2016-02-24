function [dens, gridX, gridY, gridZ] = dens_dumbbell(longAxis,shortAxis,depth,alphaY,alphaZ,densResolution)


% densResolution = 100;
% longAxis = 300;
% shortAxis = 100;
% alphaY = 0;
% alphaZ = 90.;
% depth = 1.5;

nbox = round(densResolution/2);
radShortRatio = shortAxis/longAxis;
grid = (-nbox:nbox)/nbox;
dGrid = abs(grid(2)-grid(1));
[x,y,z] = meshgrid(grid,grid,grid);


[x,y,z] = rotateZ(x,y,z,alphaY);
[x,y,z] = rotateY(x,y,z,alphaZ);
 

rad = radShortRatio;
a = rad/depth;
% c = sqrt(a^2*dist^2/(rad^2-a^2));

zm = 1-rad;
c = sqrt((a^2+zm^2-rad^2)*a^2/(rad^2-a^2));
dist = zm/(a^2/c^2+1);
ym = 0;
xm = 0;
rCyl = sqrt(1+xm.^2);

% a = rad/2;
b = a;
% c = sqrt(a^2*dist^2/(rad^2-a^2));


dens1 = abs(z) <= dist;
dens2 = (x/a).^2+(y/b).^2<1+(z/c).^2;

dens3 = z <= zm+rad;
dens4 = z >= dist;
dens5 = x.^2+y.^2+(z-zm).^2 <= rad^2; 

dens6 = z >= -zm-rad;
dens7 = z <= -dist;
dens8 = x.^2+y.^2+(z+zm).^2 <= rad^2;

dens = dens1.*dens2 + dens3.*dens4.*dens5 + dens6.*dens7.*dens8;


gridX = grid*longAxis/2;
gridY = grid*longAxis/2;
gridZ = grid*longAxis/2; 

% figure
% imagesc(sum(dens,3))


end

            