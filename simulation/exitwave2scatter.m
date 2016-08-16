function [out,angles,exitwave]=exitwave2scatter(exitwave,dx,wavelength,padhalf,padcut,angles)
    % Converts exitwave to scatter image.
    % padhalf (default:true): pad and use weighted average to half resolution
    % padcut (default:false): pad image before converting and cut afterwards
    
    if nargin<4;padhalf=true;end
    if nargin<5;padcut=false; end
    N=length(exitwave);
    Npad=N;
    if padhalf; Npad=2*Npad;end
    if padcut; Npad=2*Npad;end
    exitwave=(exitwave-exitwave(1));
    if nargin<6
        angles=anglemap(N,dx+dx*padcut,wavelength)*180/pi;
    end
    angles=gather(angles);
    out=pad2size(exitwave,Npad);
    
    out=(abs(ft2(out)).^2*(dx^2));
    if padcut
        out=out(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
    end
    out=normalize2(out);%,~isnan(angles));
    if padhalf
        out=(halfimage(out));
    end
    
    
end