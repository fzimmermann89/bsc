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
    exitwave=pad2size(exitwave,Npad);
    exitwave=ft2(exitwave)*(dx^2);
%     out=(abs(ft2(out)).^2*(dx^2));
    if padcut
        exitwave=exitwave(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
    end
%     exitwave=normalize2(exitwave);%,~isnan(angles));
    out=abs(exitwave).^2;
    if padhalf
        out=(halfimage(out));
        phase=halfimage(angle(exitwave));
        exitwave=sqrt(out).*exp(1i*phase);     
    end
    exitwave=ift2(exitwave)/(dx^2);
    
end