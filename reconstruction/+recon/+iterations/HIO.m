function [ newImage,realError  ] = HIO( amplitude, curImage, support,mask  )
    %Perform one iteration of HIO
    beta=0.9;
    %Take Phase of curImag and amplitude to construct a tmpImage
    curImagF=ft2(curImage);
    curPhase=angle(curImagF);
    tmpImage=ift2(mask.*amplitude.*(exp(1i.*curPhase))+~mask.*curImagF);
    
    %Force (real) constrains on tmpImage to get newImage
    %inside support
    newImage=support.*tmpImage;
    %outside support
    feedback=curImage-beta.*tmpImage;
    newImage=newImage+~support.*feedback;
    
    
    %calculate realError
    if nargout>1
        realError=norm(tmpImage.*~support,'fro')./norm(tmpImage,'fro');
    end
end

