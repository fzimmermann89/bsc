function out=cropScatterImage(in, tosize)
    border=(size(in)-tosize)./2;
    cropped=in(...
       1+floor(border(1)):end-floor(border(1)),...
       1+floor(border(2)):end-floor(border(2))...
       );
%     croppedF=(fft2((cropped)));
% % croppedF=padarray(croppedF,[32,32],croppedF(1,1));
%     out=(ifft2((croppedF),1024,1024));
out = interpft(interpft(cropped,size(in,1),1),size(in,2),2);
end