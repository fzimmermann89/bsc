fnameprefix='.\Tex\Images\fig_simholo';
N=4096;
dx=1/2;
dz=1/4;
wavelength=1;


coreDelta=1.5e-4
coreBeta=1.5e-4
innerBeta=.5e-4
innerDelta=.5e-4
membraneBeta=2e-4
membraneDelta=2e-4
referenceBeta=1e-3
referenceDelta=1e-3
rotationX=31.7/180*pi;
rotationY=0/180*pi;
rotationZ=0/180*pi;
positionX=-300;
positionY=-350;
positionZ=0;

reference=scatterObjects.dodecahedron();
reference.radius=100;
reference.positionX=650;
reference.positionY=650;
reference.beta=referenceBeta;
reference.delta=referenceDelta;

membrane=scatterObjects.icosahedron();
membrane.radius=375;
membrane.positionX=positionX;
membrane.positionY=positionY;
membrane.beta=membraneBeta;
membrane.delta=membraneDelta;
membrane.rotationX=rotationX;
membrane.rotationY=rotationY;
membrane.rotationZ=rotationZ;

inner=scatterObjects.icosahedron();
inner.radius=350;
inner.positionX=positionX;
inner.positionY=positionY;
inner.beta=innerBeta-membraneBeta;
inner.delta=innerDelta-membraneDelta;
inner.rotationX=rotationX;
inner.rotationY=rotationY;
inner.rotationZ=rotationZ;



core1=scatterObjects.sphere();
core1.radius=90;
core1.positionX=positionX+180*sin(pi/3);
core1.positionY=positionY-180*cos(pi/3);
core1.positionZ=positionZ-180/6;
core1.beta=coreDelta-innerBeta;
core1.delta=coreBeta-innerDelta;

core2=scatterObjects.sphere();
core2.radius=90;
core2.positionX=positionX-180*sin(pi/3);
core2.positionY=positionY-180*cos(pi/3);
core2.positionZ=positionZ-180/6;
core2.beta=coreDelta-innerBeta;
core2.delta=coreBeta-innerDelta;

core3=scatterObjects.sphere();
core3.radius=90;
core3.positionX=positionX;
core3.positionY=positionY+180;
core3.positionZ=positionZ-180/6;
core3.beta=coreDelta-innerBeta;
core3.delta=coreBeta-innerDelta;

core4=scatterObjects.sphere();
core4.radius=90;
core4.positionX=positionX;
core4.positionY=positionY;
core4.positionZ=positionZ+180/2;
core4.beta=coreDelta-innerBeta;
core4.delta=coreBeta-innerDelta;

clear objects;
objects{1}=reference;
objects{end+1}=membrane;
objects{end+1}=inner;
objects{end+1}=core1;
objects{end+1}=core2;
objects{end+1}=core3;
objects{end+1}=core4;


if parallel.gpu.GPUDevice.isAvailable
    g=gpuDevice();
    reset(g);
    gpu=true;
else
    gpu=false;
end

%%
% 
%  proj=scatterObjects.projection(objects,N,dx,gpu );
%  figure(1); imagesc(abs(proj));
% % 
 exitwave=multislice(wavelength,objects,N,dx,dz,gpu);
%  exitwave=gather(exitwave-exitwave(end/2+1,1));
exitwave=gather(exitwave);
%   exitwavep=padarray(exitwave,size(exitwave)./2);

%%
% 
%  figure(2)
%  imagesc(abs(exitwave));
%  
%  figure(3);imagesc(abs(ift2(abs(ft2(exitwavep).^2))))
%  
 
 
%% 
f=figure('visible','off');
r=abs(exitwave);
rmin=0;
rmax = max(r(isfinite(r)));
im=compleximagesc(exitwave,[rmin,rmax]);
axis square
ax=gca;
ax.XTick=[];
ax.YTick=[];
fname=strcat(fnameprefix,'_exitwave','.png');
save_image(fname);


%% figure colorwheel
N=1024;
gamma=.9;
[x, y] = meshgrid(linspace(-1,1,N));
[theta, rho] = cart2pol(x, y);
h = (theta + pi) / (2 * pi);     
s=ones(size(rho));
l=(rho.^gamma);
l(rho>1)=0;
rgb=hsl2rgb(cat(3,h,s,l));

%show colorwheel
f=figure('visible','off');
ax1=axes('Position',[0.2,0.2,.6,.6]);
im=imshow(rgb,'Parent', ax1);
im.AlphaData=rho<1;

%show axis
ticks=linspace(rmin,rmax,4);
ax2=polaraxes('Position',[0.2,0.2,.6,.6]);
ax2.ThetaAxisUnits = 'radians';
ax2.Color='none'; 
ax2.RAxis.Label.String='rel. Intensität';
ax2.RAxis.Label.Position=[2,0.7,0];
ax2.ThetaAxis.Label.Position=[0,1.15,0];
ax2.ThetaAxis.Label.String='Phase';
ax2.ThetaTick=[0:0.25:2]*pi;
ax2.RLim=[rmin,rmax];
ax2.RTick=ticks(2:end);
ax2.RAxis.TickLabelFormat='%.1g';
ax3=polaraxes('Position',[0.2,0.2,.6,.6]);
ax3.ThetaTick=[];
ax3.RLim=[rmin,rmax];
ax3.RTick=ticks(1);
ax3.RAxis.TickLabelFormat='%.1g';
ax3.Color='none'; 
ax3.RAxis.Color=[1,1,1];
ax2.ThetaAxis.Color=[0,0,0];
ax3.ThetaAxis.Color=[0,0,0];
f.PaperSize=[20,20];
f.PaperPosition=[-4.5,-4,28,28];
ax3.FontSize=28;
ax2.FontSize=28;
ax2.LineWidth=1;
ax2.GridAlpha=1;
ax2.GridColor=[0.3,0.3,0.3];
ax2.GridLineStyle='--';
f.Color='none';
ax1.Color='none';

fname=strcat(fnameprefix,'_exitwave_cw','.pdf');
print(fname,'-dpdf')
open(fname)
% 
% %% figure scatter multislice
% f=figure('visible','off');
% scatter=log10(abs(run.scatter.multislice(1+3/8*end:5/8*end,1+3/8*end:5/8*end)));
% scattermin=min(scatter(:)).*.75;
% im=imagesc(scatter);
% colormap parula
% caxis([scattermin,0]);
% axis square
% ax=gca;
% ax.XAxis.TickValues=pos;
% ax.XAxis.TickLabels=sprintf('%g°\n',lab);
% ax.YAxis.TickValues=pos;
% ax.YAxis.TickLabels=sprintf('%g°\n',lab);
% ax.XAxis.Label.FontSize=12;
% ax.YAxis.Label.FontSize=12;
% 
% save_image(strcat(fnameprefix,'_scatter_multislice',fnamepostfix,'.png'));
% 
% 
%  
%  
 
 
 
 
 
 
 
 
%  scatter=exitwave2scatter(exitwave);
%  figure(3);
%  imagesc(scatter);
%  
%  figure(4)
%  imagesc(abs(ift2(scatter)));
%  % 
% 
% figure(1)
%   model=scatterObjects.toMatrix({membrane},N/16,dx*16,gpu );
% 
% clf
% [px,py,pz] = ind2sub(size(model),find(model));
% points = [px py pz];
% DT = DelaunayTri(points);  %# Create the tetrahedral mesh
% hullFacets = convexHull(DT);       %# Find the facets of the convex hull
% trisurf(hullFacets,DT.X(:,1),DT.X(:,2),DT.X(:,3),'FaceColor','c','LineStyle','none')
% l=light('Position',[0 0 -1],'Style','local')
% l.Position=[130,130,400] 
% mArrow3([N/32,N/32,N/32-N/64],[N/32,N/32,N/32-N/128]);
% axis square;
% view(90,90);
% title(' hull');
% lighting gouraud