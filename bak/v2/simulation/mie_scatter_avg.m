function out=mie_scatter_avg(wavelength,radius,beta,delta,N,dx)
    % calculates a mie scatter image using oversampling and weighted average.
    y=-N/2-.5:.5:.5;
    dscale=(wavelength/(N*dx));
    out=zeros(N,N);
    
    %calculate columns
    left=mierow(-N/2-.5);
    for ncol=1:N/2+1;
        cur=mierow(-N/2+ncol-1);
        right=mierow(-N/2+ncol-1+.5);
        tmp=row(left,cur,right);
        out(:,ncol)=tmp;
        left=right;
    end
    
    %mirror
    for ncol=2:N/2
        out(:,N-ncol+2)=out(:,ncol);
    end
    
    %normalize
    %out=out./out(end/2+1,end/2+1);
    
    function out=mierow(x)
        d=sqrt(x^2+y.^2)*dscale;
        d=asin(min(1,d));
        [~,out]=mie(wavelength,radius,beta,delta,d);
    end
    
    function out=row(left,cur,right)
        out=zeros(N,1);
        
        for n=1:N/2+1
            %weighted average
            out(n)=(left(2*n-1)+right(2*n-1)+left(2*n+1)+right(2*n+1))/16 ...
                +(left(2*n)+right(2*n)+cur(2*n-1)+cur(2*n+1))/8 ...
                +(cur(2*n)/4);
        end
        %mirror
        for n=2:N/2
            out(N-n+2)=out(n);
        end
    end
end
