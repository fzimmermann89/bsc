% Simulation of sphere
clear all;
g=gpuDevice();
reset(g);
addpath('reconstruction','simulation','helper');

%% settings
fnameprefix='.\Tex\Images\fig_sim';
fnamepostfix='-r100-bd1e-3';

N=2*1024;
beta=1e-3;
delta=1e-3;
radius=100;
dx=1/2;
dz=1/8;
wavelength=1;

%% run
objects{1}=scatterObjects.sphere();
objects{1}.radius=radius;
objects{1}.beta=beta;
objects{1}.delta=delta;
run=singlerun(N,dx,dz,wavelength,objects);
%% values
minangle=1;
maxangle=20;
angles=run.scatter_scale;
x=angles(end/2+1:end,end/2+1);
err=structfun(@(x)median(abs(x(angles>minangle&angles<maxangle))),run.error_rel,'UniformOutput',false);
disp(err);
names=fieldnames(run.scatter);
% figure angle scale for 1/4 of image
angles=run.scatter_scale(1+3/8*end:5/8*end,1+3/8*end:5/8*end);
axlabel=(angles(1:end,end/2+1));
ual=unique(round(axlabel/2)*2);
leftpos=cell2mat(arrayfun(@(x)find(axlabel(1:end/2)>=x,1,'last'),ual,'UniformOutput',false));
pos=[flipud(leftpos);length(axlabel)-leftpos(2:end)];
lab=[flipud(ual);ual(2:end)];


%% figure exitwave multislice
f=figure('visible','off');
exitwave=run.exitwave.multislice(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
r=abs(exitwave);
rmin=0;
rmax = max(r(isfinite(r)));
im=compleximagesc(exitwave,[rmin,rmax]);
axis square
ax=gca;
ax.XTick=[];
ax.YTick=[];
fname=strcat(fnameprefix,'_exitwave_multislice',fnamepostfix,'.png');
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

fname=strcat(fnameprefix,'_exitwave_multislice_cw',fnamepostfix,'.pdf');
print(fname,'-dpdf')
open(fname)

%% figure scatter multislice
f=figure('visible','off');
scatter=log10(abs(run.scatter.multislice(1+3/8*end:5/8*end,1+3/8*end:5/8*end)));
scattermin=min(scatter(:)).*.75;
im=imagesc(scatter);
colormap parula
caxis([scattermin,0]);
axis square
ax=gca;
ax.XAxis.TickValues=pos;
ax.XAxis.TickLabels=sprintf('%g°\n',lab);
ax.YAxis.TickValues=pos;
ax.YAxis.TickLabels=sprintf('%g°\n',lab);
ax.XAxis.Label.FontSize=12;
ax.YAxis.Label.FontSize=12;

save_image(strcat(fnameprefix,'_scatter_multislice',fnamepostfix,'.png'));


%% colorbar
f=figure('colormap',parula(128),'visible','off');
cb=colorbar('vert');
ax=gca;
ax.Color='none';
ax.FontSize=18;
caxis([scattermin,0]);
axis off;
cb.TickLabels=sprintfc('\\color{white} 10^{%g}',cb.Ticks);
fname=strcat(fnameprefix,'_scatter_multislice_cb',fnamepostfix,'.pdf');
ax.ZColor=[1,1,1];
f.PaperSize=[10,10];
f.PaperPosition=[-7.5,0,10,10];
print(fname,'-dpdf')
open(fname)
%% figure error
c=load('colormap-error.mat');
for n=1:length(names);
    name=names{n};
    f=figure('visible','off');
    f.PaperSize=[14,11.5];
    f.PaperPosition=[-2.5,-.75,17,13.25];
    im=imagesc(abs(run.error_rel.(name)(1+3/8*end:5/8*end,1+3/8*end:5/8*end)));
    im.AlphaData=(angles<15);
    caxis([0,1]);
    axis square
    ax=gca;
    ax.XAxis.TickValues=pos;
    ax.XAxis.TickLabels=sprintf('%g°\n',lab);
    ax.YAxis.TickValues=pos;
    ax.YAxis.TickLabels=sprintf('%g°\n',lab);
    ax.XAxis.Label.FontSize=10;
    ax.YAxis.Label.FontSize=10;
    colormap(ax,c.values);
    cb=colorbar;
    cb.Position=[ 0.85    0.11    0.0476    0.80];
    fname=strcat(fnameprefix,'_relerror_',name,fnamepostfix,'.pdf');
    print(fname,'-dpdf');
    open(fname)
end