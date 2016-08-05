refRadius=25;
refError=1.1;
maskScale=0.03%.03%.03%.1%0.03%.1;
sigmaMask=15;
useHoloSupport=true;
%create reconstruction plan
plan=reconPlan();

if useHoloSupport
    for n=0:40
        plan.addStep('hio',150);
        plan.addStep('er',1);
%         plan.addStep('show');
    end
    plan.addStep('er',100);

else
    for n=0:50
        plan.addStep('hio',75);
        plan.addStep('er',24);
        plan.addStep('sw',1);
        plan.addStep('show')
    end
    for n=0:15
        plan.addStep('hio',199);
        plan.addStep('er',1);
        plan.addStep('show')
    end
    plan.addStep('er',100);
    plan.addStep('show')
end


%load image
input=double(gpuArray(rgb2gray(imread('input_2.png'))))/255;

%create Reference
[xx,yy]=meshgrid(-refRadius:1:refRadius);
refImage=xx.^2+yy.^2<refRadius^2;
input(end-2*refRadius:end,end-2*refRadius:end)=refImage;

%pad
N=size(input);
input=padarray(input,(3/2)*N,0);
Npadded=size(input);

%create mask
[ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);


%create scatterImage
Finput=ft2(input);
absFinput=abs(Finput).^2;
scatterImage=absFinput.*mask;

%and filtered Reference
filteredRef=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));

%create support
[start,support,cross]=holoSupport(scatterImage.*softmask,filteredRef);
if ~useHoloSupport
    support=abs(ift2(scatterImage.*softmask));
    support=support>max(support(:))*0.005;
    support = imdilate(support,ones(3));
    support = imfill(support, 'holes');
    start=support.*rand(size(scatterImage));
end

%do deconvolution
wnrdeconv=deconvwnr(gather(pad2size(cross,size(scatterImage))),real(filteredRef),10);
wienerdeconv=wiener(gather(pad2size(cross,size(scatterImage))),pad2size(filteredRef,size(scatterImage)),10);

filteredDeconv=maskfilter(wnrdeconv,softmask,size(wnrdeconv));

figure(1)
subplot(3,2,1);imagesc(abs(filteredRef));axis square;colormap(flipud(gray));title('filteredRef');
subplot(3,2,2);imagesc(log(scatterImage));axis square;colormap(flipud(gray));title('scatterImage');
subplot(3,2,3);imagesc(abs(ift2(scatterImage)));axis square;colormap(flipud(gray));caxis([0,100]),title('holo');

subplot(3,2,4);imagesc(abs(start));axis square;colormap(flipud(gray));title('start');
subplot(3,2,5);imagesc(abs(wienerdeconv));axis square;colormap(flipud(gray));title('wiener');
subplot(3,2,6);imagesc(abs(wnrdeconv));axis square;colormap(flipud(gray));title('deconvwnr');

