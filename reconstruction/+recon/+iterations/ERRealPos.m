function [ newImage,realError ] = ERRealPos(amplitude, curImage, support,mask )
    %Perform one iteration of ER

    %Take Phase of curImag and amplitude to construct a tmpImage
    curImagF=ft2(curImage);
    curPhase=angle(curImagF);
    tmpImage=ift2(mask.*amplitude.*(exp(1i.*curPhase))+~mask.*curImagF);

    %Force (real) constrains on tmpImage to get newImage
    newImage=support.*abs(real(tmpImage));
    %should be different function? XXX

    %calculate realError (nochmal nachdenken XXX)
    if nargout>1
     realError=norm(tmpImage.*~support,'fro')./norm(tmpImage,'fro');
    end
end

