
function run=singlerun2(N,dx,dz,wavelength,objects,simabs)
    % runs all algorithms for a single set of parameters
    %% setup
    padhalf=true;
    padcut=false;
    maxangle=20;
    minangle=1;
    
    tic
    run=storage.run2(N,dx,dz,wavelength,objects);
    try
        gpu=parallel.gpu.GPUDevice.isAvailable;
        g=gpuDevice();
        reset(g);
    catch
        gpu=false;
    end
    
    angles=anglemap(N,dx,wavelength)/pi*180;
    
    run.scatter_scale=angles;
    run.profile_scale=angles(end/2+1:end,end/2+1);
    run.exitwave_scale=((-N/2:N/2-1)*dx);
    
    
    
    
    %% mie
    imie=gpuArray(mie_scatter(wavelength,objects{1}.radius,objects{1}.beta,objects{1}.delta,2*N,dx));
    imie=normalize2(imie);
    imie=halfimage(imie);
    [~,pmie]=rprofil(imie,length(imie)/2);
    run.mie=gather(imie);
    run.profile_mie=gather(pmie);
    clear pmie;
    
    %% ft projection
%     exitwave=exp(2i*pi*dx/wavelength*scatterObjects.projection(objects,N,dx,gpu)); %absorption
   exitwave=scatterObjects.projection(objects,N,dx,gpu); %direct projection
%   exitwave=scatterObjects.projection(objects,N,dx,gpu)~=0; % outline

    name='FTproj';
    run=addtorun(run,name,exitwave);
    clear exitwave;
%     if gpu;wait(g);end;
    
    %% multislice
    exitwave=(multislice(wavelength,objects,N,dx,dz,gpu,false));
    name='multislice';
    run=addtorun(run,name,exitwave);
    clear exitwave;
%     if gpu;wait(g);end;
    
    %% thibault
    exitwave=(thibault(wavelength,objects,N,dx,dz,gpu));
    name='thibault';
    run=addtorun(run,name,exitwave);
    clear exitwave;
%     if gpu;wait(g);end;
    
    %% msft
    msft=(msft2(wavelength,objects,N,dx,dz,gpu,simabs));
    exitwave=ift2(msft/(dx^2));
    clear msft;
    name='msft';
    run=addtorun(run,name,exitwave);
    clear exitwave;
%     if gpu;wait(g);end;
    
    %% status
    err=structfun(@(x)median(abs(x(angles>minangle&angles<maxangle))),run.error_rel,'UniformOutput',false);
    fprintf('\n Done with b%.2e, d%.2e, rad%g (N%g, dx%g, dz%g) Time: %gs. Median Errors:\n',objects{1}.beta,objects{1}.delta,objects{1}.radius,N,dx,dz,toc);
    disp(struct2table(err));
    fprintf('\n\n');
    
    %% helper functions
    function run=addtorun(run,name,exitwave)
        %exitwave=gather(exitwave);
       
        scatter=exitwave2scatter(exitwave,dx,wavelength,padhalf,padcut,angles);
        scatter=icorrectoffsetspan2(scatter,imie,angles>minangle&angles<maxangle/2);
        
        error_abs=scatter-imie;
        error_rel=(error_abs)./imie;
        [~,rerror_abs]=rprofil(error_abs,N/2);
        [~,rerror_rel]=rprofil(error_rel,N/2);
        [~,rscatter]=rprofil(scatter,N/2);
        
        run.exitwave.(name)=gather(exitwave);
        run.scatter.(name)=gather(scatter);
        run.error_rel.(name)=gather(error_rel);
        run.error_abs.(name)=gather(error_abs);
        run.profile_error_rel.(name)=gather(rerror_rel);
        run.profile_error_abs.(name)=gather(rerror_abs);
        run.profile_scatter.(name)=gather(rscatter);
        clear scatter error_abs error_rel rerror_rel rerror_abs rscatter
        if gpu;wait(g);end;
    end
    
end