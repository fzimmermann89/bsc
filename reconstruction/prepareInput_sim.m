function [scatterImageHolo,scatterImage,refImage,mask,softmask,outermask,inputHolo,input]=prepareInput_sim(filename,refRadius,refError,maskScale,sigmaMask,discreteBits)
    
    %load image
    input=double((rgb2gray(imread(filename))))/255;
    input=(input-min(input(:)))./max(input(:));
    N=size(input);
    

    %create Reference
    [xx,yy]=meshgrid(-refRadius:1:refRadius);
    realRefImage=xx.^2+yy.^2<refRadius^2;
 
    offset=[refRadius,refRadius];%Npadded/8;
    inputHolo=padarray(input,ceil(N),0,'post');
    
    inputHolo((end-2*refRadius:end)-offset(1),(end-2*refRadius:end)-offset(2))=realRefImage;
    inputHolo=padarray(inputHolo,2.^nextpow2(1.5*size(inputHolo))-size(inputHolo),0,'post');
    
    input=padarray(input,(size(inputHolo)-N)/2,0,'both');
    Npadded=size(input);
    figure(9); imagesc(abs(ift2(abs(ft2(inputHolo)).^2)));
    %create masks
    [ mask,softmask,outermask ]=circularMask(Npadded,maskScale,sigmaMask);
    
    %create masked scatterImages
    scatterImageHolo=abs(ft2(inputHolo)).^2.*mask;
    scatterImage=abs(ft2(input)).^2.*mask;
    
    %discretize and noise
    if (discreteBits~=0)
        scale=(max(scatterImageHolo(:))-min(scatterImageHolo(scatterImageHolo~=0)))/(1e-12*2^discreteBits);
        scatterImageHolo=scatterImageHolo./scale;
        scatterImageHolo=round(10^12*imnoise(double(scatterImageHolo),'poisson'));
        
        scale=(max(scatterImage(:))-min(scatterImage(scatterImage~=0)))/(1e-12*2^discreteBits);
        scatterImage=scatterImage./scale;
        scatterImage=round(10^12*imnoise(double(scatterImage),'poisson'));
        
        
    end
    
    %create guessed Reference
    [xx,yy]=meshgrid(-refRadius*refError:1:refRadius*refError);
    refImage=xx.^2+yy.^2<(refRadius*refError)^2;
    
end