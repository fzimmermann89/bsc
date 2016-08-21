function [scatterImage,refImage,mask,softmask,outermask]=prepareInput_sim(filename,refRadius,refError,maskScale,sigmaMask,discreteBits)
    
    %load image
    input=double((rgb2gray(imread(filename))))/255;
    input=input-input(1);
    N=size(input);
    
    %create Reference
    [xx,yy]=meshgrid(-refRadius:1:refRadius);
    realRefImage=xx.^2+yy.^2<refRadius^2;
    
    input(end-2*refRadius:end,end-2*refRadius:end)=realRefImage;
    
    %pad
    input=padarray(input,ceil(size(input)/2),0);
    Npadded=size(input);
    
    %create masks
    [ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);
    
    %create scatterImage
    scatterImage=abs(ft2(input)).^2;
    
    %mask
    scatterImage=scatterImage.*mask;
    
    %discretize
    if (discreteBits~=0)
        dynamicRange=max(scatterImage(:))-min(scatterImage(scatterImage~=0));
        rangePerBit=dynamicRange./2^discreteBits;
        scatterImage=uint16(round(scatterImage./rangePerBit));
        scatterImage=double(imnoise(scatterImage,'poisson'));
    end
    
    %create guessed Reference
    [xx,yy]=meshgrid(-refRadius*refError:1:refRadius*refError);
    refImage=xx.^2+yy.^2<(refRadius*refError)^2;
   
end