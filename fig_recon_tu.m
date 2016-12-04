clear all;
close all;

addpath('reconstruction');
addpath('simulation');
addpath('helper');


%% settings
ldiscreteBits=[0,0,0,16,14,16,16];
lmaskScale=[0,16,64,16,16,16,16]./2048;
lrefError=[1,1,1,1,1,1.01,1.05];
lthreshold=[.45,.5,.5,.5,.5,.5,.5];
lwienernoise=[0,0,0,0,0,0,0]; %0 means find optimal
nmax=numel(ldiscreteBits);
if ~isequal(numel(ldiscreteBits),numel(lmaskScale),numel(lrefError),numel(lthreshold),numel(lwienernoise))
    error('settings must have equal size')
end    
refRadius=40;
sigmaMask=24;
fastscale=1; %setting this to a value higher than 1 reduces iterations
outpath='./Tex/images2';
inputfilename='./reconstruction/input/input_tu2.png';

for nrun=1:nmax
    %% Settings for current run
    discreteBits=ldiscreteBits(nrun);
    maskScale=lmaskScale(nrun);
    refError=lrefError(nrun);
    threshold=lthreshold(nrun);
    wienernoise=lwienernoise(nrun);
    
    caption=sprintf('mask%ibit%ierror%g',maskScale*2048,discreteBits,refError-1);
    outputfilename=sprintf('%s/recon2d-%s.png',outpath,caption);
    
    %% Prepare Input
    [scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input]=prepareInput_sim(inputfilename,refRadius,refError,maskScale,sigmaMask,discreteBits);
    
    %move to gpu
    if parallel.gpu.GPUDevice.isAvailable
        gpu=gpuDevice(1);
        mask=gpuArray(mask);
        scatterImageHolo=gpuArray(scatterImageHolo);
        scatterImage=gpuArray(scatterImage);
    end
    
    %% use Holography and IPR
    %support and start
    [start,support]=holoSupport(scatterImageHolo,softmask,refImage,'threshold',threshold,'debug',false);
    
    %Plan:
    planHolo=recon.plan();
    for n=1:ceil(90/fastscale)
        planHolo.addStep('hio',ceil(199/fastscale));
        planHolo.addStep('er',1);
    end
    planHolo.addStep('er',ceil(100/fastscale));
    %planHolo.addStep('show');
    
    %Run
    [resultHolo]=planHolo.run(scatterImageHolo,support,start,mask);
    
    
    %% use IPR with Shrinkwrap
    %support and start
    [start,support]=genericSupport(scatterImage,softmask);
    
    %Plan
    planSW=recon.plan();
    for n=1:ceil(60/fastscale)
        planSW.addStep('hio',ceil(95/fastscale));
        planSW.addStep('errp',5);
        planSW.addStep('sw',1,{5,0.025});
    end
    planSW.addStep('loosen',1,{5})
    %planSW.addStep('show')
    for n=1:ceil(60/fastscale)
        planSW.addStep('hio',ceil(199/fastscale));
        planSW.addStep('er',1);
    end
    planSW.addStep('er',ceil(100/fastscale));
    %planSW.addStep('show');
    
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
    [~,~,cross]=holoSupport(scatterImageHolo,softmask,refImage,'threshold',threshold,'radDilate',25);
    %and filtered (guessed) Reference
    refImageFiltered=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));
    crossPadded=pad2size(cross,size(scatterImageHolo));
    refImagePadded=pad2size(refImageFiltered,size(scatterImageHolo));
    
    %'cheat' for finding good wiener value if wienernoise is set to 0
    if wienernoise==0
        finput=maskfilter(gpuArray(input),softmask);
        normalize=@(in,ref) (in-min(in(:))) .* (mean(ref(:)) / (mean(in(:)-min(in(:)))) ) + min(ref(:));
        deconvt=@(w)moveAndMirror(abs(finput),normalize(abs(maskfilter(wiener(crossPadded, refImagePadded,w,[],true),softmask)),abs(finput)),true);
        mse=@(in)abs(gather(mean(((abs(finput(:)))-(in(:))).^2)));
        options = optimset('Display','off');
        r=fminsearch(@(p)mse(deconvt(p(1))),[1],options);
        wienernoise=round(r(1),2,'significant');
        lwienernoise(nrun)=wienernoise;
    end
    
    %deconvolution
    resultDeconv=wiener(crossPadded,refImagePadded,wienernoise,[],false);
    %figure;imagesc(abs(resultDeconv));colormap(flipud(colormap(gray)));caxis([0,1]);title('deconv');title(sprintf('wiener with %g',wienernoise));
    
    
    %% plot results
    finput=maskfilter(input,softmask);
    fresultSW=maskfilter(resultSW,softmask);
    fresultHolo=maskfilter(resultHolo,softmask);
    fresultDeconv=maskfilter(resultDeconv,softmask);
    
    move=@(x)moveAndMirror(finput,x);
    cut=@(x)x(end/2-end/8:end/2+end/8+1,end/2-end/8:end/2+end/8+1);
    
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
    print(outputfilename,'-dpng','-r150');
end

save(fullfile(outpath,'recon2d-params.mat'),ldiscreteBits,lmaskScale,lrefError,lthreshold,lwienernoise);