%%%%% Supp = [Rsupport Csupport Hsupport] %%%%%
function [R3D_best Min_errorF] = HIO3D(F3D,Supp,HIO_iteration,showimage)

[Rsize,Csize,Hsize] = size(F3D);

Rcenter = (Rsize+1)/2;
Ccenter = (Csize+1)/2;
Hcenter = (Hsize+1)/2;

Rsupport = Supp(1);
Csupport = Supp(2);
Hsupport = Supp(3);
half_Rsupport = (Rsupport-1)/2;
half_Csupport = (Csupport-1)/2;
half_Hsupport = (Hsupport-1)/2;

stopper = find(F3D==-1);

iteration_times = HIO_iteration;

Rtemp = zeros(Rsize,Csize,Hsize);
Rtemp(Rcenter-half_Rsupport:Rcenter+half_Rsupport,Ccenter-half_Csupport:Ccenter+half_Csupport,Hcenter-half_Hsupport:Hcenter+half_Hsupport) = 1;
loose_support = find(Rtemp==1);

rand('state',sum(100*clock));
phase_angle = rand(Rsize,Csize,Hsize); 
k_space = F3D.*exp(i*phase_angle);

clear Rtemp;

buffer_r_space = real(ifftn(ifftshift(k_space)));
    
Min_errorF = 100;   
para = 0.9;
if showimage==1   
    figure(9999)
    load UCLAsample.mat
    subplot(241),imagesc(UCLAsample(:,:,1)); axis image; colorbar;
    subplot(242),imagesc(UCLAsample(:,:,3)); axis image; colorbar
    subplot(243),imagesc(UCLAsample(:,:,5)); axis image; colorbar  
    subplot(244),imagesc(UCLAsample(:,:,7)); axis image; colorbar  
end
for iteration = 1:iteration_times

    if iteration<=HIO_iteration
        
        r_space = real(ifftn(ifftshift(k_space)));       
        sample = r_space(loose_support);
        r_space = buffer_r_space - para*r_space;
        buffer_sample = buffer_r_space(loose_support);
        sample(real(sample)<0) = buffer_sample(real(sample)<0) - para*sample(real(sample)<0);    
        r_space(loose_support) = sample;

        buffer_r_space = r_space;
        k_space = fftshift(fftn(r_space));       
        phase_angle = angle(k_space);
  
        stopper_k_space = k_space(stopper);    
        k_space = F3D.*exp(i*phase_angle);   
        k_space(stopper) = stopper_k_space;   
        
        if showimage==1
            Rinside = r_space(Rcenter-half_Rsupport:Rcenter+half_Rsupport,Ccenter-half_Csupport:Ccenter+half_Csupport,Hcenter-half_Hsupport:Hcenter+half_Hsupport);            
            subplot(245),imagesc(Rinside(:,:,1)); axis image; colorbar; title(iteration)
            subplot(246),imagesc(Rinside(:,:,3)); axis image; colorbar
            subplot(247),imagesc(Rinside(:,:,5)); axis image; colorbar  
            subplot(248),imagesc(Rinside(:,:,7)); axis image; colorbar  
            drawnow
        end
                   
        %%%%% Calculate errorF    
        if rem(iteration,10)==0
            Ktemp = zeros(Rsize,Csize,Hsize);
            Ktemp(loose_support) = abs(sample);
            Ktemp = abs(fftshift(fftn(Ktemp)));
            errorF = sum(sum(abs(Ktemp(F3D~=-1)-F3D(F3D~=-1)))) / sum(sum(F3D(F3D~=-1)));
            if errorF<Min_errorF
                Min_errorF = errorF;
                R3D_best = single(r_space(Rcenter-half_Rsupport:Rcenter+half_Rsupport,Ccenter-half_Csupport:Ccenter+half_Csupport,Hcenter-half_Hsupport:Hcenter+half_Hsupport));
            end
        end
        %%%%%
        %%%%% Save best result
        if rem(iteration,100)==0
            save R3D_BEST_HIO.mat R3D_best;
        end
        %%%%%
    end
    %%%%%
end 
