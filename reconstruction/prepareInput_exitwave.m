function [scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,exitwaveHolo,exitwaveObj]=prepareInput_exitwave(inputfilename,refError,maskScale,sigmaMask,discreteBits);

    
    %load input
    input=load(inputfilename,'exitwaveHolo','exitwaveObj','exitwaveRef','settings');
    exitwaveHolo=input.exitwaveHolo;
    exitwaveObj=input.exitwaveObj;
    scatterImageHolo=exitwave2scatter(exitwaveHolo,input.settings.dx,input.settings.wavelength,true,true);
    scatterImage=exitwave2scatter(exitwaveObj,input.settings.dx,input.settings.wavelength,true,true);
    exitwaveRef=1-(input.exitwaveRef./input.exitwaveRef(1));
    refBw=abs(exitwaveRef)>.5*mean(abs(exitwaveRef(:)));
    props=regionprops(refBw,exitwaveRef, {'SubarrayIdx','Area'});
    [~,nRef]=max([props.Area]);
    refImage=exitwaveRef(props(nRef).SubarrayIdx{1},props(nRef).SubarrayIdx{2});
    Npadded=size(scatterImage);
    %create masks
    [ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);
    
    %create masked scatterImages
    scatterImageHolo=scatterImageHolo.*mask;
    scatterImage=scatterImage.^2.*mask;
    
    %discretize and noise
    if (discreteBits~=0)
        scale=(max(scatterImageHolo(:))-min(scatterImageHolo(scatterImageHolo~=0)))/(1e-12*2^discreteBits);
        scatterImageHolo=scatterImageHolo./scale;
        scatterImageHolo=round(10^12*imnoise(double(scatterImageHolo),'poisson'));
        
        scale=(max(scatterImage(:))-min(scatterImage(scatterImage~=0)))/(1e-12*2^discreteBits);
        scatterImage=scatterImage./scale;
        scatterImage=round(10^12*imnoise(double(scatterImage),'poisson'));
        
    end
  
end