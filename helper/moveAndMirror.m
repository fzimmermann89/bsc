function  out  = moveAndMirror( fixed,moving )
    maxXcorr=@(a,b)max(max(abs(ift2(ft2(a).*conj(ft2(b))))));
    rotated=rot90(moving,2);
    if maxXcorr(fixed,rotated)>maxXcorr(fixed,moving)
        moving=rotated;
    end
out=imwarp(gather(moving),imregcorr(gather(abs(moving)),gather(abs(fixed)),'translation'),'OutputView',imref2d(size(fixed)));
end

