function focused=focusExitwave(input,dx,wavelength,gpu,distance)
    % Finds focus of simulated 3d exitwave
    N=size(input,1); if size(input,2)~=N;error('input must be square');end
    if gpu
        range=gpuArray.linspace(-N/2,N/2-1,N)*(1/(N*dx));
        finput=ft2(gpuArray(input));
    else
        range=linspace(-N/2,N/2-1,N)*(1/(N*dx));
        finput=ft2(gather(input));
    end
    [uu,vv]=meshgrid(range,range);
    evanescence_mask=wavelength^-2>(uu.^2+vv.^2);
    propagatorexp=1i*2*pi*sqrt(complex(wavelength^-2-uu.^2-vv.^2)).*evanescence_mask;
    propagator=@(deltaz) exp(propagatorexp*deltaz).*evanescence_mask;
    clear uu vv range evanescence_mask propagatorexp
    propagated=@(dz)ift2(finput.*propagator(dz));
    metric_v=@(img) gather(var(abs(img(:)-img(1))));
    if nargin<5
        distance=fminsearch(@(dz) -metric_v(propagated(dz)),0);
    end
  
%     dist=-200:dx/2:200;
%     err=zeros(size(dist));
%     for n=1:numel(dist)
%         z=dist(n);
%         err(n)=metric_v(propagated(z));
%     end
%     figure();
%     plot(dist,err);
%     [~,p]=max(err(:));
%     distance=dist(p);
    
    focused=propagated(distance);
end