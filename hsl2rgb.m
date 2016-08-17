function [rgb] = hsl2rgb(hsl)
    s=hsl(:,:,2);
    l=hsl(:,:,3);
    h=hsl(:,:,1);
    ind = l < 0.5;
    s(ind)=s(ind).*l(ind);
    s(~ind)=s(~ind).*(1-l(~ind));
    v=s+l;
    s=2*s./(v);
    s(v==0)=0;
    hsv=cat(3,h,s,l);
    hsv(hsv>1)=1;
    hsv(hsv<0)=0;
    rgb=hsv2rgb(hsv);
end
