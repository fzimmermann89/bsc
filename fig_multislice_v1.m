close all
clear all
addpath('helper');
[xx,yy]=meshgrid(-7:8)
zz=5*ones(10);
figure; hold on
for z=-7:8
    slice=xx.^2+yy.^2+z^2<6^2;
    slice=log(abs(ft2(slice)));
    
    plotslice(slice,z)
end
axis equal
axis off
view(100,30)
camroll(90)
function plotslice(data,z)
    data=gather(double(data));
    opts={'EdgeAlpha',0,'FaceAlpha',1};
    dist=5;
    zz=dist*z+1;
    [xsurface,ysurface]=meshgrid(1:size(data,1),1:size(data,2));
    zsurface=ones(size(data))*zz;
    surf(xsurface,ysurface,zsurface,data,opts{:});
    xoutline=[0,0,1,1]*(size(data,1)-1)+1;
    youtline=[0,1,1,0]*(size(data,2)-1)+1;
    zoutline=ones(size(xoutline))*zz;
    patch(xoutline,youtline,zoutline,'blue','FaceAlpha',0,'EdgeColor','black','EdgeLighting','flat');
end