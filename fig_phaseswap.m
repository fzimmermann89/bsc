addpath('helper')

l=imread('Tex/images/src/lena2.tif');
d=imread('Tex/images/src/david2.tif');
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

% %Mean intensity 
% figure(2)
% Ma=(La+Da)./2;
% lm=uint8(abs(ift2(exp(1i*Lp).*Ma)));
% dm=uint8(abs(ift2(exp(1i*Dp).*Ma)));
% subplot(2,1,1); imshow(lm);
% subplot(2,1,2);imshow(dm);
% %Intensity plot
% figure(3);clf
% hold on;
% [~,rl]=rprofil(log(La));
% [~,rd]=rprofil(log(Da));
% plot((rl));
% plot((rd));