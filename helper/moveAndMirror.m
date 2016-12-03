function  [out,didMirror]  = moveAndMirror( fixed,moving,useFastMove )
    % Moves and mirrors 'moving' to match 'fixed'.
    % didMirror is logical and true result was mirrored.
    % Can handle complex and gpu inputs.
    % if useFastMove (default:false) is true, no subpixel move will be made.
    
    didMirror=false;
    Nfixed=abs(fixed);
    Nmoving=abs(moving);
    Nfixed=Nfixed-min(Nfixed(:));
    Nfixed=(Nfixed./max(Nfixed(:)));
    Nmoving=Nmoving-min(Nmoving(:));
    Nmoving=(Nmoving./max(Nmoving(:)));
    Nrotated=rot90(Nmoving,2);
    maxXcorr=@(a,b)max(max(abs(ift2(ft2(a).*conj(ft2(b))))));
    
    if maxXcorr(Nfixed,Nrotated)>maxXcorr(Nfixed,Nmoving)
        moving=(rot90(moving,2));
        Nmoving=rot90(Nmoving,2);
        didMirror=true;
    end
    
    if nargin>2&&useFastMove
        %fast but inprecise
        cor=ift2(ft2(Nmoving).*conj(ft2(Nfixed)));
        [~,id]=max(cor(:));
        [x,y]=ind2sub(size(moving),id);
        offset=1+size(moving)/2-[x,y];
        out=circshift(moving,offset);
    else
        %slow but precise
        %disable warning for weak correlation because of message spam..
        w=warning('query','images:imregcorr:weakPeakCorrelation');
        warning('off',w.identifier);
        out=imwarp(gather(moving),imregcorr(gather(Nmoving),gather(Nfixed),'translation'),'OutputView',imref2d(size(Nfixed)));
        warning(w.state,w.identifier);
    end
end

