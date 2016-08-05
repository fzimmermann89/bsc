
function run=singlerun2(N,dx,dz,wavelength,objects)
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
    catch
        gpu=false;
    end
    
    angles=anglemap(N,dx,wavelength)/pi*180;
    
    run.scatter_scale=angles;
    run.profile_scale=angles(end/2+1:end,end/2+1);
    run.exitwave_scale=((-N/2:N/2-1)*dx);
    
    
    
    
    %% mie
    imie=mie_scatter(wavelength,objects{1}.radius,objects{1}.beta,objects{1}.delta,2*N,dx);
    imie=normalize2(imie);
    imie=halfimage(imie);
    [~,pmie]=rprofil(imie,length(imie)/2);
    run.mie=imie;
    run.profile_mie=pmie;
    
    %% ft projection
    exitwave=(abs(scatterObjects.projection(objects,N,dx,gpu)));
    name='FTproj';
    run=addtorun(run,name,exitwave);
    clear exitwave;
    
    %% multislice
    exitwave=(multislice(wavelength,objects,N,dx,dz,gpu,false));
    name='multislice';
    run=addtorun(run,name,exitwave);
    clear exitwave;
    
    %% thibault
    exitwave=(thibault(wavelength,objects,N,dx,dz,gpu));
    name='thibault';
    run=addtorun(run,name,exitwave);
    clear exitwave;
    
    %% msft
    msft=(msft2(wavelength,objects,N,dx,dz,gpu));
    exitwave=ift2(msft/(dx^2));
    clear msft;
    name='msft';
    run=addtorun(run,name,exitwave);
    clear exitwave;
    
    
    
    err=structfun(@(x)median(abs(x(angles>minangle&angles<maxangle))),run.error,'UniformOutput',false);
    fprintf('\n \n Done with N%g, dx%g, dz%g. Time: %gs. Median Errors:\n',N,dx,dz,toc);
    disp(struct2table(err));
    
    %% helper functions
    function run=addtorun(run,name,exitwave)
        scatter=exitwave2scatter(exitwave,dx,wavelength,padhalf,padcut,angles);
        scatter=icorrectoffsetspan(scatter,imie,angles>minangle&angles<maxangle/2);
        error=(scatter-imie)./imie;
        [~,rerror]=rprofil(error,N/2);
        [~,rscatter]=rprofil(scatter,N/2);
        run.scatter.(name)=scatter;
        run.error.(name)=error;
        run.profile_error.(name)=rerror;
        run.profile_scatter.(name)=rscatter;
    end
    
end