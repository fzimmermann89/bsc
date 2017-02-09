function xmie=fitmin(x,radius,n)
beta=1e-2;
delta=1e-4;
    wavelength=1;
    function  y=fitstep(x,radius,beta,delta,offset)
        [~,y]=(mie(wavelength,radius,beta,delta,x+offset));
        y=log(y);
    end
    
    [~,xmie]=findpeaks(-(fitstep(x,radius,beta,delta,0)),x,'MinPeakDistance',0.04);
    if length(xmie)>n
        xmie=xmie(1:n);
    end
    if length(xmie)<n
        xmie(n,1)=0;
    end
end
