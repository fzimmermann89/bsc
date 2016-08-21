function [curImage,errors]=reconstruct(scatterImage,support,start,mask,plan)
    t=tic;
    amplitude=gpuArray(sqrt(abs(scatterImage)));
    curImage=gpuArray(start);
    sigma=3;
    relThreshold=.3;
    
    if plan.record_errors
        errors=zeros(1,plan.iterations);
        nerror=1;
        for nplan=1:length(plan)
            step=plan.getStep(nplan);
            
            switch step.method
                case 'hio'
                    for niter=1:step.iterations
                        [curImage,err]=HIOiter(amplitude, curImage, support, mask );
                        errors(nerror)=err;
                        nerror=nerror+1;
                    end
                case 'raar'
                    for niter=1:step.iterations
                        [curImage,err]=RAARiter(amplitude, curImage, support, mask );
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
                    support=SW(curImage,relThreshold,sigma);
                    support=imfill(support,'holes');
                    fprintf('support area:%g\n',sum(support(:)));
                    errors(nerror)=errors(nerror-1);
                    nerror=nerror+1;
                case 'show'
                    figure(5);imagesc(abs(curImage+support)); title('support');
                    fprintf('support area:%g\n',sum(support(:)));
                    figure(6);
                    subplot(2,1,1);imagesc(real(curImage));title('real cur. Image');colorbar;
                    subplot(2,1,2);imagesc(imag(curImage));title('imag cur. Image');colorbar;
                    figure(2); semilogy(errors); title('error');
                    drawnow;
                case 'loosen'
                    support=imfill(support,'holes');
                    support=imdilate(support,strel('disk',25));
                otherwise
                    warning('unknown plan');
            end
            fprintf('%.1f%% done, error:%.2f\n',nplan/length(plan)*100,errors(nerror-1));
        end
    else
        errors=[];
        for nplan=1:length(plan)
            step=plan.getStep(nplan);
            switch step.method
                case 'hio'
                    for niter=1:step.iterations
                        curImage=HIOiter(amplitude, curImage, support, mask );
                    end
                case 'raar'
                    for niter=1:step.iterations
                        curImage=RAARiter(amplitude, curImage, support, mask );
                    end
                case 'er'
                    for niter=1:step.iterations
                        curImage=ERiter(amplitude, curImage, support, mask);
                    end
                case 'errp'
                    %CAVE: support needs to be placed the same way as image
                    for niter=1:step.iterations
                        curImage=ERiterRealPos(amplitude, curImage, support, mask);
                    end
                case 'sw'
                    support=SW(curImage,relThreshold,sigma);
                    support=imfill(support,'holes');
                case 'show'
                    [~,err]=ERiter(amplitude, curImage, support, mask );
                    errors(end+1)=err;
                    fprintf('support area:%g error: %g\n',sum(support(:)),err);
                case 'loosen'
                    support=imfill(support,'holes');
                    support=imdilate(support,strel('disk',25));
                otherwise
                    warning('unknown plan');
            end
            fprintf('%.1f%% done\n',nplan/length(plan)*100);
        end
    end
    
    
    toc(t);
end