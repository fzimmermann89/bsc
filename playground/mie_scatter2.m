function mie_scatter2
    tic;
    N=512;
    ratio=4;
    wavelength=1;
    dx=0.5;
    radius=25;
    beta=1e-3;
    delta=1e-3;
    
    range=gpuArray(-N/2-.25:1/ratio:N/2-1+.25);
    d=gather(arrayfun(@(x,y)sqrt((x)^2+(y)^2),range,range'));
    [ud,~,iud]=unique(d);
    angles=((ud*(wavelength/(N*dx))));
%     angles=ud;
    angles(angles>1)=1;
    angles(1)=0;
    angles=asin(angles);
    [~,val]=mie(wavelength,radius,beta,delta,angles);
%     val=angles;
    iud=reshape(iud,[ratio*N,ratio*N]);
    ids=gpuArray(1:ratio:ratio*N-(ratio-1));
    out=arrayfun(@fun,ids,ids');
    function out=fun(x,y)
        out=0;
        for a=0:(ratio-1)
            for b=0:(ratio-1)
                out=out+(val(iud(x+a,y+b)));
            end
        end
       out=out/ratio^2;
    end
    toc;
    
    figure(5)
    imagesc((out));
    
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
    
    [~,meanData]=rprofil(out,N/2,0);
    
    semilogy(anglerad,meanData,'x');hold on;
    [~,prec]=mie(wavelength,radius,beta,delta,anglerad);
    semilogy(anglerad,prec,'-');
    legend('sampled','precise');
    hold off;
end