% Draw figure illustrating the importance of the fourier phase

addpath('helper')

l=imread('Tex/images/src/lena.tif');
d=imread('Tex/images/src/david.tif');
L=ft2(l);
D=ft2(d);

Lp=angle(L);
La=abs(L);
Dp=angle(D);
Da=abs(D);

lpda=uint8(abs(ift2(exp(1i*Lp).*Da)));
dpla=uint8(abs(ift2(exp(1i*Dp).*La)));

figure(1)
subplot(2,2,1);
imshow(l)

subplot(2,2,2);
imshow(dpla)

subplot(2,2,3);
imshow(d)

subplot(2,2,4);
imshow(lpda)

print('Tex/images/src/phaseswap.pdf','-dpdf')