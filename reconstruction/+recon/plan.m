classdef plan<handle
    % Plan for phase retrieval
    % Used for storing the sequence of iterations and exexuting them
    
    properties
        steps=struct('method',{},'iterations',{},'parameters',{});
        iterations=0;
        defaultSWSigma=4;
        defaultSWrelThreshold=0.05;
        defaultLoosenVal=15;
        iterFunctions=containers.Map({'hio','er','errp','raar'},{@recon.iterations.HIO,@recon.iterations.ER,@recon.iterations.ERRealPos,@recon.iterations.RAAR})
    end
    
    methods
        function addStep(this,method,iterations,parameters)
            %Add a Step to the plan
 
            step.method=method;
            
            if exist('iterations','var')&&~isempty(iterations)
                step.iterations=iterations;
            else %default
                step.iterations=1;
            end
            
            if exist('parameters','var')&&~isempty(parameters)
                if iscell(parameters)
                    step.parameters=parameters;
                else
                    step.parameters={parameters};
                end
            else %default
                step.parameters={};
            end
            
            this.steps(end+1)=step;
            this.iterations=this.iterations+step.iterations;
        end
        
        function step=getStep(this,n)
            if n<=length(this.steps)
                step=this.steps(n);
            else
                step=false;
            end
        end
        
        function out=length(this)
            out=length(this.steps);
        end
        
        function [reconImage,errors]=run(this,scatterImage,support,start,mask)
            % Run the recovery using the added Steps
            
            reconImage=zeros(size(start));
            amplitude=sqrt(abs(scatterImage));
            calcErrors=(nargout>1);
            
            if calcErrors
                errors=zeros(this.iterations,size(start,3));
            end
            
            if isa(scatterImage,'gpuArray')||isa(support,'gpuArray')||isa(mask,'gpuArray')||isa(start,'gpuArray')
                amplitude=gpuArray(amplitude);
                support=gpuArray(support);
                mask=gpuArray(mask);
            end
            for nstart=1:size(start,3)
                curImage=zeros(size(amplitude),'like',amplitude)+start(:,:,nstart);
                curSupport=support;
                if calcErrors % calculate real space error
                    curErrors=zeros(this.iterations,1);
                    nerror=1;
                end
                
                for nplan=1:length(this)
                    step=this.getStep(nplan);
                    
                    if this.iterFunctions.isKey(step.method)
                        % Run those function that are listed in iterFunctions
                        iterFunc=this.iterFunctions(step.method);
                        if calcErrors
                            for niter=1:step.iterations
                                [curImage,err]=iterFunc(amplitude, curImage, curSupport, mask );
                                curErrors(nerror)=err;
                                nerror=nerror+1;
                            end
                        else
                            for niter=1:step.iterations
                                curImage=iterFunc(amplitude, curImage, curSupport, mask );
                            end
                        end
                    else
                        % Run the other steps not listed in iterFunctions
                        if calcErrors
                            curErrors(nerror)=curErrors(nerror-1);
                            nerror=nerror+1;
                        end
                        switch step.method
                            case 'sw' %Shrinkwrap
                                if length(step.parameters)==2&&isscalar(step.parameters{1})&&isscalar(step.parameters{2})
                                    sigma=step.parameters{1};
                                    relThreshold=step.parameters{2};
                                else
                                    sigma=this.defaultSWSigma;
                                    relThreshold=this.defaultSWrelThreshold;
                                end
                                
                                curSupport=recon.SW(curImage,relThreshold,sigma);
                                curSupport=imfill(curSupport,'holes');
                                
                            case 'loosen' %Loosen support
                                if length(step.parameters)==1&&isscalar(step.parameters{1})
                                    value=step.parameters{1};
                                else
                                    value=this.defaultLoosenVal;
                                end
                                
                                curSupport=imfill(curSupport,'holes');
                                curSupport=imdilate(curSupport,strel('disk',value));
                                
                            case 'noise' %Add Noise
                                curImage=curImage+0.1*randn(size(curImage))./max(curImage(:));
                                
                            case 'untwin' 
                                % temporarily half the support and run HIO to solve twin image issue
                                iterFunc=this.iterFunctions('hio');
                                halfSupport=halfdiag(curSupport);
                                for niter=1:step.iterations
                                    curImage=iterFunc(amplitude, curImage, halfSupport, mask );
                                end
                            case 'show' % Show current progress
                                if numel(step.parameters)&&step.parameters{1}~=0
                                    figure(step.parameters{1})
                                else
                                    if ~exist('f','var');f=figure();end
                                    figure(f);
                                end
                                subplot(2,2,1);imagesc(real(curImage)); title('real cur. Image'); colorbar; axis square;
                                subplot(2,2,2);imagesc(imag(curImage)); title('imag cur. Image'); colorbar; axis square;
                                subplot(2,2,3);imagesc(abs(curSupport)); title('support'); axis square;
                                if calcErrors %Show errors if calculated
                                    subplot(2,2,4); semilogy(curErrors); title('error');
                                else
                                    subplot(2,2,4);imagesc(abs(curImage)); title('abs cur Image');axis square;
                                end;
                                
                                colormap(flipud(colormap(gray)));
                                drawnow;
                                
                            case 'writeFrame' %Write an animated gif frame
                                % filename
                                if length(step.parameters)>=1&&ischar(step.parameters{1})
                                    filename=step.parameters{1};
                                else % default
                                    filename='animation.gif';
                                end
                                
                                im=curImage;
                                % ER
                                if (length(step.parameters)>=2&&isscalar(step.parameters{2})&&step.parameters{2})
                                    for n=1:20;im=recon.iterations.ER(amplitude, im, curSupport,mask );end
                                end
                                
                                
                                % cut
                                if (length(step.parameters)>=3&&isscalar(step.parameters{3})&&all(step.parameters{3}<=size(im)))
                                    im=im(end/2-step.parameters{3}/2+1:end/2+step.parameters{3}/2,end/2-step.parameters{3}/2+1:end/2+step.parameters{3}/2);
                                end
                                
                                % scale
                                im=abs(im);
                                im=im-min(im(:));
                                im=uint8(gather(floor(im./max(im(:))*255)));
                                
                                % write file
                                cm=flipud(gray(256));
                                if ~exist('framewritten','var')
                                    % First frame
                                    imwrite(im,cm,filename,'gif', 'Loopcount',0,'DelayTime',1);
                                    framewritten=true;
                                else % other frames
                                    imwrite(im,cm,filename,'gif','WriteMode','append','DelayTime',.2);
                                end
                                figure(999);
                                subplot(2,1,1);imagesc(im);colormap(cm);
                                subplot(2,1,2);imagesc(curSupport);drawnow;
                            otherwise
                                warning('unknown step');
                        end
                    end
                    if size(start,3)==1 
                        % output progress if doing only one image
                        if (calcErrors)
                            fprintf('%.1f%% done, error:%.2f\n',nplan/length(this)*100,curErrors(nerror-1))
                        else
                            fprintf('%.1f%% done\n',nplan/length(this)*100)
                        end
                    end
                end
                % cleanup
                fprintf('%.1f%% done\n',nstart/size(start,3)*100);
                reconImage(:,:,nstart)=gather(curImage);
                if calcErrors;errors(:,nstart)=gather(curErrors);end
            end
        end
        
        
        function [avg,recons,errors]=runAvg(this,scatterImage,support,start,mask,useOnlyBest)
            % Run and average with multiple start images
            
            % Should all results be used ore only the best
            if nargin<6;useOnlyBest=false;end
            calcErrors=(nargout>2||useOnlyBest);
            
            if calcErrors
                [recons,errors]=this.run(scatterImage,support,start,mask);
            else
                recons=this.run(scatterImage,support,start,mask);
            end
            
            if useOnlyBest
                [sortedFinalErrors,ids]=sort(errors(end,:));
                ids=ids(1:useOnlyBest);
            else
                ids=1:size(start,3);
            end
            
            avg=recons(:,:,ids(1));
            ref = imref2d(size(avg));
            
            for n=2:length(ids)
                %direct or twin?
                cur=recons(:,:,n);
                direct=max(max(abs(ift2(ft2(avg).*conj(ft2(cur))))));
                twin=max(max(abs(ift2(ft2(avg).*conj(ft2(rot90(conj(cur),2)))))));
                if twin>direct
                    cur=rot90(conj(cur),2);
                end
                
                %translation
                transform=imregcorr(abs(cur),abs(avg),'translation');
                transformed = imwarp(cur,transform,'OutputView',ref);
                avg=avg+transformed;
                
            end
            avg=avg/length(ids);
        end
    end
end