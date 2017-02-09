clear all

dat=load('C:\data\multirun_profiles_dx0.5-2_dz0.06-16.mat');

for n=1:27
    dx(n)=dat.dx{n} ;
    dz(n)=dat.dz{n};
    errors_abs(n)=dat.errors_abs{n};
    profiles_max(n)=dat.profiles_max{n};
    profiles_min(n)=dat.profiles_min{n};
    profiles_stdev(n)=dat.profiles_stdev{n};
    profiles_y(n)=dat.profiles_y{n};
    profile_mie(:,n)=dat.profile_mie{n};
    profiles_x(:,n)=dat.profiles_x{n};
end

dat=load('C:\data\multirun_profiles_dx_dz_rest.mat');
for n=28:54
    dx(n)=dat.dx{n} ;
    dz(n)=dat.dz{n};
    errors_abs(n)=dat.errors_abs{n};
    profiles_max(n)=dat.profiles_max{n};
    profiles_min(n)=dat.profiles_min{n};
    profiles_stdev(n)=dat.profiles_stdev{n};
    profiles_y(n)=dat.profiles_y{n};
    profile_mie(:,n)=dat.profile_mie{n};
    profiles_x(:,n)=dat.profiles_x{n};
end

save('C:\data\multirun_profiles_dx_dz.mat','dx','dz','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs')
