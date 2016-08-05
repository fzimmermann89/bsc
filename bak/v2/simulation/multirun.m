clear all;

%% settings
%all distances are in nm
description='allN2048';

Nsteps=[2].*1024;

wavelengthsteps=1;

dxsteps=1./[4,2,1];
% dxsteps=1/2;

dzsteps=1./[8,4,2];
% dzsteps=1/8;

radiussteps=[25,50,75]; %.25*(1:100);

% betasteps=10.^-(1+0.25*(0:8));
betasteps=1e-4*[1,5,10,50,100];

% deltasteps=10.^-(1+0.25*(0:8));
deltasteps=1e-4*[1,5,10,50,100];

%marginsteps=0.95;
% marginsteps=[0.5:0.05:0.9,0.925,0.95,0.975,0.9,0.99,1];
%% calculation
g=gpuDevice();
objects=cell(1);
objects{1}=scatterObjects.sphere();

% nmax=(numel(marginsteps)*numel(Nsteps)*numel(wavelengthsteps)*numel(dxsteps)*numel(dzsteps)*numel(radiussteps)*numel(betasteps)*numel(deltasteps));
 nmax=(numel(Nsteps)*numel(wavelengthsteps)*numel(dxsteps)*numel(dzsteps)*numel(radiussteps)*numel(betasteps)*numel(deltasteps));

n=nmax;

for nN=1:numel(Nsteps)
    for nwavelength=1:numel(wavelengthsteps)
        for ndx=1:numel(dxsteps)
            for ndz=1:numel(dzsteps)
                for nradius=1:numel(radiussteps)
                    for nbeta=1:numel(betasteps)
                        for ndelta=1:numel(deltasteps)
%                             for nmargin=1:numel(marginsteps)
                                cN=Nsteps(nN);
                                cwavelength=wavelengthsteps(nwavelength);
                                cdx=dxsteps(ndx);
                                cdz=dzsteps(ndz);
                                
                                cradius=radiussteps(nradius);
                                cbeta=betasteps(nbeta);
                                cdelta=deltasteps(ndelta);
%                                 cmargin=marginsteps(nmargin);
                                
                                objects{1}.radius=cradius;
                                objects{1}.beta=cbeta;
                                objects{1}.delta=cdelta;
                                
                                currun=singlerun(cN,cdx,cdz,cwavelength,objects);
                                wait(g);
                                
                                profiles_max(n)=currun.profiles_max;
                                profiles_min(n)=currun.profiles_min;
                                profiles_stdev(n)=currun.profiles_stdev;
                                profiles_y(n)=currun.profiles_y;
                                profiles_x(1:length(currun.profiles_x),n)=currun.profiles_x;
                                profile_mie(1:length(currun.mie),n)=currun.mie;
                                errors_abs(n)=currun.errors_abs;
                                
                                N(n)=cN;
                                wavelength(n)=cwavelength;
                                dx(n)=cdx;
                                dz(n)=cdz;
                                radius(n)=cradius;
                                beta(n)=cbeta;
                                delta(n)=cdelta;
%                                 margin(n)=cmargin;
                                
                                n=n-1;
                                fprintf('\n status %f %% \n\n',(nmax-n)/(nmax)*100);
                                
%                             end
                        end
                    end
                end
            end
        end
    end
end
%% saving
fname=sprintf('C:\\data\\multirun-%s_profiles-%s.mat',description,datestr(datetime('now'),'yyMMdd-HHmm'));
save(fname,'N','wavelength','dx','dz','beta','delta','radius','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs')
