function [curImage,errors]=reconstruct(scatterImage,support,start,mask,plan)
  tic
    amplitude=sqrt(abs(scatterImage));
    %     amplitude=imgaussfilt(amplitude,10);
    
    curImage=gpuArray(start);
    if plan.record_errors
        errors=zeros(1,plan.iterations);
        nerror=1;
        
        for nplan=1:length(plan)
            step=plan.getStep(nplan);
            
            switch step.method
                case 'hio'
                    for niter=1:step.iterations
                        [curImage,err]=HIOiter(amplitude, curImage, support, mask );
                        figure(123);imagesc(abs(curImage+support));drawnow;
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
                    sigma=7;
                    relThreshold=0.10;
                    support=SW(curImage,relThreshold,sigma);
                    errors(nerror)=errors(nerror-1);
                    nerror=nerror+1;
                case 'show'
                    figure(5);imagesc(support); title('support');
                    figure(6);
                    subplot(2,1,1);imagesc(real(curImage));title('real cur. Image');colorbar;
                    subplot(2,1,2);imagesc(imag(curImage));title('imag cur. Image');colorbar;
                    figure(2); semilogy(errors); title('error');
                    drawnow;
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
                    sigma=7;
                    relThreshold=0.10;
                    support=SW(curImage,relThreshold,sigma);
                case 'show'
                    [~,err]=ERiter(amplitude, curImage, support, mask );
                    errors(end+1)=err;
                    figure(5);imagesc(support); title('support');
                    figure(6);
                    subplot(2,1,1);imagesc(real(curImage));title('real cur. Image');colorbar;
                    subplot(2,1,2);imagesc(imag(curImage));title('imag cur. Image');colorbar;
                    figure(2); semilogy(errors); title('error');
                    drawnow;
                otherwise
                    warning('unknown plan');
            end
            fprintf('%.1f%% done',nplan/length(plan)*100);
        end
    end
    toc
end