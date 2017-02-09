% Testbed for wiener deconvolution

close all
addpath('helper')
addpath('reconstruction')
ft =@(in) fftshift( fft(ifftshift(in)));
ift=@(in) fftshift(ifft(ifftshift(in)));

I = im2double(imread('cameraman.tif'));
imshow(I);
title('Original Image (courtesy of MIT)');

LEN = 21;
THETA = 11;
scale=10;
PSF = fspecial('motion', LEN, THETA).*scale;
blurred = imfilter(I, PSF, 'conv', 'circular');
figure, imshow(blurred)
PSF=PSF./sum(PSF(:));
noise_mean = 0;
noise_var = 0.0002;

blurred_noisy = scale*imnoise(blurred./scale, 'gaussian', ...
    noise_mean, noise_var);
noise=blurred_noisy-blurred;

figure, imagesc(blurred_noisy)
title('Simulate Blur and Noise')
colormap((colormap(gray)));colorbar;

estimated_nsr = noise_var / (var(I(:))/sum(PSF(:)));
cn=ift2(abs(ft2(noise)).^2);
ci=ift2(abs(ft2(I)).^2);
cb=ift2(abs(ft2(blurred_noisy)).^2);

wnr1 = wiener(blurred_noisy, pad2size(PSF,size(blurred_noisy)), estimated_nsr)./scale;
wnr2 = deconvwnr(blurred_noisy, pad2size(PSF,size(blurred_noisy)),estimated_nsr)./scale;

deconvt=@(w,s)s*wiener(blurred_noisy, pad2size(PSF,size(blurred_noisy)),w);
mse=@(in)mean((in(:)-I(:)).^2);
options = optimset('TolFun',1e-18,'TolX',1e-8);
p=fminsearch(@(p)mse(deconvt(p(1),p(2))),[estimated_nsr,1/scale],options);
ow=p(1);
os=p(2);
wnr3 =deconvt(ow,os);

figure, imagesc(wnr1)
title(strcat('wiener',num2str(mse(wnr1))));
colormap((colormap(gray)));colorbar;

figure, imagesc(wnr2)
title(strcat('deconvwnr',num2str(mse(wnr2))));
colormap((colormap(gray)));colorbar;

figure, imagesc(wnr3)
title(strcat('optim',num2str(mse(wnr3))));
colormap((colormap(gray)));colorbar;