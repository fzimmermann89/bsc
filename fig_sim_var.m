% Draws 2d graphs of error over parameter variation for the different
% simulation algorithms 

addpath('reconstruction','simulation','helper');

nicenames={'Projektion','Multislice Propagation','Thibaults Multislice','MSFT'};
c=load('colormap-error.mat');
plotpos=[...
    .1,.15,.35,.35;...
    .1,.6,.35,.35;...
    .6,.15,.35,.35;...
    .6,.6,.35,.35;...
    ];
fname='.\Tex\images\fig_sim_var.pdf';
datafile='C:\data\multirun2-beta=deltaN2048-162217-0908.mat';


if ~exist('data','var')||~ isstruct(data)
    data=load(datafile,'error_rel_median','beta','delta','radius');
end

names=fieldnames(data.error_rel_median);
ids=data.beta==data.delta;

f=figure('visible','off');
clf;
for n=1: length(names)
    name=names{n};
    ax=    subplot('Position',plotpos(n,:));
    err=[data.error_rel_median.(name)];
    urad=unique(data.radius(ids),'stable');
    ubeta=log10(unique(data.beta(ids),'stable'));
    err2d=reshape(err(ids),[numel(ubeta),numel(urad)]);
    imagesc('XData',urad,'YData',ubeta,'CData',err2d);
    axis([20,max(urad),min(ubeta),max(ubeta)]);
    ax.XLabel.String='Radius (nm)';
    ax.YLabel.String='log(\beta)=log(\delta)';
    axis square
    caxis([0,1])
    title(nicenames{n});
    colormap(c.values);
    box on;
end
cb=colorbar('north');
cb.Position=[0.3 0.075 0.40 0.01];
cb.Label.String='Mediane rel. Abweichung von Mie';
cb.Label.FontSize=11;
cb.TickLabels(end)=strcat('>',cb.TickLabels(end));

f.PaperSize=[20,20];
f.PaperPosition=[0,0,20,20];
print(fname,'-dpdf');
open(fname)
