function [scatterImageHolo,scatterImageObj,refImage,mask,softmask,outermask,exitwaveHolo,exitwaveObj]=prepareInput_exitwave(inputfilename,refError,maskScale,sigmaMask,discreteBits);

    
    %load input
    input=load(inputfilename,'exitwaveHolo','exitwaveObj','exitwaveRef','settings');

    [scatterImageHolo,~,exitwaveHolo]=exitwave2scatter(input.exitwaveHolo,input.settings.dx,input.settings.wavelength,false,true);
    [scatterImageObj,~,exitwaveObj]=exitwave2scatter(input.exitwaveObj,input.settings.dx,input.settings.wavelength,false,true);
        [scatterImageRef,~,exitwaveRef]=exitwave2scatter(input.exitwaveRef,input.settings.dx,input.settings.wavelength,false,true);

%     exitwaveRef=1-(input.exitwaveRef./input.exitwaveRef(1));
    refBw=abs(exitwaveRef)>0.02*max(abs(exitwaveRef(:)));
    refBw=imdilate(refBw,strel('disk',20));
    props=regionprops(refBw,exitwaveRef, {'SubarrayIdx','Area'});
    [~,nRef]=max([props.Area]);
    refImage=exitwaveRef(props(nRef).SubarrayIdx{1},props(nRef).SubarrayIdx{2});
    Npadded=size(scatterImageObj);
    %create masks
    [ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);
    
    %create masked scatterImages
    scatterImageHolo=scatterImageHolo.*mask;
    scatterImageObj=scatterImageObj.*mask;
    
    %discretize and noise
    if (discreteBits~=0)
        scale=(max(scatterImageHolo(:))-min(scatterImageHolo(scatterImageHolo~=0)))/(1e-12*2^discreteBits);
        scatterImageHolo=scatterImageHolo./scale;
        scatterImageHolo=round(10^12*imnoise(double(scatterImageHolo),'poisson'));
        
        scale=(max(scatterImageObj(:))-min(scatterImageObj(scatterImageObj~=0)))/(1e-12*2^discreteBits);
        scatterImageObj=scatterImageObj./scale;
        scatterImageObj=round(10^12*imnoise(double(scatterImageObj),'poisson'));
        
    end
  
end