refRadius=25;
refError=1.1;
maskScale=0.03%0.03%.1;
sigma=10;
useHoloSupport=false;
%create reconstruction plan
plan=reconPlan();
% plan.addStep('hio',500);
% plan.addStep('er',500);
% for n=0:10
% plan.addStep('hio',200);
%   plan.addStep('er',1);
% end
% plan.addStep('errp',100);
%
for n=0:15
    plan.addStep('hio',200);
    plan.addStep('er',1);
    plan.addStep('sw',1);
    plan.addStep('show')
end
for n=0:15
    plan.addStep('hio',200);
    plan.addStep('er',1);
    plan.addStep('hio',200);
    plan.addStep('sw',1);
    plan.addStep('show')
end
for n=0:20
    plan.addStep('hio',200);
    plan.addStep('er',1);
%     plan.addStep('show')
end
plan.addStep('er',100);




%load image
input=double(gpuArray(rgb2gray(imread('input_2.png'))))/255;

% %create Reference
% [xx,yy]=meshgrid(-refRadius:1:refRadius);
% refImage=xx.^2+yy.^2<refRadius^2;
% input(end-2*refRadius:end,end-2*refRadius:end)=refImage;

%pad
N=size(input);
input=padarray(input,N,0);
Npadded=size(input);



%create Mask
[mask,softmask,outermask]=circularMask(Npadded,maskScale,sigma);

%create scatterImage
Finput=ft2(input);
absFinput=abs(Finput).^2;
scatterImage=absFinput.*mask;

%create support
[start,support,cross]=holoSupport(scatterImage.*softmask,refRadius*refError);
if ~useHoloSupport
    support=abs(ift2(scatterImage.*softmask))>0.05;
    support = imfill(support, 'holes');
    support = imdilate(support,ones(3));
    
    % support=padarray(support,N,0);
    start=support.*rand(size(scatterImage));
end

%do deconvolution
filteredRef=maskfilter(refImage,softmask,size(cross));
deconv=deconvwnr(gather(cross),filteredRef,10);
filteredDeconv=maskfilter(deconv,softmask,size(deconv));

%initialize
amplitude=sqrt(scatterImage);

randPhase=rand(size(scatterImage));
curImage=start.*exp(2i*pi*randPhase);
errors=zeros(1,plan.iterations);

nerror=1;
tic
for nplan=1:length(plan)
    
    step=plan.getStep(nplan);
    switch step.method
        case 'hio'
            for niter=1:step.iterations
                [curImage,err]=HIOiter(amplitude, curImage, support, mask );
                errors(nerror)=err;
                nerror=nerror+1;
                
            end
        case 'er'
            for niter=1:step.iterations
                [curImage,err]=ERiter(amplitude, curImage, support, mask);
                errors(nerror)=err;
                nerror=nerror+1;
                
            end
        case 'errp'
            %CAVE: support needs to be placed the same way as image
            for niter=1:step.iterations
                [curImage,err]=ERiterRealPos(amplitude, curImage, support, mask);
                errors(nerror)=err;
                nerror=nerror+1;
            end
        case 'sw'
            sigma=10;
            relThreshold=1;
            support=SW(curImage,relThreshold,sigma);
            errors(nerror)=errors(nerror-1);
            nerror=nerror+1;
        case 'show'
            fprintf('%.2f%% done, error:%.2f\n',nplan/length(plan)*100,errors(nerror-1));
            figure(5);imagesc(support); title('support');
            figure(6);imagesc(abs(curImage));title('cur. Image')
            figure(2); plot(errors); title('error');
        otherwise
            warning('unknown plan');
    end
    
    drawnow;
end
toc
%     % curImage=support;
%     %run ER
%     errors=zeros(iter/rec);
%     for n=1:1:hioiter
%         [curImage,err]=HIOiter(amplitude, curImage, support );
%         if mod(n,rec)==0
%             errors(n/rec)=err;
%             fprintf('%f\n',err);
%         end
%     end
%     for n=hioiter+1:iter
%
%         if mod(n,rec)==0
%             [curImage,err]=ERiter(amplitude, curImage, support );
%             errors(n/rec)=err;
%             fprintf('%f\n',err);
%
%         else
%             curImage=ERiter(amplitude, curImage, support );
%         end
%     end
%



figure(1)
subplot(3,2,1);imagesc(log(scatterImage));axis square;colormap(flipud(gray));title('scatterImage');
subplot(3,2,2);imagesc(abs(ift2(scatterImage)));axis square;colormap(flipud(gray));caxis([0,100]),title('holo');
subplot(3,2,3);imagesc(support);axis square;colormap(flipud(gray));title('support');
subplot(3,2,4);imagesc(start);axis square;colormap(flipud(gray));title('start');
subplot(3,2,5);imagesc(abs(curImage));axis square;colormap(flipud(gray));title('final');
subplot(3,2,6);imagesc(abs(deconv));axis square;colormap(flipud(gray));title('deconv');

figure(2)
semilogy(errors);
