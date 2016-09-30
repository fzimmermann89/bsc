function  [out,didMirror]  = moveAndMirror( fixed,moving )
    % Moves and mirrors 'moving' to match 'fixed'.
    % didMirror is logical and true result was mirrored.
    % Can handle complex and gpu inputs.
    
    didMirror=false;
    Nfixed=abs(fixed);
    Nmoving=abs(moving);
    Nfixed=Nfixed-min(Nfixed(:));
    Nfixed=gather(Nfixed./max(Nfixed(:)));
    Nmoving=Nmoving-min(Nmoving(:));
    Nmoving=gather(Nmoving./max(Nmoving(:)));
    Nrotated=rot90(Nmoving,2);
    maxXcorr=@(a,b)max(max(abs(ift2(ft2(a).*conj(ft2(b))))));
    
    if maxXcorr(Nfixed,Nrotated)>maxXcorr(Nfixed,Nmoving)
        moving=(rot90(moving,2));
        Nmoving=rot90(Nmoving,2);
        didMirror=true;
    end
    %disable warning for weak correlation because of message spam..
    w=warning('query','images:imregcorr:weakPeakCorrelation');
    warning('off',w.identifier);
    out=imwarp(gather(moving),imregcorr(Nmoving,Nfixed,'translation'),'OutputView',imref2d(size(Nfixed)));
    warning(w.state,w.identifier);
end

