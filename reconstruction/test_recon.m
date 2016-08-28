clear all;
g=gpuDevice(1);
refRadius=20;
refError=1.02;
maskScale=0/1024;%.02%.03%.1%.03%.03%.1%0.03%.1;
sigmaMask=32;%32;
discreteBits=0;%15;
inputfilename='./input/input_2.png';
ToDo='holo'; %possible cases: ToDo='holo'; ToDo='sw'; ToDo='deconv'

%Prepare Input
[scatterImageHolo,refImage,mask,softmask,outermask,scatterImage]=prepareInput_sim(inputfilename,refRadius,refError,maskScale,sigmaMask,discreteBits);
mask=gpuArray(mask);


%Reconstruct
switch ToDo
    case 'holo' %use Holography
        %support and start
        [start,support]=holoSupport(scatterImageHolo,softmask,refImage);
        
        %Plan:
        planHolo=recon.plan();
        for n=1:40
            planHolo.addStep('hio',300);
            planHolo.addStep('er',1);
            planHolo.addStep('show');
        end
        planHolo.addStep('er',100);
        planHolo.addStep('show');
        
        %Run
        [result,errors]=planHolo.run(scatterImageHolo,support,start,mask);
        
        
    case 'sw' %use IPR with Shrinkwrap
        %support and start
        [initialstart,support]=genericSupport(scatterImage,softmask);
        
        for n=1:5
            start(:,:,n)=ift2(ft2(initialstart).*exp(2i*pi*rand(size(initialstart))).*softmask);
        end
        
        %Plan
        planSW=recon.plan();
        
        for n=1:50
            planSW.addStep('hio',45);
            planSW.addStep('errp',5);
            planSW.addStep('sw',1,[4,0.08]);
        end
        planSW.addStep('loosen',1,5)
        planSW.addStep('show')
        
        for n=1:50
            planSW.addStep('hio',150);
            planSW.addStep('er',1);
        end
        planSW.addStep('er',50);
        planSW.addStep('show');
        
        %Run
        [result,images]=planSW.runAvg(scatterImage,support,start,mask);
        %[avg,images,errors]=planSW.runAvg(scatterImage,support,start,mask);
        
        
    case 'deconv' %wiener deconvolution
        %get cross correlation
        [~,~,cross]=holoSupport(scatterImageHolo,softmask,refImage);
        %and filtered (guessed) Reference
        refImageFiltered=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));
        crossPadded=pad2size(cross,size(scatterImageHolo));
        refImagePadded=pad2size(refImageFiltered,size(scatterImageHolo));
        %deconvolution
        result=wiener(crossPadded,refImagePadded,10);
        
        
    otherwise
        error('set ToDo');
end

filteredResult=maskfilter(result,softmask,size(result));

%plot results
figure(1)
subplot(2,1,1);imagesc(abs(result));
subplot(2,1,2);imagesc(abs(filteredResult));

if exist('errors','var')
    figure(2)
    semilogy(errors);
end