clear all;
g=gpuDevice(1);
refRadius=40;
refError=1.05;
maskScale=32/2048;%32%64 %.02%.03%.1%.03%.03%.1%0.03%.1;
sigmaMask=24;%32;
discreteBits=15;%15;
inputfilename='./input/input_tu2.png';
ToDo='deconv'; %possible cases: ToDo='holo'; ToDo='sw'; ToDo='deconv'


%Prepare Input
[scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input]=prepareInput_sim(inputfilename,refRadius,refError,maskScale,sigmaMask,discreteBits);
%move to gpu
mask=gpuArray(mask);
scatterImageHolo=gpuArray(scatterImageHolo);
scatterImage=gpuArray(scatterImage);


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
            %planHolo.addStep('sw',1,[8,0.01]);
            planHolo.addStep('show');
        end
        planHolo.addStep('er',50);
        planHolo.addStep('show');
        
        %Run
        [result,errors]=planHolo.run(scatterImageHolo,support,start,mask);
        
        
    case 'sw' %use IPR with Shrinkwrap
        %support and start
        [start,support]=genericSupport(scatterImage,softmask);
        
        
        
        %Plan
        planSW=recon.plan();
        
        for n=1:60
            planSW.addStep('hio',95);
            planSW.addStep('errp',5);
            planSW.addStep('sw',1,[5,0.05]);
            planSW.addStep('show')
        end
        
        planSW.addStep('loosen',1,10)
        planSW.addStep('show')
        
        %         for n=1:30
        %             planSW.addStep('errp',5);
        %             planSW.addStep('hio',95);
        %             planSW.addStep('sw',1,[8,0.075]);
        %             planSW.addStep('show')
        %         end
        %
        %         planSW.addStep('errp',20);
        %         planSW.addStep('sw',1,[5,0.05]);
        %         planSW.addStep('loosen',1,10)
        %         planSW.addStep('show')
        
        for n=1:20
            planSW.addStep('hio',300);
            planSW.addStep('er',1);
            planSW.addStep('show');
        end
        planSW.addStep('er',50);
        planSW.addStep('show');
        
        %Run
        %         multi=10;
        %         multistart=zeros([size(start),multi]);
        %         for n=1:multi
        %             multistart(:,:,n)=gather(ift2(ft2(start).*exp(2i*pi*rand(size(start))).*softmask));
        %         end
        %         [result,images,errors]=planSW.runAvg(scatterImage,support,multistart,mask,ceil(multi/2));
        [result,images]=planSW.run(scatterImage,support,start,mask);
        
        
    case 'deconv' %wiener deconvolution
        %get cross correlation
        [~,~,cross]=holoSupport(scatterImageHolo,softmask,refImage);
        %and filtered (guessed) Reference
        refImageFiltered=maskfilter(refImage,softmask,2.^nextpow2(size(refImage)*4));
        crossPadded=pad2size(cross,size(scatterImageHolo));
        refImagePadded=pad2size(refImageFiltered,size(scatterImageHolo));
        %deconvolution
        result=wiener(crossPadded,refImagePadded,100);
        
        
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