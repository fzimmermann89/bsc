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

caption='v2';
outpath='./Tex/images';
inputfilename='.\data\sim_complexobject.mat';
outputfilename=sprintf('%s/recon3d-%s.png',outpath,caption);


%% Prepare Input
[scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input]=prepareInput_exitwave(inputfilename,refError,maskScale,sigmaMask,discreteBits);

%move to gpu
if parallel.gpu.GPUDevice.isAvailable
    gpu=gpuDevice(1);
    mask=gpuArray(mask);
    scatterImageHolo=gpuArray(scatterImageHolo);
    scatterImage=gpuArray(scatterImage);
end


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
cut=@(x)x(end/2-end/4:end/2+end/4+1,end/2-end/4:end/2+end/4+1);
focus=findFocus(cut(input),settings.dx,settings.wavelength,true);

%% plot results
finput=maskfilter(input,softmask);
ffocus=maskfilter(focus,softmask);
fresultSW=maskfilter(resultSW,softmask);
fresultHolo=maskfilter(resultHolo,softmask);
fresultDeconv=maskfilter(resultDeconv,softmask);

move=@(x)moveAndMirror(finput,x);
cut=@(x)x(end/2-end/4:end/2+end/4+1,end/2-end/4:end/2+end/4+1);
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
compleximagesc(norm(ffocus,input),cscale);
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
print(outputfilename,'-dpng','-r150');

%% write scatter image
f=figure('visible','off');
scatter=(abs(scatterImageHolo(1+1/4*end:3/4*end,1+1/4*end:3/4*end))); %(1+1/4*end:3/4*end,1+1/4*end:3/4*end)
scatter=log10(scatter./max(scatter(:)));
scattermin=gather(min(scatter(isfinite(scatter))).*.6);
im=imagesc(scatter);
colormap parula
caxis([scattermin,0]);
axis square
outputfilename_scatter=sprintf('%s/fig_simholo_%s_scatter.png',outpath,caption);
save_image(outputfilename_scatter);

f=figure('colormap',parula(128),'visible','off');
cb=colorbar('vert');
ax=gca;
ax.Color='none';
ax.FontSize=18;
caxis([scattermin,0]);
axis off;
cb.TickLabels=sprintfc('\\color{white} 10^{%g}',cb.Ticks);
outputfilename_cb=sprintf('%s/fig_simholo_%s_scatter_cb.pdf',outpath,caption);
ax.ZColor=[1,1,1];
f.PaperSize=[10,10];
f.PaperPosition=[-7.5,0,10,10];
print(outputfilename_cb,'-dpdf')