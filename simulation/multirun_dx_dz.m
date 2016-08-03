clear all;
N=2*1024;
g=gpuDevice();

%all units are in nm
wavelength=1;
radius=50;
beta=1e-3;
delta=1e-3;

objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.beta=beta;
objects{1}.delta=delta;
objects{1}.radius=radius;

dxsteps=2.^(-2:0.25:4);
dzsteps=2.^(-4:0.25:4);

nmax=(numel(dxsteps)*numel(dzsteps));
n=nmax;

for ndx=1:numel(dxsteps) %-1:4
    for ndz=1:numel(dzsteps);
      
        cdx=dxsteps(ndx);
        cdz=dzsteps(ndz);
        
        currun=singlerun(N,cdx,cdz,wavelength,objects);
        wait(g);
        
        profiles_max(n)=currun.profiles_max;
        profiles_min(n)=currun.profiles_min;
        profiles_stdev(n)=currun.profiles_stdev;
        profiles_y(n)=currun.profiles_y;
        profiles_x(:,n)=currun.profiles_x;
        profile_mie(:,n)=currun.mie;
        errors_abs(n)=currun.errors_abs;
        dx(n)=cdx;
        dz(n)=cdz;
        
        n=n-1;
        fprintf('\n status %f %% \n\n',(nmax-n)/(nmax)*100);
    end
end

fname=sprintf('C:\\data\\multirun_profiles_dxdz-%s.mat',datestr(datetime('now'),'yyMMdd-HHmm'));
save(fname,'wavelength','beta','delta','radius','dx','dz','N','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs') 
