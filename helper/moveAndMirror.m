function  out  = moveAndMirror( fixed,moving )
    Nfixed=abs(fixed);
    Nmoving=abs(moving);
    Nfixed=Nfixed-min(fixed(:));
    Nfixed=gather(Nfixed./max(Nfixed(:)));
    Nmoving=Nmoving-min(Nmoving(:));
    Nmoving=gather(Nmoving./max(Nmoving(:)));
    Nrotated=rot90(Nmoving,2);
    maxXcorr=@(a,b)max(max(abs(ift2(ft2(a).*conj(ft2(b))))));
    
    if maxXcorr(Nfixed,Nrotated)>maxXcorr(Nfixed,Nmoving)
        moving=rot90(moving,2);
        Nmoving=rot90(Nmoving,2);
    end
    out=imwarp(gather(moving),imregcorr(Nmoving,Nfixed,'translation'),'OutputView',imref2d(size(Nfixed)));
end

