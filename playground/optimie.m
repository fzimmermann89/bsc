function out=optimie(wavelength,radius,beta,delta,N,dx,offset,ref)
    mval=mie_scatter(wavelength,radius,beta,delta,N,dx,offset);
range=linspace(-1,1,N);
[xx,yy]=meshgrid(range,range);
circ=(xx.^2+yy.^2)<(1/4)^2;
mval=mval./mval(end/2+2,end/2+2);
    mval(end/2+1,end/2+1)=1;
    ref=ref./ref(end/2+2,end/2+2);
ref(end/2+1,end/2+1)=1;
tmp=abs((mval-ref)./mval);
% out=sum(tmp(:))./sum(circ(:));
tmp(circ==0)=NaN;
tmp(tmp<0.1)=NaN;
out=nanmean(tmp(:));
end