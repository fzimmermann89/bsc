clear all;
close all;

addpath('reconstruction');
addpath('simulation');
addpath('helper');

%% settings
refError=1.0;
maskScale=1/4096;
sigmaMask=0;
discreteBits=0;

outpath='./Tex/images';
inputfilename='.\data\sim_complexobject.mat';
load(inputfilename,'settings');
fnameprefix='.\Tex\Images\fig_simholo_v2';


%% Prepare Input
[scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input]=prepareInput_exitwave(inputfilename,refError,maskScale,sigmaMask,discreteBits);

%% focus
cut=@(x)x(1+end/2-end/4:end/2+end/4,1+end/2-end/4:end/2+end/4);
focus=gather(findFocus(cut(inputHolo),settings.dx,settings.wavelength,true));

%% output
f=figure('visible','off');
r=abs(focus);
rmin=0;
rmax = max(r(isfinite(r)));
im=compleximagesc(focus,[rmin,rmax]);
axis square
ax=gca;
ax.XTick=[];
ax.YTick=[];
fname=strcat(fnameprefix,'_exitwave_focus','.png');
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

fname=strcat(fnameprefix,'_exitwave_focus_cw','.pdf');
print(fname,'-dpdf')
open(fname)
