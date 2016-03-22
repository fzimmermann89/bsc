g=gpuDevice(1);
clear all;
refRadius=100;
refError=1.05;
maskScale=7/2048%.02%.03%.1%.03%.03%.1%0.03%.1;
sigmaMask=32;
bitsADC=15;
useHoloSupport=true;
discretizeAndNoise=false;
addRandomPhase=true;
%create reconstruction plan
plan=reconPlan();
if useHoloSupport
%         for n=1:5
%             plan.addStep('raar',50);
%             plan.addStep('show');
%         end

%  plan.addStep('raar',50');
%         plan.addStep('show');

    for n=0:100%40
        plan.addStep('hio',200);%150 hio
%         plan.addStep('show');
        plan.addStep('er',1);
%         plan.addStep('show');
    end
%     plan.addStep('er',100);
%       for n=0:50%40
%         plan.addStep('hio',150);%150 hio
% %         plan.addStep('show');
%         plan.addStep('er',1);
%         plan.addStep('show');
%     end
    plan.addStep('er',500);
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

% %load image
% input=double(gpuArray(rgb2gray(imread('input_2.png'))))/255;
% %create real Reference
% [xx,yy]=meshgrid(-refRadius:1:refRadius);
% realRefImage=xx.^2+yy.^2<refRadius^2;
% input(end-2*refRadius:end,end-2*refRadius:end)=realRefImage;
%

%pad

load('exitwave.mat');
input=exitwave;
N=size(input);
% input=input-input(end,end);
% input=padarray(input,(1/2)*N,gather(input(end,end)));
% input=padarray(input,(1/2)*N,0);
Npadded=size(input);

%create mask
[ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);

%create scatterImage
Finput=ft2(input);
scatterImage=abs(Finput).^2;


%mask
scatterImage=scatterImage.*mask;

%discretize
if (discretizeAndNoise)
    figure(10);subplot(3,1,1);imagesc(scatterImage);title('cont.&wo noise');

    dynamicRange=max(scatterImage(:))-min(scatterImage(scatterImage~=0))
    rangePerBit=dynamicRange./2^bitsADC;
    scatterImage=uint16(round(scatterImage./rangePerBit));
    figure(10);subplot(3,1,2);imagesc(scatterImage);title('disc.&wo noise');

    scatterImage=double(imnoise(scatterImage,'poisson'));
    figure(10);subplot(3,1,3);imagesc(scatterImage);title('disc.&poisson noise');
end
%create guessed Reference
[xx,yy]=meshgrid(-refRadius*refError:1:refRadius*refError);
refImage=xx.^2+yy.^2<(refRadius*refError)^2;

%and filtered (guessed) Reference
filteredRef=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));

%create support
[start,support,cross]=holoSupport(scatterImage.*softmask,filteredRef);
if ~useHoloSupport
    support=abs(ift2(scatterImage.*softmask));
    support=support>max(support(:))*0.005;
    support = imdilate(support,ones(3));
    support = imfill(support, 'holes');
    start=support.*rand(size(scatterImage));
elseif addRandomPhase
    randPhase=randn(size(scatterImage));
    start=start.*exp(1i*randPhase);
end

%do deconvolution
deconv=wiener(gather(pad2size(cross,size(scatterImage))),pad2size(filteredRef,size(scatterImage)),10);
filteredDeconv=maskfilter(deconv,softmask,size(deconv));


input=gather(input);
Finput=gather(Finput);
start=gather(start);
mask=gpuArray(mask);
%do reconstruction
[curImage,errors]=reconstruct(scatterImage,support,start,mask,plan);

%plot results
figure(1)
subplot(3,2,1);imagesc(log(scatterImage));axis square;colormap(flipud(gray));title('scatterImage');
subplot(3,2,2);imagesc(abs(ift2(scatterImage)));axis square;colormap(flipud(gray));caxis([0,100]),title('holo');
subplot(3,2,3);imagesc(support);axis square;colormap(flipud(gray));title('support');
subplot(3,2,4);imagesc(real(start));axis square;colormap(flipud(gray));title('start');
subplot(3,2,5);imagesc(abs(curImage));axis square;colormap(flipud(gray));title('final');
subplot(3,2,6);imagesc(abs(deconv));axis square;colormap(flipud(gray));title('deconv');

figure(2)
semilogy(errors);