% example_square_prop_one_step.m
function test_fresnel
N = 1024; % number of grid points per side
L = 1e-2; % total size of the grid [m]
delta1 = L / N; % grid spacing [m]
D = 2e-3; % diameter of the aperture [m]
wvl = 1e-6; % optical wavelength [m]
k = 2*pi / wvl;
Dz = 1; % propagation distance [m]

[x1 y1] = meshgrid((-N/2 : N/2-1) * delta1);
ap = rect(x1/D) .* rect(y1/D);
[x2 y2 Uout] = one_step_prop(ap, wvl, delta1, Dz);
im=(abs(Uout).^2);
imshow(im);
% analytic result for y2=0 slice
 Uout_an  = fresnel_prop_square_ap(x2(N/2+1,:), 0, D, wvl, Dz);


    function U = fresnel_prop_square_ap(x2, y2, D1, wvl, Dz)
 % function U = fresnel_prop_square_ap(x2, y2, D1, wvl, Dz)

 N_F = (D1/2)^2 / (wvl * Dz); % Fresnel number
 % substitutions
 bigX = x2 / sqrt(wvl*Dz);
 bigY = y2 / sqrt(wvl*Dz);
 alpha1 = -sqrt(2) * (sqrt(N_F) + bigX);
 alpha2 = sqrt(2) * (sqrt(N_F) - bigX);
 beta1 = -sqrt(2) * (sqrt(N_F) + bigY);
 beta2 = sqrt(2) * (sqrt(N_F) - bigY);
 % Fresnel sine and cosine integrals
 ca1 = mfun('FresnelC', alpha1);
 sa1 = mfun('FresnelS', alpha1);
 ca2 = mfun('FresnelC', alpha2);
 sa2 = mfun('FresnelS', alpha2);
 cb1 = mfun('FresnelC', beta1);
 sb1 = mfun('FresnelS', beta1);
 cb2 = mfun('FresnelC', beta2);
 sb2 = mfun('FresnelS', beta2);
 % observation-plane field
 U = 1 /(2*i) *((ca2 - ca1) + i * (sa2 - sa1)) ...
 .* ((cb2 - cb1) + i * (sb2 - sb1));
    end

    function G = ft2(g, delta)
        G = fftshift(fft2(fftshift(g))) * delta^2;
    end
    function y = rect(x, D)
        % function y = rect(x, D)
        if nargin == 1, D = 1; end
        x = abs(x);
        y = double(x<D/2);
        y(x == D/2) = 0.5;

    end
    function [x2, y2, Uout]  = one_step_prop(Uin, lambda, d1, Dz)

        N = size(Uin, 1); % assume square grid
        k = 2*pi/lambda; % optical wavevector
        % source-plane coordinates
        [x1, y1] = meshgrid((-N/2 : 1 : N/2 - 1) * d1);
        % observation-plane coordinates
        [x2, y2] = meshgrid((-N/2 : N/2-1) / (N*d1)*lambda*Dz);
        % evaluate the Fresnel-Kirchhoff integral
        Uout = 1 / (1i*lambda*Dz) ...
            .* exp(1i * k/(2*Dz) * (x2.^2 + y2.^2)) ...
            .* ft2(Uin .* exp(1i * k/(2*Dz) ...
            * (x1.^2 + y1.^2)), d1);
    end
end