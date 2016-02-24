% test_polyhedron
% Elapsed time is 16.659653 seconds.
% test_polyhedron
% Elapsed time is 15.727255 seconds.
% test_polyhedron
% Elapsed time is 15.802378 seconds.
clear all;
tic
N=100;
dx=55;
deltaz=dx/8;
s=scatterObjects.sphere();
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
% imagesc(-(N-1)/2*dx:(N-1)/2*dx,-(N-1)/2*dx:(N-1)/2*dx,f(0));axis square;
figure(2);

  a=f(-42.5);
   t=imag(fftshift(fft2(fftshift(a))));
  subplot(2,1,1);
 imagesc(1:N,1:N,t);axis square;
   subplot(2,1,2);
    imagesc(1:N,1:N,a);axis square;
% %gpu
% %warmup
% % c=scatterObjects.cube(N,true);
% % c.rotationY=45;
% % c.rotationX=45;
% % c=scatterObjects.cube(N,true);
% % c.rotationY=45;
% % c.rotationX=45;
% % f{1}=c.getSliceMethod();
% % o=scatterObjects.octahedron(N,true);
% % o.rotationY=45;
% % o.rotationX=45;
% % f{2}=o.getSliceMethod();
% % i=scatterObjects.icosahedron(N,true);
% % i.rotationY=45;
% % i.rotationX=45;
% % f{3}=i.getSliceMethod();
% % d=scatterObjects.dodecahedron(N,true);
% % d.rotationY=45;
% % d.rotationX=45;
% % f{4}=d.getSliceMethod();
% % t=scatterObjects.dodecahedron(N,true);
% % t.rotationY=45;
% % t.rotationX=45;
% % f{5}=t.getSliceMethod();
% % % s=scatterObjects.sphere(N,true);
% % % s.x=45;
% % % f{6}=s.getSliceMethod();
% % out=gpuArray.zeros(N,N);
% % for z=1:N
% %     for n=1:length(f)
% %         out=out+f{n}(z);
% %     end
% % end
% 
% % [r,c,v] = ind2sub(size(out),find(out == 1));
% % scatter3(r,c,v);
% % %benchmark
% tic
% c=scatterObjects.cube(N,true);
% c.rotationY=45;
% c.rotationX=45;
% f1=c.getSliceMethod();
% o=scatterObjects.octahedron(N,true);
% o.rotationY=45;
% o.rotationX=45;
% f2=o.getSliceMethod();
% i=scatterObjects.icosahedron(N,true);
% i.rotationY=45;
% i.rotationX=45;
% f3=i.getSliceMethod();
% d=scatterObjects.dodecahedron(N,true);
% d.rotationY=45;
% d.rotationX=45;
% f4=d.getSliceMethod();
% t=scatterObjects.dodecahedron(N,true);
% t.rotationY=45;
% t.rotationX=45;
% f5=t.getSliceMethod();
% % s=scatterObjects.sphere(N,true);
% % s.x=45;
% % f{6}=s.getSliceMethod();
% out=gpuArray.zeros(N,N);
% for z=1:deltaz:N
% %     for n=1:length(f)
% %         out=out+f{n}(z);
% %     end
% out=out+f1(z)+f2(z)+f3(z)+f4(z)+f5(z);
% end
% 
% ol=gather(out);
% toc
% 
% % %cpu
% % %warmup
% % % c2=scatterObjects.cube(N,false);
% % % tic
% % % c2.rotationY=45;
% % % toc
% % % c2.rotationX=45;
% % % o2=scatterObjects.octahedron(N,false);
% % % i2=scatterObjects.icosahedron(N,false);
% % % d2=scatterObjects.dodecahedron(N,false);
% % % t2=scatterObjects.dodecahedron(N,false);
% % % s2=scatterObjects.sphere(N,false);
% % % out2=zeros(N,N);
% % % for z=1:N
% % % out2=out2+c2.getSlice(z);
% % % out2=out2+o2.getSlice(z);
% % % out2=out2+i2.getSlice(z);
% % % out2=out2+d2.getSlice(z);
% % % out2=out2+t2.getSlice(z);
% % % out2=out2+s2.getSlice(z);
% % % end
% %
% % % %benchmark
% % % tic
% % % c2=scatterObjects.cube(N,false);
% % % o2=scatterObjects.octahedron(N,false);
% % % i2=scatterObjects.icosahedron(N,false);
% % % d2=scatterObjects.dodecahedron(N,false);
% % % t2=scatterObjects.dodecahedron(N,false);
% % % s2=scatterObjects.sphere(N,false);
% % % out2=zeros(N,N);
% % % for z=1:N
% % % out2=out2+c2.getSlice(z);
% % % out2=out2+o2.getSlice(z);
% % % out2=out2+i2.getSlice(z);
% % % out2=out2+d2.getSlice(z);
% % % out2=out2+t2.getSlice(z);
% % % out2=out2+s2.getSlice(z);
% % % end
% % % toc
% % %
% % %
% % %
% % %
% % % figure(1);
% % %subplot(1,2,1);
% % imagesc(1:N,1:N,out);colormap(hot);axis 'square';
% % %subplot(1,2,2);
% % % imagesc(1:N,1:N,out);colormap(hot);axis 'square';
% % clear all;
% % N=1024;
% % figure(1);
% % filename = 'testAnimated_ico2.gif';
% %  i=scatterObjects.icosahedron(N,true);
% %  i.rotationY=60;
% % for n = 1:N
% % imagesc(1:N,1:N,i.getSlice(n));colormap(hot);caxis([0 1]);axis 'square'
% % drawnow
% % frame = getframe(1);
% % im = frame2im(frame);
% % [A,map] = rgb2ind(im,256);
% % 	if n == 1;
% % 		imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.1);
% % 	else
% % 		imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
% % 	end
% % end