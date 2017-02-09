function mie_scatter(wavelength,radius,beta,delta)
    tic;
    N=2048;
    dx=0.5;
    center=N/2+1;
    range=linspace(1-center,N-center,N);
    [XX,YY]=meshgrid(range,range);
    R=round(hypot(XX,YY));
    angle=asin(min(1,(R/(N*dx)*wavelength)));
    [uangle,~,iangle]=unique(angle,'sorted');
    [~,mieval]=mie(wavelength,radius,beta,delta,uangle);
    out=reshape(mieval(iangle),[N,N]);
    toc;
    
    figure(7);
    function angleRad=calcAngleRad()
        center=N/2+1;
        [XX,YY]=meshgrid(gpuArray.linspace(1-center,N-center,N),gpuArray.linspace(1-center,N-center,N));
        R=round(hypot(XX,YY));
        R=R(R<N/2);
        R=unique(R,'sorted');
        angleRad=asin(min(1,(R/(N*dx)*wavelength)));
    end
    anglerad=calcAngleRad();
    
    [~,meanData,std]=rprofil(out,N/2,0);
    
    semilogy(anglerad,meanData,'x');hold on;
    
    [~,prec]=mie(wavelength,radius,beta,delta,anglerad);
        [hdangle,hdval]=mie(wavelength,radius,beta,delta,100000);

    semilogy(anglerad,prec,'.');
    semilogy(hdangle,hdval);
    
    new=mie_scatter3(wavelength,radius,beta,delta);
    new=new./max(new(:));
    [~,rnew]=rprofil(new,N/2,0);
    semilogy(anglerad,rnew,'+');
    
    
    legend('sampled','precise','highres','new');
    hold off;
    
    
end