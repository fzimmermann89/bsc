function out=halfdiag(in)
    [yy,xx]=meshgrid(1:size(in,2),1:size(in,1));
    centerx=(in.*xx);
    centerx=mean(centerx(in));
    centery=(in.*yy);
    centery=mean(centery(in));
    offset=(size(in)./2+1)-[centery,centerx];
    mask=(xx./size(in,1)>yy./size(in,2));
    mask=circshift(mask,floor(offset));
    out=mask.*in;
end