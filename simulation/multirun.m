clear all;
g=gpuDevice();

%all units are in nm
% wavelength=1;
% dx=wavelength/2;
% dz=dx/4;

objects=cell(1);
objects{1}=scatterObjects.sphere();

Nsteps=2*1024;

wavelengthsteps=1;

% dxsteps=2.^(-2:0.25:4);
dxsteps=1/2;

% dzsteps=2.^(-4:0.25:4);
dzsteps=1/8;

radiussteps=.25*(1:100);

% betasteps=10.^-(1+0.25*(0:8));
betasteps=1e-3;

% deltasteps=10.^-(1+0.25*(0:8));
deltasteps=1e-3;


nmax=(numel(Nsteps)*numel(wavelengthsteps)*numel(dxsteps)*numel(dzsteps)*numel(radiussteps)*numel(betasteps)*numel(deltasteps));
n=nmax;
for nN=1:numel(Nsteps)
    for nwavelength=1:numel(wavelengthsteps)  
        for ndx=1:numel(dxsteps)
            for ndz=1:numel(dzsteps)
                for nradius=1:numel(radiussteps)
                    for nbeta=1:numel(betasteps)
                        for ndelta=1:numel(deltasteps)
                            
                            cN=Nsteps(nN);
                            cdx=dxsteps(ndx);
                            cdz=dzsteps(ndz);
                            cradius=radiussteps(nradius);
                            cbeta=betasteps(nbeta);
                            cdelta=deltasteps(ndelta);
                            cwavelength=wavelengthsteps(nwavelength);
                            
                            objects{1}.radius=cradius;
                            objects{1}.beta=cbeta;
                            objects{1}.delta=cdelta;
                            
                            currun=singlerun(cN,cdx,cdz,cwavelength,objects);
                            wait(g);
                            
                            profiles_max(n)=currun.profiles_max;
                            profiles_min(n)=currun.profiles_min;
                            profiles_stdev(n)=currun.profiles_stdev;
                            profiles_y(n)=currun.profiles_y;
                            profiles_x(:,n)=currun.profiles_x;
                            profile_mie(:,n)=currun.mie;
                            errors_abs(n)=currun.errors_abs;
                            
                            N(n)=cN;
                            wavelength(n)=cwavelength;
                            dx(n)=cdx;
                            dz(n)=cdz;
                            radius(n)=cradius;
                            beta(n)=cbeta;
                            delta(n)=cdelta;
                            
                            n=n-1;
                            fprintf('\n status %f %% \n\n',(nmax-n)/(nmax)*100);
                        end
                    end
                end
            end
        end
    end
end
    fname=sprintf('C:\\data\\multirun_profiles-%s.mat',datestr(datetime('now'),'yyMMdd-HHmm'));
    save(fname,'N','wavelength','dx','dz','beta','delta','radius','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs')
