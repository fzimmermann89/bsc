function [ newImage,realError  ] = HIOiter( amplitude, curImage, support  )
    %Perform one iteration of HIO
    beta=0.9;
    %Take Phase of curImag and amplitude to construct a tmpImage
    curImagF=ft2(curImage);
    curPhase=angle(curImagF);
    tmpImage=ift2(amplitude.*(exp(1i.*curPhase)));
    
    %Force (real) constrains on tmpImage to get newImage
    %inside support
    newImage=support.*tmpImage;
    %outside support
    val=curImage-beta.*tmpImage;
    newImage=newImage+~support.*val;
    %should be different function? XXX
    
    %calculate realError (nochmal nachdenken XXX)
    if nargout>1
        realError=norm(tmpImage.*~support,'fro');
    end
end

