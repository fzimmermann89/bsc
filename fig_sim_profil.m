%% settings
clear all;
fname='.\Tex\Images\fig_sim_profile.pdf';
g=gpuDevice();
reset(g);
N=4*1024;
beta=1e-4;
delta=1e-4;
radius=20;
dx=1/2;
dz=1/4;
wavelength=1;

%% run
objects{1}=scatterObjects.sphere();
objects{1}.radius=radius;
objects{1}.beta=beta;
objects{1}.delta=delta;
run=singlerun2(N,dx,dz,wavelength,objects);

%% values
minangle=1;
maxangle=20;
angles=run.scatter_scale;
x=angles(end/2+1:end,end/2+1);
err=structfun(@(x)median(abs(x(angles>minangle&angles<maxangle))),run.error_rel,'UniformOutput',false);
disp(err);
names=fieldnames(run.scatter);
%% figure
f=figure('visible','off');
set(f,'defaultAxesColorOrder',[[0 0 0]; [0 0 0]]);
nicenames={'Projektion','Multislice Propagation','Thibaults Multislice','MSFT'};
for n=1:length(names)
    cur=names{n};
    ax=subplot(2,2,n);
    
    yyaxis left
    linem=semilogy(x,run.profile_mie,'g.');
    hold on;
    linep=semilogy(x,run.profile_scatter.(cur),'b.');
    axis([0.2,maxangle,1e-10,1]);
    yyaxis right;
    linee=plot(x,run.profile_error_rel.(cur),'r');
    plot(x,0*x,'--k');
    axis([0.2,maxangle,-.5,.5]);
    ax.XAxis.TickLabelFormat = '%,.1g°';
    ax.XAxis.Label.String='Streuwinkel';
    ax.YAxis(1).Label.String='normierte Intensität';
    ax.YAxis(2).Label.String='rel. Fehler';
    ax.Title.String=nicenames{n};
    ax.Title.FontSize=24;
    ax.YAxis(1).Label.FontSize=16;
    ax.YAxis(2).Label.FontSize=16;
    ax.XAxis.Label.FontSize=16;
end
hL = legend([linem,linep,linee],{'Mie{      }','Simulation{      }','{ }rel. Abweichung von Mie'});
hL.Orientation='horizontal';
hL.FontSize=16;
hL.Position=[0.5,0.05,0,0];
f.PaperSize=3*[15,9];
f.PaperPosition=3*[-1 -.25 17 9.5];



print(fname,'-dpdf');
open(fname);