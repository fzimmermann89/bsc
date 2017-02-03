function newSupport = SW( curImage,relThreshold,sigma )
    %Updates the support based on the current Image using the shrinkwrap method
    filtImage=imgaussfilt(abs(curImage),sigma);
    absThreshold=relThreshold*max(filtImage(:));
    %     absThreshold=relThreshold*median(filtImage(filtImage>0));
    newSupport=filtImage>absThreshold;
end

