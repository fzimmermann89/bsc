% Testbench for the polyhedrons used as scatterobject

clear all;
%% Benchmark
tic
N=128;
dx=55;
deltaz=dx/8;
s=scatterObjects.cube();
s.radius=50;
f=s.prepareSliceMethod(N,dx,true);
aus=zeros(20000,1,'gpuArray');
in=zeros(20000,1,'gpuArray');
for n=1:20000
    z=n/100-100;
    tmp=f(z);
    aus(n)=sum(tmp(:));
    in(n)=z;
end
figure(1)
plot(in,aus);
toc
figure(2);

a=f(-42.5);
t=imag(fftshift(fft2(fftshift(a))));
subplot(2,1,1);
imagesc(1:N,1:N,t);axis square;
subplot(2,1,2);
imagesc(1:N,1:N,a);axis square;


tic
c=scatterObjects.cube(N,true);
c.rotationY=45;
c.rotationX=45;
f1=c.getSliceMethod();
o=scatterObjects.octahedron(N,true);
o.rotationY=45;
o.rotationX=45;
f2=o.getSliceMethod();
i=scatterObjects.icosahedron(N,true);
i.rotationY=45;
i.rotationX=45;
f3=i.getSliceMethod();
d=scatterObjects.dodecahedron(N,true);
d.rotationY=45;
d.rotationX=45;
f4=d.getSliceMethod();
t=scatterObjects.tetrahedron(N,true);
t.rotationY=45;
t.rotationX=45;
f5=t.getSliceMethod();

for z=1:deltaz:N
    out=out+f1(z)+f2(z)+f3(z)+f4(z)+f5(z);
end

ol=gather(out);
toc

%% Animation
N=1024;
figure;
filename = 'testAnimated_ico2.gif';
i=scatterObjects.icosahedron(N,true);
i.rotationY=60;
for n = 1:N
    imagesc(1:N,1:N,i.getSlice(n));colormap(hot);caxis([0 1]);axis 'square'
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    if n == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end