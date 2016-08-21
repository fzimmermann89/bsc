clear all;
g=gpuDevice(1);
refRadius=20;
refError=1.02;
maskScale=64/1024;%.02%.03%.1%.03%.03%.1%0.03%.1;
sigmaMask=32;%32;
discreteBits=0;%15;
useHoloSupport=true;
addRandomPhase=false;
inputfilename='./input/input_2.png';

%define reconstruction plan
plan=reconPlan();
plan.record_errors=true;
if useHoloSupport
    for n=0:40%40
        plan.addStep('hio',200);
        plan.addStep('er',1);
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

[scatterImage,refImage,mask,softmask,outermask]=prepareInput_sim(inputfilename,refRadius,refError,maskScale,sigmaMask,discreteBits);
    
%and filtered (guessed) Reference
   filteredRef=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));  


%create support
[start,support,cross]=holoSupport(scatterImage.*softmask,refImage);%filteredRef
if ~useHoloSupport
    support=abs(ift2(scatterImage.*softmask));
    support=support>max(support(:))*0.005;
    support = imdilate(support,ones(3));
    support = imfill(support, 'holes');
    start=support.*rand(size(scatterImage));
elseif addRandomPhase
    randPhase=randn(size(scatterImage));
    start=start.*exp(i*randPhase);
end

%do deconvolution
deconv=wiener(gather(pad2size(cross,size(scatterImage))),pad2size(filteredRef,size(scatterImage)),10);
filteredDeconv=maskfilter(deconv,softmask,size(deconv));



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