function newSupport = SW( curImage,relThreshold,sigma )
    %Updates the support based on the current Image using the shrinkwrap method
    filtImage=imgaussfilt(abs(curImage),sigma);
    absThreshold=relThreshold*max(filtImage(:))
    newSupport=filtImage>absThreshold;
end

