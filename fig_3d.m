% Reconstruction and figures for 3d exitwave. Uses output of sim_holo.

clear all;
close all;

addpath('reconstruction');
addpath('simulation');
addpath('helper');

%% settings
refError=1.0;
maskScale=1/4096; %just filter dc
sigmaMask=0;
discreteBits=0;
wienernoise=1e4;
focus_distance=-71; %distance to focus exitwave directly behind object
caption='v2';
outpath='./Tex/images2';
inputfilename='.\data\sim_complexobject.mat';


%% Prepare Input
[scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input,settings]=prepareInput_exitwave(inputfilename,refError,maskScale,sigmaMask,discreteBits);

%move to gpu
if parallel.gpu.GPUDevice.isAvailable
    gpu=gpuDevice(1);
    mask=gpuArray(mask);
    scatterImageHolo=gpuArray(scatterImageHolo);
    scatterImage=gpuArray(scatterImage);
end

%% Reconstruction
%% use Holography and IPR
%support and start
[start,support]=holoSupport(scatterImageHolo,softmask,refImage,'threshold',1,'debug',true);

%Plan:
planHolo=recon.plan();
for n=1:20
    planHolo.addStep('hio',200);
    planHolo.addStep('er',1);
end
planHolo.addStep('show');
planHolo.addStep('er',50);
planHolo.addStep('show');

%Run
[resultHolo]=planHolo.run(scatterImageHolo,support,start,mask);


%% use IPR with Shrinkwrap
%support and start
[start,support]=genericSupport(scatterImage,softmask);

%Plan
planSW=recon.plan();
for n=1:20
    planSW.addStep('hio',50);
    planSW.addStep('er',5);
    planSW.addStep('sw',1,{10,0.05});
end
planSW.addStep('loosen',1,{10})
planSW.addStep('show')
for n=1:20
    planSW.addStep('hio',200);
    planSW.addStep('er',1);
end
planSW.addStep('er',50);
planSW.addStep('show');

%Run multiple times and average
%         multi=10;
%         multistart=zeros([size(start),multi]);
%         for n=1:multi
%             multistart(:,:,n)=gather(ift2(ft2(start).*exp(2i*pi*rand(size(start))).*softmask));
%         end
%         [result,images,errors]=planSW.runAvg(scatterImage,support,multistart,mask,ceil(multi/2));
[resultSW]=planSW.run(scatterImage,support,start,mask);


%% wiener deconvolution
%get cross correlation
[~,~,cross]=holoSupport(scatterImageHolo,softmask,refImage,'threshold',0.5,'radDilate',30,'radClose',30);

%and filtered (guessed) Reference
refImageFiltered=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));
crossPadded=pad2size(cross-cross(1),size(scatterImageHolo));
refImagePadded=pad2size(refImageFiltered-refImageFiltered(1),size(scatterImageHolo));

% deconvolution
resultDeconv=wiener(crossPadded,refImagePadded,wienernoise,true);

%% focus input
cut=@(x)x(1+end/2-end/8:end/2+end/8,1+end/2-end/8:end/2+end/8);
input=focusExitwave(cut(input),settings.dx,settings.wavelength,true,focus_distance); %directly behind object

%% plot reconstruction results
finput=maskfilter(input,softmask);
ffocus=maskfilter(focus,softmask);
fresultSW=maskfilter(resultSW,softmask);
fresultHolo=maskfilter(resultHolo,softmask);
fresultDeconv=maskfilter(resultDeconv,softmask);

move=@(x)moveAndMirror(finput,x);
cut=@(x)x(1+end/2-end/8:end/2+end/8,1+end/2-end/8:end/2+end/8);
norm=@(x,y)x.*(max(y(:)-y(1))./max(x(:)))+y(1);
cscale=[min(abs(input(:))),max(abs(input(:)))];

f=figure();
delim=32;
pixel=512;
scale=1/2;
f.Position=[0,0,(2*pixel+delim),(2*pixel+delim)].*scale;

ax(1)=subplot(2,2,1);
ax(1).Units='pixels';
ax(1).Position=[0,pixel+delim,pixel,pixel].*scale;
compleximagesc(norm(finuput,input),cscale);
axis off;
ax(1).ActivePositionProperty='position';

ax(2)=subplot(2,2,3);
ax(2).Units='pixels';
ax(2).Position=[0,0,pixel,pixel].*scale;
compleximagesc(norm(cut(move(fresultDeconv)),input),cscale);
axis off;
ax(2).ActivePositionProperty='position';

ax(3)=subplot(2,2,2);
ax(3).Units='pixels';
ax(3).Position=[pixel+delim,pixel+delim,pixel,pixel].*scale;
compleximagesc(norm(cut(move(fresultSW)),input),cscale);
axis off;
ax(3).ActivePositionProperty='position';

ax(4)=subplot(2,2,4);
ax(4).Units='pixels';
ax(4).Position=[pixel+delim,0,pixel,pixel].*scale;
compleximagesc(norm(cut(move(fresultHolo)),inputHolo),cscale);
axis off;
ax(4).ActivePositionProperty='position';

f.PaperUnits='inches';
f.PaperPositionMode='manual';
f.PaperPosition=[0,0,(2*pixel+delim)/150,(2*pixel+delim)/150];
f.PaperSize=[(2*pixel+delim)/150, (2*pixel+delim)/150];
f.Resize='off';

outputfilename=sprintf('%s/recon3d-%s.png',outpath,caption);
print(outputfilename,'-dpng','-r150');

%% plot exitwave
f=figure('visible','off');
r=abs(input);
rmin=0;
rmax = max(r(isfinite(r)));
im=compleximagesc(input,[rmin,rmax]);
axis square
ax=gca;
ax.XTick=[];
ax.YTick=[];

subcaption='exitwave_focus';
outputfilename=sprintf('%s/fig_simholo_%s_%s.png',outpath,caption,subcaption);
save_image(outputfilename);


%% colorwheel
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

subcaption='exitwave_focus_cw';
outputfilename=sprintf('%s/fig_simholo_%s_%s.png',outpath,caption,subcaption);
print(outputfilename,'-dpdf')

%% plot scatter image
f=figure('visible','off');
scatter=(abs(scatterImageHolo(1+1/4*end:3/4*end,1+1/4*end:3/4*end)));
scatter=log10(scatter./max(scatter(:)));
scattermin=gather(min(scatter(isfinite(scatter))).*.6);
im=imagesc(scatter);
colormap parula
caxis([scattermin,0]);
axis square

subcaption='scatter';
outputfilename=sprintf('%s/fig_simholo_%s_%s.png',outpath,caption,subcaption);
save_image(outputfilename);


f=figure('colormap',parula(128),'visible','off');
cb=colorbar('vert');
ax=gca;
ax.Color='none';
ax.FontSize=18;
caxis([scattermin,0]);
axis off;
cb.TickLabels=sprintfc('\\color{white} 10^{%g}',cb.Ticks);
ax.ZColor=[1,1,1];
f.PaperSize=[10,10];
f.PaperPosition=[-7.5,0,10,10];

subcaption='scatter_cb';
outputfilename=sprintf('%s/fig_simholo_%s_%s.png',outpath,caption,subcaption);
print(outputfilename,'-dpdf')

%% plot focused images
move=@(x)moveAndMirror(finput,x,true);
cut=@(x)x(1+end/2-end/8:end/2+end/8,1+end/2-end/8:end/2+end/8);
norm=@(x,y)x.*(max(y(:)-y(1))./max(x(:)))+y(1);

focusinput=focusExitwave(input,settings.dx,settings.wavelength,true,-50);
focusrecon=focusExitwave(norm(cut(move(resultHolo)),focusinput),settings.dx,settings.wavelength,true,30);
ffocusinput=maskfilter(focusinput,softmask);
ffocusrecon=maskfilter(focusrecon,softmask);

cscale=[min(abs(input(:))),max(abs(input(:)))];

f=figure();
delim=32;
pixel=512;
scale=1/2;
f.Position=[0,0,(2*pixel+delim),pixel].*scale;

ax(1)=subplot(1,2,1);
ax(1).Units='pixels';
ax(1).Position=[0,0,pixel,pixel].*scale;
compleximagesc(norm(ffocusinput,input),cscale);
axis off;
ax(1).ActivePositionProperty='position';

ax(2)=subplot(1,2,2);
ax(2).Units='pixels';
ax(2).Position=[pixel+delim,0,pixel,pixel].*scale;
compleximagesc(norm(ffocusrecon,input),cscale);
axis off;
ax(2).ActivePositionProperty='position';

subcaption='focus';
outputfilename=sprintf('%s/recon3d-%s_%s.png',outpath,caption,subcaption);
print(outputfilename,'-dpng','-r150');