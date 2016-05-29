function run=singlerun(N,dx,dz,wavelength,objects)
%% setup
tic
run=storage.run(N,dx,dz,wavelength,objects);
try
    gpu=parallel.gpu.GPUDevice.isAvailable;
catch
    gpu=false;
end
limit=N/2;
precision=0;

angleRad=calcAngleRad();
anglerange=asin(((-N/2:N/2-1)*1/(N*dx))*wavelength)';

run.profiles_x=angleRad;
run.scatters_scale=anglerange;
run.exitwaves_scale=((-N/2:N/2-1)*dx);

%% mie
[~,pMie]=mie(wavelength,objects{1}.radius,objects{1}.beta,objects{1}.delta,angleRad);
pMie=(pMie        ./max(pMie(:)));
run.mie=gather(pMie);

%% rayleigh
[~,pRayleigh]=rayleigh(objects{1}.radius,wavelength,angleRad);
run.rayleigh=gather(pRayleigh);
clear pRayleigh;

%% ft projection
exitwave=(abs(scatterObjects.projection(objects,N,dx,gpu)));
scatter=normalize(abs(ft2(exitwave)).^2*(dx^2));

name='FTproj';
run=addtorun(run,name,exitwave,scatter);

%% multislice
exitwave=(multislice(wavelength,objects,N,dx,dz,gpu,false));
scatter=normalize(abs(ft2(exitwave)).^2*(dx^2));

name='multislice';
run=addtorun(run,name,exitwave,scatter);

%% thibault
exitwave=(thibault(wavelength,objects,N,dx,dz,gpu));
scatter=normalize(abs(ft2(exitwave)).^2*(dx^2));

name='thibault';
run=addtorun(run,name,exitwave,scatter);

%% msft
msft=(msft2(wavelength,objects,N,dx,dz,gpu));
scatter=(abs(msft).^2);
exitwave=ift2(msft/(dx^2));
clear msft

name='msft';
run=addtorun(run,name,exitwave,scatter);

%%
fprintf('\n fertig \n');
toc

%% helper functions
    function run=addtorun(run,name,exitwave,scatter)
        [~,meanData,stdData,minData,maxData]=rprofil(scatter,limit,precision);
        [~,abserror,relerror]=difference(gather(angleRad),gather(meanData),gather(angleRad),gather(pMie));
        run.exitwaves.(name)=gather(exitwave);
        run.scatters.(name)=gather(scatter);
        run.profiles_y.(name)=gather(meanData);
        run.profiles_stdev.(name)=gather(stdData);
        run.profiles_min.(name)=gather(minData);
        run.profiles_max.(name)=gather(maxData);
        run.errors_rel.(name)=gather(relerror);
        run.errors_abs.(name)=gather(abserror);
        run.errors_rms.(name)=gather(sqrt(sum(abserror(:).^2)./numel(abserror)));
    end

    function angleRad=calcAngleRad()
        center=N/2+1;
        %calculate distances of each pixel
        if gpu
            [XX,YY]=meshgrid(gpuArray.linspace(1-center,N-center,N),gpuArray.linspace(1-center,N-center,N));
            R=round(hypot(XX,YY)*10^precision)./10^precision;
        else
            [XX,YY]=meshgrid(linspace(1-center,N-center,N),linspace(1-center,N-center,N));
            R=round(hypot(XX,YY),precision);
        end
        R=R(R<limit);
        
        %unique distances
        R=unique(R,'sorted');
        angleRad=(asin(R/(N*dx)*wavelength));
    end
end