% Draws slicewise progress of multislice and msft for illustration

clear all;
close all;

N=256;
addpath('helper','simulation');
%all units are in nm
wavelength=3;
dx=wavelength;
dz=2;
gpu=parallel.gpu.GPUDevice.isAvailable;
path='Tex\images\src';
res='-r1800';

%% objects
objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.beta=1e-3;
objects{1}.delta=1e-3;
objects{1}.radius=100;

%% object slices
figure(6);clf;hold on;
fname=strcat(path,'slice_object.png');
msft2(wavelength,objects,N,dx,dz,gpu,[],@debug_object);
axis equal
axis off
view(80,-30)
camroll(-90)
print(fname,'-dpng',res)
%% ft object slices
figure(7);clf;hold on;
fname=strcat(path,'slice_ftobject.png');
msft2(wavelength,objects,N,dx,dz,gpu,[],@debug_ftobject);
axis equal
axis off
caxis([-3,2]);
view(80,-30)
camroll(-90)
print(fname,'-dpng',res)
%% msft
figure(8);clf;hold on;
fname=strcat(path,'slice_msft.png');
exitwaveMSFT=msft2(wavelength,objects,N,dx,dz,gpu,[],@debug_msft);
caxis([0,8]);
axis equal
axis off
view(80,-30)
camroll(-90)
print(fname,'-dpng',res)
%% multislice
figure(9);clf;hold on;
fname=strcat(path,'slice_multislice.png');
exitwaveMulti=multislice(wavelength,objects,N,dx,dz,gpu,[],@debug_multi);
axis equal
axis off
view(80,-30)
camroll(-90)
load('colormap_multislice.mat');
colormap(c);
print(fname,'-dpng',res)

%% functions
function debug_msft(exitwave,z,~)
    if mod(z,32)==0
        plotslice(log(abs(exitwave)),z);
    end
end

function debug_object(~,z,slice)
    if mod(z,32)==0
        plotslice(abs(slice),z);
    end
end

function debug_ftobject(~,z,slice)
    if mod(z,32)==0
        plotslice(log(abs(ft2(slice))),z);
    end
end
function debug_multi(exitwave,z,~)
    if mod(z,32)==0
        eabs=imgaussfilt(radblur(abs(exitwave)),2);
        eangle=imgaussfilt(unwrap(angle(exitwave),2));
        plotslice(exp(1i*eangle).*eabs,z);
    end
end

function plotslice(data,z)
    dist=5;
    zz=dist*z+1;
    opts={'EdgeAlpha',0,'FaceAlpha',1};
    [xsurface,ysurface]=meshgrid(1:size(data,1),1:size(data,2));
    zsurface=ones(size(data))*zz;
    
    if isreal(data)
        data=gather(double(data));
    else %complex
        rmin=0;
        rmax=1.2;
        arg = angle(data);
        r = abs(data);
        
        % Argument becomes hue
        h = mod(arg/(2*pi), 1);
        h = mod(h,1);
        % Saturation is always 1
        s = ones(size(h));
        % Magnitude becomes level
        l = (r - rmin) / (rmax - rmin);
        % Clamp value between 0 and 1 outside the magnitude range.
        l(r >= rmax) = 1.;
        l(r <= rmin) = 0.;
        
        data = gather(hsl2rgb(cat(3, h, s, l)));
        opts=[opts,'FaceColor','texturemap'];
    end
    
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

