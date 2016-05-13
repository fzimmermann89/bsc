function [theta,Intensity,S1,S2]=mie(lambda,radius,beta,delta,steps)
    % returns intensity of mie scattering of unpolarized light at a sphere of radius 'radius' (in nm)
    % and refractive index n=1-delta+ibeta at wavelength lambda (in nm) in
    % 'steps' linear steps of scattering angle theta. Further returns S1&S2.
    % Normalized for forward intensity.
    % based on Mie functions by C. Mätzler (2002)
    % which are based on Bohren and Huffman (1983)
    
    k=2*pi/lambda;                  % vacuum wave number in 1/nm
    x=gather(k*radius);             % size parameter
    refIndex=gather(1-delta+1i*beta);
    
    if ~exist('steps','var');steps=10000;end
    
    theta=linspace(0,pi,steps);
    u=cos(theta);
    
    [S1,S2]=mie_S1S22(refIndex,x,u);
    
    S11=(abs(S1).^2+abs(S2).^2)/2;
    
    %normalize
    Intensity=S11./S11(1);
    
    
    %% modified versions of original functions by C. Mätzler
    function [S1,S2] = mie_S1S22(m, x, u)
        % Computation of Mie Scattering functions S1 and S2
        % for complex refractive index m=m'+im",
        % size parameter x=k*radius and u=cos(scattering angle),
        % s. p. 111-114, Bohren and Huffman (1983)
        % C. Mätzler, May 2002.
        % ffz2016:modified to calculate for all u in one call, cleanup.
        
        nmax=round(2+x+4*x^(1/3));
        
        [an,bn]=an_bn(m,x,nmax);
        [pin,taun]=pin_taun(u,nmax);
        
        n=1:nmax;
        fn=(2*n+1)./(n.*(n+1));
        anfn=an.*fn;
        bnfn=bn.*fn;
        S1=(anfn*pin'+bnfn*taun');
        S2=(anfn*taun'+bnfn*pin');
        
    end
    
    function [pie,tau]=pin_taun(u,nmax)
        % pi_n and tau_n, -1 <= u <= 1, n1 integer from 1 to nmax
        % angular functions used in Mie Theory
        % Bohren and Huffman (1983), p. 94 - 95
        % ffz2016: modified to calculate for all u in one call, cleanup.
        
        pie=zeros(numel(u),nmax); tau=zeros(numel(u),nmax);
        pie(:,1)=1;
        tau(:,1)=u;
        pie(:,2)=3*u;
        tau(:,2)=6*u.^2-3; %same as 3*cos(2*acos(u));
        for n=3:nmax
            pie(:,n)=((2*n-1)./(n-1).*pie(:,n-1).*u')-(n./(n-1).*pie(:,n-2));
            tau(:,n)=(n*u'.*pie(:,n))-((n+1).*pie(:,n-1));
        end;
    end
    
    function [an,bn] = an_bn(m,x,nmax)
        % Computes Mie Coefficients, an, bn,
        % of orders n=1 to nmax, for given complex refractive-index
        % and size parameter x=k0*radius
        % Eq. (4.88) of Bohren and Huffman (1983)
        % using the recurrence relation (4.89) for Dn on p. 127 and
        % starting conditions as described in Appendix A.
        % C. Mätzler, July 2002
        % ffz2016
        % changed var names to be closer to BH, major cleanup.
        
       
        n=(1:nmax);
        
        %create spherical bessel functions
        sx=sqrt(0.5*pi/x);                      %factor for spherical bessel functions
        jn=sx.*besselj(n+0.5,x);                %j_(n)(x) (spherical bessel function 1. kind)
        jn1=[sin(x)/x, jn(1:nmax-1)];           %j_(n-1)(x) (spherical bessel function 1. kind)
        yn=sx.*bessely(n+0.5,x);                %y_(n)(x) (spherical bessel function 2. kind)
        yn1=[-cos(x)/x, yn(1:nmax-1)];          %y_(n-1)(x) (spherical bessel function 2. kind)
        
        
        %Computation of Dn(z) according to (4.89) of B+H (1983)
        z=m.*x;
        nmx=round(max(nmax,abs(z))+16);
        dn(nmx)=0+0i;
        for j=nmx:-1:2
            dn(j-1)=j./z-1/(dn(j)+j./z);
        end
        dn=dn(1:nmax);
        
        %Computation of an,bn
        psin=x*jn; psin1=x*jn1;                 %psi(x), see p. 128
        chin=psin+1i*x*yn; chin1=psin1+1i*x*yn1;%chi(x)
        
        da=dn./m+n./x;
        db=m.*dn+n./x;
        
        an=(da.*psin-psin1)./(da.*chin-chin1);
        bn=(db.*psin-psin1)./(db.*chin-chin1);
        
    end
    
    
end
