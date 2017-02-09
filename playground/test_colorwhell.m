fname='Tex/Images/colorwheel.pdf';
%create colorwheel
N=1024;
gamma=.9;
[x, y] = meshgrid(linspace(-1,1,N));
[theta, rho] = cart2pol(x, y);
h = (theta + pi) / (2 * pi);     
s=ones(size(rho));
l=min(1,real((rho).^gamma));
hsl=cat(3,h,s,l);
rgb=hsl2rgb(hsl);

%show colorwheel
f=figure('visible','off');
ax1=axes('Position',[0.2,0.2,.6,.6]);
im=imshow(rgb,'Parent', ax1);
im.AlphaData=rho<1;

%show axis
ax2=polaraxes('Position',[0.2,0.2,.6,.6]);
ax2.ThetaAxisUnits = 'radians';
ax2.Color='none'; 
ax2.RAxis.Label.String='rel. Intensität';
ax2.RAxis.Label.Position=[1.2,0.6,0];
ax2.ThetaAxis.Label.Position=[0,1.1,0];
ax2.ThetaAxis.Label.String='Phase';
ax2.ThetaTick=[0:0.25:2]*pi;
ax3=polaraxes('Position',[0.2,0.2,.6,.6]);
ax3.ThetaTick=[];
ax3.RTick=[0];
ax3.Color='none'; 
ax3.RAxis.Color=[1,1,1];
ax2.ThetaColor=[1,1,1];
ax3.ThetaAxis.Color=[1,1,1];
f.PaperSize=[20,20];
f.PaperPosition=[-5,-4,28,28];
ax3.FontSize=18;
ax2.FontSize=18;
f.Color='none';
ax1.Color='none';
%output
print(fname,'-dpdf')
open(fname)




