clear all;
g=gpuDevice(1);
refRadius=20;
refError=1.02;
maskScale=128/1024;%.02%.03%.1%.03%.03%.1%0.03%.1;
sigmaMask=32;%32;
discreteBits=0;%15;
addRandomPhase=false;
inputfilename='./input/input_2.png';
ToDo='sw'; %possible cases: ToDo='holo'; ToDo='sw'; ToDo='deconv'

%Prepare Input
[scatterImageHolo,refImage,mask,softmask,outermask,scatterImage]=prepareInput_sim(inputfilename,refRadius,refError,maskScale,sigmaMask,discreteBits);
mask=gpuArray(mask);

%and filtered (guessed) Reference
refImageFiltered=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));

%Reconstruct
switch ToDo
    case 'holo' %use Holography
        %support and start
        [start,support]=holoSupport(scatterImageHolo,softmask,refImage);
        if addRandomPhase
            randPhase=randn(size(scatterImageHolo));
            start=start.*exp(1i*randPhase);
        end
        
        %Plan:
        planHolo=reconPlan();
        planHolo.record_errors=false;
        for n=1:40%
            planHolo.addStep('hio',300);
            planHolo.addStep('er',10);
            planHolo.addStep('show');
        end
        planHolo.addStep('er',100);
        planHolo.addStep('show');
        
        %Run
        [result,errors]=reconstruct(scatterImageHolo,support,start,mask,planHolo);
        
        
    case 'sw' %use IPR with Shrinkwrap
        %support and start
        [start,support]=genericSupport(scatterImage,softmask);
        if addRandomPhase
            randPhase=randn(size(scatterImageHolo));
            start=start.*exp(1i*randPhase);
        end
        
        %Plan
        planSW=reconPlan();
        for m=1:2
            for n=1:25
                planSW.addStep('hio',100);
                planSW.addStep('errp',1);
                planSW.addStep('sw',1);
                planSW.addStep('show')
            end
            planSW.addStep('loosen')
            
        end
        planSW.addStep('loosen')
        for n=1:20
            planSW.addStep('hio',300);
            planSW.addStep('er',1);
            planSW.addStep('show')
        end
        planSW.addStep('er',100);
        planSW.addStep('show');
        
        %Run
        [result,errors]=reconstruct(scatterImage,support,start,mask,planSW);
        
        
    case 'deconv' %wiener deconvolution
        %get cross correlation
        [~,~,cross]=holoSupport(scatterImageHolo.*softmask,refImage);
        
        %deconvolution
        result=wiener(gather(pad2size(cross,size(scatterImageHolo))),pad2size(refImageFiltered,size(scatterImageHolo)),10);
        
        
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