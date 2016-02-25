close all
clear all
input1=gpuArray(imread('input_1.png'));

input1=sum(input1,3)./3;
input1=padarray(input1,[256,256],0);
inputSize=max(size(input1,1),size(input1,2));
Fi1=ft2(input1);
absFi1=abs(Fi1).^2;

outf=ift2(absFi1);
figure(1)
subplot(1,2,1);imagesc((input1));
subplot(1,2,2);imagesc(abs(outf));caxis([0,200])

support=holoSupport(absFi1);
figure(2)
imagesc(support);axis square;