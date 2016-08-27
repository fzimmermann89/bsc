
function [ newImage,realError ] = ERiter(amplitude, curImage, support,mask )
    %Perform one iteration of ER
    %   Detailed explanation goes here

    %Take Phase of curImag and amplitude to construct a tmpImage
    curImagF=ft2(curImage);
    curPhase=angle(curImagF);
    tmpImage=ift2(mask.*amplitude.*(exp(1i.*curPhase))+~mask.*curImagF);

    %Force (real) constrains on tmpImage to get newImage
    newImage=support.*tmpImage;
    %should be different function? XXX

    %calculate realError (nochmal nachdenken XXX)
    if nargout>1
     realError=norm(tmpImage.*~support,'fro')./norm(tmpImage,'fro');
    end
%   figure(8);subplot(2,1,1);imagesc(real(newImage));colorbar;subplot(2,1,2);imagesc(abs(ft2(newImage)));colorbar;drawnow;
end

