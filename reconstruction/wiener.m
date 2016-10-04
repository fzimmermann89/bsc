function [ output ] = wiener( input,h,noise,normalize )
    %Wiener deconvolution
    %                   H* S_signal
    % G     =  ------------------------------
    %            |H|^2 S_signal + S_noise
    %(allows complex h)
    %if normalize (default:false) normalize output to input
   
    %ft inputs
    H = ft2(h);
    Finput = ft2(input);

    %power spectral density of input image
    S = abs(Finput).^2;

    %power spectral density of noise
    if isscalar(noise)
        N=noise*S;
    else
        Fnoise = ft2(noise);
        N = abs(Fnoise).^2;
    end

    %wiener filter
    G =(conj(H).*S)./(abs(H).^2.*S+N);

    %deconvolution
    Foutput = Finput.*G;
    output = ift2(Foutput);
    
    %normalize
    if nargin>3&&normalize
    output=output.*(sum(abs(input(:)))/sum(abs(output(:))));
    end
end

