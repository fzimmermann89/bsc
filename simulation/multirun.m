clear all;
N=2*1024;
g=gpuDevice();

%all units are in nm
wavelength=1;
dx=wavelength;
dz=dx/2;

objects=cell(1);
objects{1}=scatterObjects.sphere();

radiussteps=2.5.*(1:32);
betasteps=10.^-(1+0.5*(0:8));
deltasteps=10.^-(1+0.5*(0:8));

nmax=(numel(radiussteps)*numel(betasteps)*numel(deltasteps));
n=nmax;

for nradius=1:numel(radiussteps)
    for nbeta=1:numel(betasteps) 
        for ndelta=1:numel(deltasteps)
            
            cradius=radiussteps(nradius);
            cbeta=betasteps(nbeta);
            cdelta=deltasteps(ndelta);
            
            objects{1}.radius=cradius;
            objects{1}.beta=cbeta;
            objects{1}.delta=cdelta;
            
            currun=singlerun(N,dx,dz,wavelength,objects);
            wait(g);
            
            profiles_max(n)=currun.profiles_max;
            profiles_min(n)=currun.profiles_min;
            profiles_stdev(n)=currun.profiles_stdev;
            profiles_y(n)=currun.profiles_y;
            profiles_x(:,n)=currun.profiles_x;
            profile_mie(:,n)=currun.mie;
            errors_abs(n)=currun.errors_abs;
            beta(n)=cbeta;
            delta(n)=cdelta;
            radius(n)=cradius;
            
            n=n-1;
            fprintf('\n status %f %% \n\n',(nmax-n)/(nmax)*100);
        end
    end
    %     fname=sprintf('C:\\data\\multirun_nrad1-%d.mat',nradius);
    %     save(fname,'beta','delta','radius','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs','-v6')  
end
fname=sprintf('C:\\data\\multirun_profiles_bdr-%s.mat',datestr(datetime('now'),'yyMMdd-HHmm'));
save(fname','beta','delta','radius','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs')
