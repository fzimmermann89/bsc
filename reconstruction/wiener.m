function [ output ] = wiener( input,h,noise,ps_signal,normalize )
    %Wiener deconvolution
    %                   H* S_signal
    % G     =  ------------------------------
    %            |H|^2 S_signal + S_noise
    %
    %noise can be a scalar value (Noise/Signal Ratio) or a power spectrum.
    %ps_signal can be the power spectrum of the signal, if not set the
    %power spectrum of input will be used
    %if normalize (default:false) normalize deconvolution filter 
    
    if any(size(input)~=size(h))
        error('input and h must have same dimensions')
    end
    
    %check if 1D or 2D and transform inputs
    if min([size(input),size(h)])>1
        is2d=true;
        if size(input,1)~=size(input,2)||bitand(size(input,1),1)
            error('inputs must be square matrixes of even length')
        end   
        H = ft2(h);
        Finput = ft2(input);
    else
        is2d=false;
        H = fftshift(fft(ifftshift(h)));
        Finput = fftshift(fft(ifftshift(input)));
    end
    
    if isscalar(noise)
        %heuristic wiener filter
        S=1;
        N=noise;
    else
        %power spectral density of image and noise
        if ~all(size(noise)==size(input))
            error('noise can be scalar or a matrix of the same size as input')
        end
        N = noise; 
        if nargin>3&&numel(ps_signal)==numel(N)
            %use power spectrum of signal
            S=ps_signal;
        else
            S = (abs(Finput).^2);
        end
    end
    
    %wiener filter
    G =(conj(H).*S)./max(eps,(abs(H).^2.*S+N));
    
    %normalize G
    if nargin>4&&normalize
        G(end/2+1,end/2+1)=1;
    end
    
    %deconvolution
    Foutput = Finput.*G;
    if is2d
        output = ift2(Foutput);
    else
        output=fftshift(ifft(ifftshift(Foutput)));
    end
    
end