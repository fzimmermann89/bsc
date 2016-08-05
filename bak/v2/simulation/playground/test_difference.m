
figure(456)
tic
for n=1:40
[xMulti,yMulti]=difference(gpuArray(angleMulti),gpuArray(pMulti),gpuArray(angleMie),gpuArray(pMie));
[xMSFT,yMSFT]=difference(gpuArray(angleMSFT),gpuArray(pMSFT),gpuArray(angleMie),gpuArray(pMie));
[xT,yT]=difference(gpuArray(angleT),gpuArray(pT),gpuArray(angleMie),gpuArray(pMie));
end
toc
plot(xMulti,yMulti);hold on
plot(xMSFT,yMSFT);hold on
plot(xT,yT);hold off
axis([0,0.5,-1,1])
% set(gca,'YScale','log');
legend('multi','msft','thibault');

