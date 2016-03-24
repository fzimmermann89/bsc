function [theta,intensity]=rayleigh(radius,wavelength,N)
    % calculate Rayleigh–Debye–Gans intensity profile
    % of a sphere with given radius at given wavelength in N steps.
    % returns matrix with angles and matrix with normalized intensities.
    % see "Patterns in Mie scattering", C.M. Sorensen
    
    if ~exist('N','var');N=1000;end;
    theta=linspace(0,pi,N);
    q=4*pi/wavelength*sin(theta./2);
    j1=@(x)(sin(x)./x.^2-cos(x)./x);
    intensity=(j1(q.*radius)./q.*radius).^2;
end