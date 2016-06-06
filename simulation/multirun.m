% load('dens.mat')
clear all;
N=2*1024;
%all units are in nm
wavelength=1;
dx=wavelength;
dz=dx/2;
% radius=@(n)5+n/2;

% nruns=40;
% runs=cell(nruns,1); %saving all

objects=cell(1);
objects{1}=scatterObjects.sphere();


n=0;
nmax=(9*9*32);

beta=cell(nmax,1);
delta=cell(nmax,1);
radius=cell(nmax,1);
profiles_max=cell(nmax,1);
profiles_min=cell(nmax,1);
profiles_stdev=cell(nmax,1);
profiles_y=cell(nmax,1);
profiles_x=cell(nmax,1);
profile_mie=cell(nmax,1);
errors_abs=cell(nmax,1);


for nradius=1:32
    for nbeta=0:8
        for ndelta=0:8
            
            n=n+1;
            cradius=2.5*nradius;
            
            cbeta=10^-(1+0.5*nbeta);
            cdelta=10^-(1+0.5*ndelta);
            objects{1}.radius=cradius;
            objects{1}.beta=cbeta;
            objects{1}.delta=cdelta;
            
            currun=singlerun(N,dx,dz,wavelength,objects);
            profiles_max{n}=currun.profiles_max;
            profiles_min{n}=currun.profiles_min;
            profiles_stdev{n}=currun.profiles_stdev;
            profiles_y{n}=currun.profiles_y;
            profiles_x{n}=currun.profiles_x;
            profile_mie{n}=currun.mie;
            errors_abs{n}=currun.errors_abs;
            beta{n}=cbeta;
            delta{n}=cdelta;
            radius{n}=cradius;
            
            fprintf('\n status %f %% \n\n',n/(nmax)*100);
        end
    end
    fname=sprintf('C:\\data\\multirun_nrad1-%d.mat',nradius);
    save(fname,'beta','delta','radius','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs','-v6')
    
end

save('C:\data\multirun_profiles.mat','beta','delta','radius','profiles_max','profiles_min','profiles_stdev','profiles_y','profiles_x','profile_mie','errors_abs')
%
%
%
% %% radius variation
% tic
% for n=1:nruns;
%     objects{1}.radius=radius(n);
%     currun=singlerun(N,dx,dz,wavelength,objects);
%     %     runs{n}=currun; %saving all
%
%     %saving currun
%     fname=sprintf('C:\\data\\N%d_l%.2g_dx%.2g_dz%.2g_rad%.2g_b%.2g_d%.2g.mat',N,wavelength,dx,dz,radius(n),objects{1}.beta,objects{1}.delta);
%     save(fname,'currun','-v7.3');
%
%
%     % auswertung radius
%     rad(n)=currun.objects{1}.radius;
%     msft(n)=currun.errors_rms.msft;
%     multislice(n)=currun.errors_rms.multislice;
%     thibault(n)=currun.errors_rms.thibault;
%     ftproj(n)=currun.errors_rms.FTproj;
%     clear currun;
%     fprintf('finished run %d / %d \n',n,nruns);
% end
% toc
% figure(1);
% plot(rad,msft,'x',rad,multislice,'x',rad,thibault,'x',rad,ftproj,'x');
% legend('msft','multi','thibault','proj');
%
% %% saving all
% % fname=sprintf('C:\data\N%d_l%.2g_dx%.2g_dz%.2g_rad%.2g-%.2g_b%.2g_d%.2g.mat',N,wavelength,dx,dz,radius(1),radius(nruns),objects{1}.beta,objects{1}.delta);
% % save(fname,'runs','-v7.3');