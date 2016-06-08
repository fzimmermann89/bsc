% load('dens.mat')
clear all;
N=4*1024;
g=gpuDevice();
%all units are in nm
wavelength=1;

objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.beta=1e-3;
objects{1}.delta=1e-3;
objects{1}.radius=50;

n=0;
nmax=(5*9);

dx=cell(nmax,1);
dz=cell(nmax,1);

profiles_max=cell(nmax,1);
profiles_min=cell(nmax,1);
profiles_stdev=cell(nmax,1);
profiles_y=cell(nmax,1);
profiles_x=cell(nmax,1);
profile_mie=cell(nmax,1);
errors_abs=cell(nmax,1);
n=27; %for restarating..
for ndx=2:4 %-1:4
    for ndz=-4:4
        
        n=n+1;
        
        cdx=2^ndx;
        cdz=2^ndz;
        
        currun=singlerun(N,cdx,cdz,wavelength,objects);
        wait(g);
        profiles_max{n}=currun.profiles_max;
        profiles_min{n}=currun.profiles_min;
        profiles_stdev{n}=currun.profiles_stdev;
        profiles_y{n}=currun.profiles_y;
        profiles_x{n}=currun.profiles_x;
        profile_mie{n}=currun.mie;
        errors_abs{n}=currun.errors_abs;
        dx{n}=cdx;
        dz{n}=cdz;
        
        fprintf('\n status %f %% \n\n',n/(nmax)*100);
    end
end

save('C:\data\multirun_profiles_dx_dz.mat','dx','dz','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs')
