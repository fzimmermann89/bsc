function [scatterImageHolo,refImage,mask,softmask,outermask,scatterImage]=prepareInput_sim(filename,refRadius,refError,maskScale,sigmaMask,discreteBits)
    
    %load image
    input=double((rgb2gray(imread(filename))))/255;
    input=input-input(1);
    N=size(input);
    
    %create Reference
    [xx,yy]=meshgrid(-refRadius:1:refRadius);
    realRefImage=xx.^2+yy.^2<refRadius^2;
    inputHolo=input;
    inputHolo(end-4*refRadius:end-2*refRadius,end-4*refRadius:end-2*refRadius)=realRefImage;
    
    %pad
    inputHolo=padarray(inputHolo,ceil(size(inputHolo)/2),0);
    Npadded=size(inputHolo);
    input=padarray(input,ceil(size(input)/2),0);

    %create masks
    [ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);
    
    %create masked scatterImages
    scatterImageHolo=abs(ft2(inputHolo)).^2.*mask;
    scatterImage=abs(ft2(input)).^2.*mask;
    
    %discretize and noise
    if (discreteBits~=0)
        dynamicRange=max(scatterImageHolo(:))-min(scatterImageHolo(scatterImageHolo~=0));
        rangePerBit=dynamicRange./2^discreteBits;
        scatterImageHolo=uint16(round(scatterImageHolo./rangePerBit));
        scatterImageHolo=double(imnoise(scatterImageHolo,'poisson'));
        
        dynamicRange=max(scatterImage(:))-min(scatterImage(scatterImage~=0));
        rangePerBit=dynamicRange./2^discreteBits;
        scatterImage=uint16(round(scatterImage./rangePerBit));
        scatterImage=double(imnoise(scatterImage,'poisson'));
    end
    
    %create guessed Reference
    [xx,yy]=meshgrid(-refRadius*refError:1:refRadius*refError);
    refImage=xx.^2+yy.^2<(refRadius*refError)^2;
   
end