close all
clear all
input1=gpuArray(imread('input_1.png'));

input1=sum(input1,3)./3;
input1=padarray(input1,[256,256],0);
inputSize=max(size(input1,1),size(input1,2));
% input2 = flip(flip(input1,2),1);    
input2=abs(ift2(conj(ft2(input1))));
[nx, ny] = meshgrid(linspace(-inputSize/2,inputSize/2-1,inputSize));
nsq = nx.^2 + ny.^2;
wt = 0.1*inputSize;
mask = 1%1-exp(-nsq.^8/wt^16);

% F=ft2(input1);
% Fabs=abs((F).*mask);
% Fabs=padarray(Fabs,[1024,1024],0);
% iFabs=ift2(Fabs);
% figure(2)
% subplot(3,2,1);imagesc((input1));
% subplot(3,2,2);imagesc((mask));
% subplot(3,2,3);imagesc((abs(Fabs)));
% subplot(3,2,4);imagesc((real(iFabs)));
% caxis([0,5])
outconv=conv2(input1,input2,'same');
Fi1=ft2(input1);
Fi2=ft2(input2);
outf=ift2(abs(Fi1).^2)%.*conj(Fi1));
figure(1)
subplot(2,2,1);imagesc((input1));
subplot(2,2,2);imagesc((input2));
subplot(2,2,3);imagesc((outconv));caxis([0,200])
subplot(2,2,4);imagesc(abs(outf));caxis([0,200])
% 
% input1=gpuArray(imread('input_obj1.png'));
% input1=255-padarray(sum(input1,3)./3,[256,256],255);
% input1=gpuArray.ones(256);
% input1=padarray(input1,[256,256]);
% 
% % input2=gpuArray(imread('input_ref1.png'));
% % input2=input2./sum(input2(:));
% % input2=padarray(sum(input2,3)./3,[512,512],0);
% input2=gpuArray.ones(size(input1));
% conv12=conv2(input1,input2,'same');
% conv12=conv12-min(conv12(:));
% figure(2)
% subplot(2,1,1)
% imagesc(input1);axis square;
% subplot(2,1,2)
% imagesc(input2);axis square;
% 
% figure(3)
% imagesc(conv12);axis square;