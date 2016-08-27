function [ newImage,realError  ] = RAARiter( amplitude, curImage, support,mask  )
    %Perform one iteration of HIO

    %Adaptive beta, vgl Luke?
    persistent beta
    if isempty(beta)
        beta=0.95;
    else
        beta=max(beta-0.00001,0.5);
    end
%     beta
%     beta=0.87; %debug´

    %Take Phase of curImag and amplitude to construct a tmpImage
    curImagF=ft2(curImage);
    curPhase=angle(curImagF);
      tmpImage=ift2(mask.*amplitude.*(exp(1i.*curPhase))+~mask.*curImagF);

    %Force (real) constrains on tmpImage to get newImage
    %inside support
    newImage=support.*tmpImage;
    %outside support
    feedback=beta*curImage+(1-2*beta).*tmpImage;
    newImage=newImage+~support.*feedback;
    %should be different function? XXX

    %calculate realError (nochmal nachdenken XXX)
    if nargout>1
        realError=norm(tmpImage.*~support,'fro')./norm(tmpImage,'fro');
    end
end

