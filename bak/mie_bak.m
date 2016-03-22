function [theta,Intensity]=mie(lambda,radius,beta,delta,forward)
    % returns intensity of mie scattering of a sphere of radius 'radius' (in nm)
    % and refractive index n=1-delta+ibeta at wavelength lambda (in nm).
    % only if forward==true, forward scattering will be included
    % uses Mie functions by C. Mätzler, May 2002.

    k=2*pi/lambda;                  % vacuum wave number in 1/nm
    x=gather(k*radius);             % size parameter
    steps=10000;                    % Number of steps
    refIndex=gather(1-delta+1i*beta);
    theta=linspace(0,pi,steps);

    if ~exist('forward','var');forward=true;end

    for nstep = steps:-1:1,
        u=cos(theta(nstep));
        a=mie_S12(refIndex,x,u,forward);
        SL= real(a(1)'*a(1))/(pi*x^2);
        SR= real(a(2)'*a(2))/(pi*x^2);
        Intensity(nstep)=0.5*(SL+SR);
    end;

    %% slightly modified functions by C. Mätzler,
    function result = mie_S12(m, x, u,forwardpeak)
        % Computation of Mie Scattering functions S1 and S2
        % for complex refractive index m=m'+im",
        % size parameter x=k0*a, and u=cos(scattering angle),
        % where k0=vacuum wave number, a=sphere radius;
        % s. p. 111-114, Bohren and Huffman (1983) BEWI:TDD122
        % C. Mätzler, May 2002.
        % Modified to unify mie_S12 and mie_S12nopeak

        nmax=round(2+x+4*x^(1/3));
        ab=mie_ab(m,x);
        an=ab(1,:);
        bn=ab(2,:);

        pt=mie_pt(u,nmax);
        pin =pt(1,:);
        tin =pt(2,:);

        n=(1:nmax);
        n2=(2*n+1)./(n.*(n+1));
        pin=n2.*pin;
        tin=n2.*tin;
        S1=(an*pin'+bn*tin');
        S2=(an*tin'+bn*pin');
        if forwardpeak
            result=[S1;S2];
        else
            xs=x.*sqrt(1-u.*u);
            % Computation of diffraction pattern S according to BH, p. 110
            if abs(xs)<0.0001
                S=x.*x*0.25.*(1+u);            % avoiding division by zero
            else
                % Computation of Mie Scattering functions S1 and S2
                % without the diffraction pattern to avoid the forward peak
                % of the scattering phase function.
                S=x.*x*0.5.*(1+u).*besselj(1,xs)./xs;
            end;
            % Subtracting the diffraction pattern to avoid the forward peak
            % of the scattering phase function.
            result=[S1-S;S2-S];
        end
    end


    function result=mie_pt(u,nmax)
        % pi_n and tau_n, -1 <= u <= 1, n1 integer from 1 to nmax
        % angular functions used in Mie Theory
        % Bohren and Huffman (1983), p. 94 - 95

        p(1)=1;
        t(1)=u;
        p(2)=3*u;
        t(2)=3*cos(2*acos(u));
        for n1=3:nmax,
            p1=(2*n1-1)./(n1-1).*p(n1-1).*u;
            p2=n1./(n1-1).*p(n1-2);
            p(n1)=p1-p2;
            t1=n1*u.*p(n1);
            t2=(n1+1).*p(n1-1);
            t(n1)=t1-t2;
        end;
        result=[p;t];
    end


    function result = mie_ab(m,x)
        % Computes a matrix of Mie Coefficients, an, bn,
        % of orders n=1 to nmax, for given complex refractive-index
        % ratio m=m'+im" and size parameter x=k0*a where k0= wave number in ambient
        % medium for spheres of radius a;
        % Eq. (4.88) of Bohren and Huffman (1983), BEWI:TDD122
        % using the recurrence relation (4.89) for Dn on p. 127 and
        % starting conditions as described in Appendix A.
        % C. Mätzler, July 2002

        z=m.*x;
        nmax=round(2+x+4*x.^(1/3));
        nmx=round(max(nmax,abs(z))+16);
        n=(1:nmax); nu = (n+0.5);

        sx=sqrt(0.5*pi*x);
        px=sx.*besselj(nu,x);
        p1x=[sin(x), px(1:nmax-1)];
        chx=-sx.*bessely(nu,x);
        ch1x=[cos(x), chx(1:nmax-1)];
        gsx=px-1i*chx; gs1x=p1x-1i*ch1x;
        dnx(nmx)=0+0i;
        for j=nmx:-1:2      % Computation of Dn(z) according to (4.89) of B+H (1983)
            dnx(j-1)=j./z-1/(dnx(j)+j./z);
        end;
        dn=dnx(n);          % Dn(z), n=1 to nmax
        da=dn./m+n./x;
        db=m.*dn+n./x;

        an=(da.*px-p1x)./(da.*gsx-gs1x);
        bn=(db.*px-p1x)./(db.*gsx-gs1x);

        result=[an; bn];
    end


end
