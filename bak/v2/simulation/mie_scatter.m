function out=mie_scatter(wavelength,radius,beta,delta,N,dx,offset)
    if nargin<7;offset=0;end
    center=N/2+1+offset;
    out=zeros(N,N);
%     tic
%     range=linspace(-N/2+1+offset,offset,N/2);
%     [XX,YY]=meshgrid(range,range);
%     R=(hypot(XX,YY));
%      angle=asin(min(1,(R/(N*dx)*wavelength)));
%       [uangle,~,iangle]=unique(angle,'sorted');
%     toc
    
    tic
    range=linspace(-N/2+offset,offset,N/2+1).^2;
    [XX,YY]=meshgrid(range,range);
    R=(sqrt(XX+YY));
    [uR,~,idx]=unique(R,'sorted');
        angle=asin(min(1,(uR/(N*dx)*wavelength)));
  [~,mieval]=mie(wavelength,radius,beta,delta,angle);
  mieval=reshape(mieval(idx),[N/2+1,N/2+1]);
  out(1:N/2+1,1:N/2+1)=mieval;
  out(N/2+2:end,1:N/2+1)=flipud(mieval(2:end-1,1:end));
  out(1:end,end/2+2:end)=fliplr(out(1:end,2:end/2));
    toc
    
%     angle=asin(min(1,(R/(N*dx)*wavelength)));
%     [uangle,~,iangle]=unique(angle,'sorted');
%     [~,mieval]=mie(wavelength,radius,beta,delta,uangle);
%     out=reshape(mieval(iangle),[N,N]);
% %     out=out./out(end/2+2,end/2+2);
end
% mie_scatter(wavelength,radius,beta,delta,4*N,dx)