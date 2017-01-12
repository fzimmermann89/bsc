% Simulation of an exitwave behind a modell "cell" and reference

clear all; close all;
addpath('./simulation');
addpath('./helper');

fnameprefix='.\Tex\Images\fig_simholo_v2';
fnamemat='.\data\sim_complexobject.mat';

N=4096;
dx=1/2;
dz=1/4;
wavelength=1;

output_image=true;
output_mat=true;

%Protein, H86C52N13O15S, 1.35 g/cm3
coreDelta=2.03e-4;
coreBeta =1.63e-5;

%Water
innerDelta=1.55e-4; 
innerBeta =1.84e-5;

%phosphatidylcholin, C44H82NO8P, 1.1g/cm3
membraneDelta=1.69e-4;
membraneBeta =1.15e-5;

%Xenon 2.9g/cm3
referenceDelta=2.54e-4;
referenceBeta =1.46e-4;

rotationXObj=31.7/180*pi;
rotationYObj=0/180*pi;
rotationZObj=0/180*pi;
positionXObj=-300;
positionYObj=-350;
positionZObj=0;
positionXRef=650;
positionYRef=650;
positionZRef=0;

reference=scatterObjects.dodecahedron();
reference.radius=100;
reference.positionX=positionXRef;
reference.positionY=positionYRef;
reference.positionZ=positionZRef;
reference.beta=referenceBeta;
reference.delta=referenceDelta;

membrane=scatterObjects.icosahedron();
membrane.radius=375;
membrane.positionX=positionXObj;
membrane.positionY=positionYObj;
membrane.beta=membraneBeta;
membrane.delta=membraneDelta;
membrane.rotationX=rotationXObj;
membrane.rotationY=rotationYObj;
membrane.rotationZ=rotationZObj;

inner=scatterObjects.icosahedron();
inner.radius=350;
inner.positionX=positionXObj;
inner.positionY=positionYObj;
inner.beta=innerBeta-membraneBeta;
inner.delta=innerDelta-membraneDelta;
inner.rotationX=rotationXObj;
inner.rotationY=rotationYObj;
inner.rotationZ=rotationZObj;



core1=scatterObjects.sphere();
core1.radius=90;
core1.positionX=positionXObj+180*sin(pi/3);
core1.positionY=positionYObj-180*cos(pi/3);
core1.positionZ=positionZObj-180/6;
core1.beta=coreDelta-innerBeta;
core1.delta=coreBeta-innerDelta;

core2=scatterObjects.sphere();
core2.radius=90;
core2.positionX=positionXObj-180*sin(pi/3);
core2.positionY=positionYObj-180*cos(pi/3);
core2.positionZ=positionZObj-180/6;
core2.beta=coreDelta-innerBeta;
core2.delta=coreBeta-innerDelta;

core3=scatterObjects.sphere();
core3.radius=90;
core3.positionX=positionXObj;
core3.positionY=positionYObj+180;
core3.positionZ=positionZObj-180/6;
core3.beta=coreDelta-innerBeta;
core3.delta=coreBeta-innerDelta;

core4=scatterObjects.sphere();
core4.radius=90;
core4.positionX=positionXObj;
core4.positionY=positionYObj;
core4.positionZ=positionZObj+180/2;
core4.beta=coreDelta-innerBeta;
core4.delta=coreBeta-innerDelta;


if parallel.gpu.GPUDevice.isAvailable
    g=gpuDevice();
    reset(g);
    gpu=true;
else
    gpu=false;
end

%%
if output_mat
    clear objects;
    objects{1}=reference;
    objects{end+1}=membrane;
    objects{end+1}=inner;
    objects{end+1}=core1;
    objects{end+1}=core2;
    objects{end+1}=core3;
    objects{end+1}=core4;
    
    projHolo=gather(scatterObjects.projection(objects,N,dx,gpu ));
    exitwaveHolo=gather(multislice(wavelength,objects,N,dx,dz,gpu));
    
    %remove reference and move objects to center
    objects(1)=[];
    for n=1:length(objects)
        objects{n}.positionX=objects{n}.positionX-positionXObj;
        objects{n}.positionY=objects{n}.positionY-positionYObj;
        objects{n}.positionZ=objects{n}.positionZ-positionZObj;
    end
    
    projObj=gather(scatterObjects.projection(objects,N,dx,gpu ));
    exitwaveObj=gather(multislice(wavelength,objects,N,dx,dz,gpu));
    
    %remove objects and calculate exitwave for reference
    objects={reference};
    objects{1}.positionX=0;
    objects{1}.positionY=0;
    objects{1}.positionZ=0;
    projRef=gather(scatterObjects.projection(objects,N,dx,gpu ));
    exitwaveRef=gather(multislice(wavelength,objects,N,dx,dz,gpu));
    
    settings.dx=dx;
    settings.N=N;
    settings.dz=dz;
    settings.wavelength=wavelength;
    save(fnamemat,'exitwaveHolo','exitwaveRef','exitwaveObj','projHolo','projRef','projObj','reference','settings','-v7.3');
end
%%
if output_image
    if exist('exitwaveHolo','var')
        exitwave=exitwaveHolo;
    else
        clear objects;
        objects{1}=reference;
        objects{end+1}=membrane;
        objects{end+1}=inner;
        objects{end+1}=core1;
        objects{end+1}=core2;
        objects{end+1}=core3;
        objects{end+1}=core4;
        exitwave=gather(multislice(wavelength,objects,N,dx,dz,gpu));
    end
    f=figure('visible','off');
    r=abs(exitwave);
    rmin=0;
    rmax = max(r(isfinite(r)));
    im=compleximagesc(exitwave,[rmin,rmax]);
    axis square
    ax=gca;
    ax.XTick=[];
    ax.YTick=[];
    fname=strcat(fnameprefix,'_exitwave','.png');
    save_image(fname);
    
    
    %% figure colorwheel
    N=1024;
    gamma=.9;
    [x, y] = meshgrid(linspace(-1,1,N));
    [theta, rho] = cart2pol(x, y);
    h = (theta + pi) / (2 * pi);
    s=ones(size(rho));
    l=(rho.^gamma);
    l(rho>1)=0;
    rgb=hsl2rgb(cat(3,h,s,l));
    
    %show colorwheel
    f=figure('visible','off');
    ax1=axes('Position',[0.2,0.2,.6,.6]);
    im=imshow(rgb,'Parent', ax1);
    im.AlphaData=rho<1;
    
    %show axis
    ticks=linspace(rmin,rmax,4);
    ax2=polaraxes('Position',[0.2,0.2,.6,.6]);
    ax2.ThetaAxisUnits = 'radians';
    ax2.Color='none';
    ax2.RAxis.Label.String='rel. Intensität';
    ax2.RAxis.Label.Position=[2,0.7,0];
    ax2.ThetaAxis.Label.Position=[0,1.15,0];
    ax2.ThetaAxis.Label.String='Phase';
    ax2.ThetaTick=[0:0.25:2]*pi;
    ax2.RLim=[rmin,rmax];
    ax2.RTick=ticks(2:end);
    ax2.RAxis.TickLabelFormat='%.1g';
    ax3=polaraxes('Position',[0.2,0.2,.6,.6]);
    ax3.ThetaTick=[];
    ax3.RLim=[rmin,rmax];
    ax3.RTick=ticks(1);
    ax3.RAxis.TickLabelFormat='%.1g';
    ax3.Color='none';
    ax3.RAxis.Color=[1,1,1];
    ax2.ThetaAxis.Color=[0,0,0];
    ax3.ThetaAxis.Color=[0,0,0];
    f.PaperSize=[20,20];
    f.PaperPosition=[-4.5,-4,28,28];
    ax3.FontSize=28;
    ax2.FontSize=28;
    ax2.LineWidth=1;
    ax2.GridAlpha=1;
    ax2.GridColor=[0.3,0.3,0.3];
    ax2.GridLineStyle='--';
    f.Color='none';
    ax1.Color='none';
    
    fname=strcat(fnameprefix,'_exitwave_cw','.pdf');
    print(fname,'-dpdf')
    open(fname)
end
