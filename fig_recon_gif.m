clear all;
close all;

addpath('reconstruction');
g=gpuDevice(1);

%% settings
refRadius=40;
refError=1.01;
maskScale=16/2048;
sigmaMask=24;
discreteBits=16;
wienernoise=1000;
caption='TU-mask16bit16error1.01';
outpath='./animation';
inputfilename='./reconstruction/input/input_tu2.png';
outputfilename=sprintf('%s/recon2d-%s.png',outpath,caption);
outputfilenameFiltered=sprintf('%s/recon2d-filtered-%s.png',outpath,caption);
filenameSW=sprintf('%s/animationSW-%s.gif',outpath,caption);
filenameHolo=sprintf('%s/animationHolo-%s.gif',outpath,caption);

%% Prepare Input
[scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input]=prepareInput_sim(inputfilename,refRadius,refError,maskScale,sigmaMask,discreteBits);
%move to gpu
mask=gpuArray(mask);
scatterImageHolo=gpuArray(scatterImageHolo);
scatterImage=gpuArray(scatterImage);



%% use Holography and IPR
%support and start
[start,support]=holoSupport(scatterImageHolo,softmask,refImage,'threshold',.5,'debug',true);

%Plan:
planHolo=recon.plan();
for n=1:40
    planHolo.addStep('writeFrame',1,{filenameHolo,false,1280});
    planHolo.addStep('hio',50);
    planHolo.addStep('writeFrame',1,{filenameHolo,false,1280});
    planHolo.addStep('hio',49);
    planHolo.addStep('er',1);
end
planHolo.addStep('er',100);
planHolo.addStep('writeFrame',1,{filenameHolo,false,1280});

%Run
[resultHolo]=planHolo.run(scatterImageHolo,support,start,mask);


%% use IPR with Shrinkwrap
%support and start
[start,support]=genericSupport(scatterImage,softmask);

%Plan
planSW=recon.plan();

for n=1:50
    planSW.addStep('hio',45);
    planSW.addStep('errp',4);
    planSW.addStep('sw',1,{5,0.03});
    planSW.addStep('writeFrame',1,{filenameSW,false,1280});   
end
planSW.addStep('loosen',1,{5})

for n=1:15
    planSW.addStep('hio',49);
    planSW.addStep('er',1);
    planSW.addStep('writeFrame',1,{filenameSW,false,1280});
    planSW.addStep('hio',49);
    planSW.addStep('writeFrame',1,{filenameSW,false,1280});

end
planSW.addStep('er',100);
planSW.addStep('writeFrame',1,{filenameSW,false,1280});


[resultSW]=planSW.run(scatterImage,support,start,mask);

%% wiener deconvolution
%get cross correlation

[~,~,cross]=holoSupport(scatterImageHolo,softmask,refImage,'threshold',.2,'radDilate',20);
%and filtered (guessed) Reference
refImageFiltered=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));
crossPadded=pad2size(cross,size(scatterImageHolo));
refImagePadded=pad2size(refImageFiltered,size(scatterImageHolo));
%deconvolution
resultDeconv=wiener(crossPadded,refImagePadded,wienernoise);

%% plot results 
move=@(x)moveAndMirror(abs(input),abs(x));
cut=@(x)x(end/2-end/8:end/2+end/8+1,end/2-end/8:end/2+end/8+1);


f=figure();
delim=32;
pixel=512;
scale=1/2;
cmin=min(abs(input(:)));
cmax=max(abs(input(:)));
f.Position=[0,0,(2*pixel+delim),(2*pixel+delim)].*scale;
ax(1)=subplot(2,2,1);
ax(1).Units='pixels';
ax(1).Position=[0,pixel+delim,pixel,pixel].*scale;
imagesc(abs(cut(input)));
colormap(flipud(colormap(gray)))
caxis([cmin,cmax]);
axis off;
ax(1).ActivePositionProperty='position';

ax(2)=subplot(2,2,3);
ax(2).Units='pixels';
ax(2).Position=[0,0,pixel,pixel].*scale;
imagesc(abs(cut(move(resultDeconv))));
colormap(flipud(colormap(gray)))
axis off;
ax(2).ActivePositionProperty='position';

ax(3)=subplot(2,2,2);
ax(3).Units='pixels';
ax(3).Position=[pixel+delim,pixel+delim,pixel,pixel].*scale;
imagesc(abs(cut(move(resultSW))));
colormap(flipud(colormap(gray)))
caxis([max(cmin,min(abs(resultSW(:)))),min(cmax,max(abs(resultSW(:))))]);
axis off;
ax(3).ActivePositionProperty='position';

ax(4)=subplot(2,2,4);
ax(4).Units='pixels';
ax(4).Position=[pixel+delim,0,pixel,pixel].*scale;
colormap(flipud(colormap(gray)))
imagesc(abs(cut(move(resultHolo))));
caxis([max(cmin,min(abs(resultHolo(:)))),min(cmax,max(abs(resultHolo(:))))]);
axis off;
ax(4).ActivePositionProperty='position';

f.PaperUnits='inches';
f.PaperPositionMode='manual';
f.PaperPosition=[0,0,(2*pixel+delim)/150,(2*pixel+delim)/150];
f.PaperSize=[(2*pixel+delim)/150, (2*pixel+delim)/150];
f.Resize='off';
print(outputfilename,'-dpng','-r150');

%% plot results filtered
finput=maskfilter(input,softmask);
fresultSW=maskfilter(resultSW,softmask);
fresultHolo=maskfilter(resultHolo,softmask);
fresultDeconv=maskfilter(resultDeconv,softmask);

move=@(x)moveAndMirror(abs(finput),abs(x));
cut=@(x)x(end/2-end/4:end/2+end/4+1,end/2-end/4:end/2+end/4+1);


f=figure();
delim=32;
pixel=512;
scale=1/2;
cmin=min(abs(finput(:)));
cmax=max(abs(finput(:)));
f.Position=[0,0,(2*pixel+delim),(2*pixel+delim)].*scale;
ax(1)=subplot(2,2,1);
ax(1).Units='pixels';
ax(1).Position=[0,pixel+delim,pixel,pixel].*scale;
imagesc(abs(cut(finput)));
colormap(flipud(colormap(gray)))
caxis([cmin,cmax]);
axis off;
ax(1).ActivePositionProperty='position';

ax(2)=subplot(2,2,3);
ax(2).Units='pixels';
ax(2).Position=[0,0,pixel,pixel].*scale;
imagesc(abs(cut(move(fresultDeconv))));
colormap(flipud(colormap(gray)))
axis off;
ax(2).ActivePositionProperty='position';

ax(3)=subplot(2,2,2);
ax(3).Units='pixels';
ax(3).Position=[pixel+delim,pixel+delim,pixel,pixel].*scale;
imagesc(abs(cut(move(fresultSW))));
colormap(flipud(colormap(gray)))
caxis([max(cmin,min(abs(fresultSW(:)))),min(cmax,max(abs(fresultSW(:))))]);
axis off;
ax(3).ActivePositionProperty='position';

ax(4)=subplot(2,2,4);
ax(4).Units='pixels';
ax(4).Position=[pixel+delim,0,pixel,pixel].*scale;
colormap(flipud(colormap(gray)))
imagesc(abs(cut(move(fresultHolo))));
caxis([max(cmin,min(abs(fresultHolo(:)))),min(cmax,max(abs(fresultHolo(:))))]);
axis off;
ax(4).ActivePositionProperty='position';

f.PaperUnits='inches';
f.PaperPositionMode='manual';
f.PaperPosition=[0,0,(2*pixel+delim)/150,(2*pixel+delim)/150];
f.PaperSize=[(2*pixel+delim)/150, (2*pixel+delim)/150];
f.Resize='off';
print(outputfilenameFiltered,'-dpng','-r150');
