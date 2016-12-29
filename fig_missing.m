N=256;
wm=8;
ws=80;
x=-N/2:N/2-1;
filename='./Tex/images/src/missing.pdf';

ft =@(in) fftshift( fft(ifftshift(in)));
ift=@(in) fftshift(ifft(ifftshift(in)));
p=@(in) plot(abs(in)./max(abs(in(:))));
blue=[48,38,131]./255;
green=[0,150,64]./255;
red=[227,5,19]./255;
yellow=[249,178,51]./255;

fun1=normpdf(x,0,30);
fun2=normpdf(x,0,20);
fun3=normpdf(x,0,2);

mask=ones(1,N);
mask(end/2+1-wm:end/2+1+wm)=0;
imask=1-mask;

support=zeros(1,N);
support(end/2+1-ws:end/2+1+ws)=1;
isupport=1-support;


figure(1);clf;
subplot(1,2,1);hold on
a2=area(imask);
a2.FaceColor=green;
p(ft(fun1));
p(ft(fun2));
p(ft(fun3));
axis off;

subplot(1,2,2);hold on;
a1=area(isupport);
a1.FaceColor=red;
p(fun1);
p(fun2);
p(fun3);
axis off;

print(filename,'-dpdf')