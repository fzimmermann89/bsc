clear all
close all
dz=1/2;
sep=3;
path='Tex\images\src\';
global color;
color=[49/255 39/255 131/255].*1.2;
rangeyz=-4:1:4;
rangex=-4:dz:4;
[xx,yy,zz]=meshgrid(rangeyz,rangex,rangeyz);
A=xx.^2+yy.^2+zz.^2<4.5^2;
sep=4;
B=zeros(size(A).*[sep 1 1]);
B(1:sep:size(A,1)*sep,:,:)=A;


fig1=figure(1);
hold on
[sx,sy,sz] = sphere(30);
s=surf(sx,sy,sz);
s.FaceColor=color;
s.EdgeAlpha=0;
axis equal
axis off
view(-15,15)
camlight right
lighting gouraud
material dull
print(strcat(path,'sphere1'),'-dpng');

fig2=figure(2);
hold on
draw(A,[dz,1,1],[dz,1,1]);
axis equal
axis off
view(-15,15)
camlight right
lighting gouraud
material dull
print(strcat(path,'sphere2'),'-dpng');

fig3=figure(3);
hold on
draw(B,[1/4,1,1],[1/4,1,1]);
axis equal
axis off
view(-15,15)
camlight right
lighting gouraud
material dull

print(strcat(path,'sphere3'),'-dpng');

function draw(mat,sz,d)
    if nargin<2;sz=[1,1,1];end
    if nargin<3;d=sz;end
global color;
[ix,iy,iz] = ind2sub(size(mat),find(mat==1));
x0=([0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]-0.5)*sz(1);
y0=([0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]-0.5)*sz(2);
z0=([0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]-0.5)*sz(3);
x=repmat(x0,1,numel(ix))+repmat(reshape(repmat(ix'*d(1),6,1),1,6*numel(ix)),4,1);
y=repmat(y0,1,numel(ix))+repmat(reshape(repmat(iy'*d(2),6,1),1,6*numel(ix)),4,1);
z=repmat(z0,1,numel(ix))+repmat(reshape(repmat(iz'*d(3),6,1),1,6*numel(ix)),4,1);
h=patch(x,y,z,color,'FaceAlpha',1,'EdgeColor','black','EdgeLighting','flat');
end