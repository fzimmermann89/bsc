function [f,gof]=fitmie(x,rprofil,wavelength,radius0,beta0,delta0)
    
    function  y=fitstep(x,radius,beta,delta,offset)
        [~,y]=(mie(wavelength,radius,beta,delta,x+offset));
        y=log(y);
    end
    x=x(2:end);
    rprofil=log(rprofil(2:end));
    
    ft = fittype( @(radius,beta,delta,offset,x) fitstep(x,radius,beta,delta,offset));
    options = fitoptions(ft);
    options.StartPoint=[radius0, beta0, delta0,0];
    %     options.Lower=[radius0/2,beta0/5,delta0/5,-];
    %     options.Upper=[radius0*2,beta0*5,delta0*5];
    
    options.Algorithm='Levenberg-Marquardt';
    options.DiffMinChange=0;
    options.Display='Iter';
    options.MaxFunEvals= 10000;
    options.MaxIter= 100;
    options.TolFun=0;
    options.TolX=0;
    
    
    [f,gof] =  fit( x, rprofil, ft,options);
    
end
