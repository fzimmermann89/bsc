clear all;
close all;
N=256;
addpath('helper','simulation');
%all units are in nm
wavelength=1;
dx=wavelength*2;
dz=dx;
gpu=parallel.gpu.GPUDevice.isAvailable;
path='Tex\images\';

%% objects
objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.beta=1e-4;
objects{1}.delta=1e-2;
objects{1}.radius=100;

%% msft
figure(9);clf;hold on;
fname=strcat(path,'slice_msft.png');
exitwaveMSFT=msft2(wavelength,objects,N,dx,dz,gpu,[],@debug_msft);
caxis([1,12]);
axis equal
axis off
view(80,-30)
camroll(-90)
print(fname,'-dpng','-r600')
%% multislice
figure(9);clf;hold on;
fname=strcat(path,'slice_multislice.png');
exitwaveMulti=multislice(wavelength,objects,N,dx,dz,gpu,[],@debug_multi);
caxis([0,1.1]);
axis equal
axis off
view(80,-30)
camroll(-90)
load('colormap_multislice.mat');
colormap(c);
print(fname,'-dpng','-r600')

%% functions
function debug_msft(exitwave,z)  
    if mod(z,16)==0
        plotslice(log(abs(exitwave)),z);
    end
end

function debug_multi(exitwave,z)  
    if mod(z,16)==0
        plotslice(imgaussfilt(radblur(abs(exitwave)),2),z);
    end
end

function plotslice(data,z)
    data=gather(double(data));
    opts={'EdgeAlpha',0,'FaceAlpha',1};
    dist=5;
    zz=dist*z+1;
    [xsurface,ysurface]=meshgrid(1:size(data,1),1:size(data,2));
    zsurface=ones(size(data))*zz;
    surf(xsurface,ysurface,zsurface,data,opts{:});
    xoutline=[0,0,1,1]*(size(data,1)-1)+1;
    youtline=[0,1,1,0]*(size(data,2)-1)+1;
    zoutline=ones(size(xoutline))*zz;
    patch(xoutline,youtline,zoutline,'blue','FaceAlpha',0,'EdgeColor','black','EdgeLighting','flat');
end

function out=radblur(in)
    angles=0:5:90;
    out=zeros(size(in));
    for a=angles
        tmp=imrotate(single(abs(in)),a,'crop');
        tmp(tmp==0)=in(1);
        out=out+tmp;
    end
    out=out./numel(angles);
end

