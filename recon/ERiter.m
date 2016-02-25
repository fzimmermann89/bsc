function [ newImage,realError ] = ERiter(amplitude, curImage, support )
    %Perform one iteration of ER
    %   Detailed explanation goes here
    
    %Take Phase of curImag and amplitude to construct a tmpImage
    curImagF=ft2(curImage);
    curPhase=angle(curImagF);
    tmpImage=ift2(amplitude.*(exp(1i.*curPhase)));

    %Force (real) constrains on tmpImage to get newImage
    newImage=support.*tmpImage;
    %should be different function? XXX
    
    %calculate realError (nochmal nachdenken XXX)
    if nargout>1
     realError=norm(tmpImage.*~support,'fro');
    end
end

