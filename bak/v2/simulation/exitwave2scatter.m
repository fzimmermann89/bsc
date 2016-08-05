function [out,angles]=exitwave2scatter(exitwave,dx,wavelength,padhalf,padcut)
    % Converts exitwave to scatter image.
    % padhalf (default:true): pad and use weighted average to half resolution
    % padcut (default:false): pad image before converting and cut afterwards
    
    if nargin<4;padhalf=true;end
    if nargin<5;padcut=false; end
    N=length(exitwave);
    if padhalf; Npad=2*Nneu;end
    if padcut; Npad=2*Nneu;end
    out=gather(exitwave-exitwave(1));
    
    angles=gather(single(anglemap(N,dx+dx*padcut,wavelength)*180/pi));
    
    out=pad2size(out,Npad);
    
    out=(abs(ft2(out)).^2*(dx^2));
    if padcut
        out=out(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
    end
    out=normalize2(out);%,~isnan(angles));
    if padhalf
        out=gather(halfimage(out));
    end
    
    
end