function [theta,intensity]=rayleigh(radius,wavelength,steps)
    % calculate Rayleigh–Debye–Gans intensity profile
    % of a sphere with given radius at given wavelength in N steps.
    % returns matrix with angles and matrix with normalized intensities.
    % see "Patterns in Mie scattering", C.M. Sorensen
    
    if ~exist('steps','var');steps=10000;end
    if length(steps)==1
      theta=linspace(0,pi,steps)';
    else
      theta=gather(steps(:));
    end
    
    q=4*pi/wavelength*sin(theta./2);
    j1=@(x)(sin(x)./x.^2-cos(x)./x);
    intensity=(j1(q.*radius)./q.*radius).^2;
end