N1=32
N2=256

 range=linspace(-1,1,N1);
    [xx,yy]=meshgrid(range);
        mask=xx.^2+yy.^2<(.5)^2;
        mask=padarray(mask,[(N2-N1)/2,(N2-N1)/2]);
        figure(1)
        imagesc(mask);
% plot(mask(end/2,:))
fmask=ft2(mask);
        fmask=fmask.*conj(fmask);
        figure(2)
        imagesc(log(fmask));
% plot(fmask(end/2,:))