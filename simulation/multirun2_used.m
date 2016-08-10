clear all;

%% settings
%all distances are in nm
minangle=1;
maxangle=20;
description='bata=deltaN2048';

Nsteps=[2].*1024;
wavelengthsteps=1;
dxsteps=1./[2];
dzsteps=1./[4];
radiussteps=10*[1:20];
betasteps=10.^[-5.5:.25:-1];
%% calculation
g=gpuDevice();
objects=cell(1);
objects{1}=scatterObjects.sphere();

nmax=numel(Nsteps)*numel(wavelengthsteps)*numel(dxsteps)*numel(dzsteps)*numel(radiussteps)*numel(betasteps);%*numel(deltasteps);
n=nmax;

for nN=1:numel(Nsteps)
    for nwavelength=1:numel(wavelengthsteps)
        for ndx=1:numel(dxsteps)
            for ndz=1:numel(dzsteps)
                for nradius=1:numel(radiussteps)
                    for nbeta=1:numel(betasteps)
                        %                         for ndelta=1:numel(deltasteps)
                        cN=Nsteps(nN);
                        cwavelength=wavelengthsteps(nwavelength);
                        cdx=dxsteps(ndx);
                        cdz=dzsteps(ndz);
                        cradius=radiussteps(nradius);
                        cbeta=betasteps(nbeta);
                        %                             cdelta=deltasteps(ndelta);
                        cdelta=cbeta;
                        objects{1}.radius=cradius;
                        objects{1}.beta=cbeta;
                        objects{1}.delta=cdelta;
                        
                        currun=singlerun2(cN,cdx,cdz,cwavelength,objects);
                        cangles=currun.scatter_scale;
                        
                        N(n)=cN;
                        wavelength(n)=cwavelength;
                        dx(n)=cdx;
                        dz(n)=cdz;
                        radius(n)=cradius;
                        beta(n)=cbeta;
                        delta(n)=cdelta;
                        
                        profile_y(n)=currun.profile_scatter;
                        profile_x(1:length(currun.profile_scale),n)=currun.profile_scale;
                        profile_mie(1:length(currun.profile_mie),n)=currun.profile_mie;
                        
                        error_rel_median(n)=structfun(@(x)median(abs(x(cangles>minangle&cangles<maxangle))),currun.error_rel,'UniformOutput',false);
                        error_rel_mean(n)=structfun(@(x)mean(abs(x(cangles>minangle&cangles<maxangle))),currun.error_rel,'UniformOutput',false);
                        
                        error_rel(n)=structfun(@(x)single(x),currun.error_rel,'UniformOutput',false);
                        profile_error_abs(n)=currun.profile_error_abs;
                        profile_error_rel(n)=currun.profile_error_abs;
                        
                        n=n-1;
                        fprintf('\n status %g %% \n\n',(nmax-n)/(nmax)*100);
                        wait(g);
                        
                        %                         end
                    end
                end
            end
        end
    end
end
%% saving
fname=sprintf('C:\\data\\multirun2-%s-%s.mat',description,datestr(datetime('now'),'yyMMdd-HHmm'));
save(fname,'N','wavelength','dx','dz','beta','delta','radius','profile_y','profile_x','profile_mie','profile_error_abs','profile_error_rel','error_rel','error_rel_mean','error_rel_median','-v7.3')