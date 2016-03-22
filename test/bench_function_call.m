function bench_function_call

N=1024;
Nz=1024;


%  bench_function_call nz=1024 n=1024
% bsx
% Elapsed time is 7.629111 seconds.
% object_gpu
% Elapsed time is 10.409005 seconds.
% gpu1
% Elapsed time is 1.720740 seconds.
% cpu1
% Elapsed time is 7.083174 seconds.
% object
% Elapsed time is 6.345762 seconds.
% object_getfun
% Elapsed time is 4.049327 seconds.
% getfun
% Elapsed time is 4.383355 seconds.
% direkt
% Elapsed time is 3.344849 seconds.
% fun
% Elapsed time is 4.372790 seconds.
% fun
% Elapsed time is 4.349398 seconds.
% fun handler
% Elapsed time is 4.027002 seconds.


display('bsx')
tic
 x=1:N;
 y=x.';
 tmp=zeros(N,N);

for z=1:Nz
 f=@(xx,yy) (xx).^2+(yy).^2+(z)^2 <=400^2 ;
 slice=(bsxfun(f,x,y));

 tmp=tmp+slice;
end
toc

display('object_gpu')
tic
obj=osphere(N,400);
fung=@obj.gpu_slice;
tmp=zeros(N,N);
for n=1:Nz
    slice=fung(n);
    tmp=tmp+slice;
end
toc

display('gpu1')
tic
tmp=gpuArray(zeros(N,N));
for n=1:Nz

    slice=sphere_gpu(n,N,400);
    tmp=tmp+slice;
end
tmp2=gather(tmp);
toc

% display('gpu2')
% tic;
% z=gpuArray.linspace(1,Nz,Nz);
% gpuArray.arrayfun(sphere_cpu,z,N,400);
% toc

display('cpu1')
tic
tmp=(zeros(N,N));
for n=1:Nz

    slice=sphere_cpu(n,N,400);
    tmp=tmp+slice;
end
toc

display('object')
tic
obj=osphere(N,400);
fun=@obj.getslice;
tmp=zeros(N,N);
for n=1:Nz
    slice=fun(n);
    tmp=tmp+slice;
end
toc



display('object_getfun')
tic
obj=osphere(N,400);
fun=obj.getslicefunc();
tmp=zeros(N,N);
for n=1:Nz
    slice=double(fun(n));
    tmp=tmp+slice;
end
toc

display('getfun')
tic
fun2=osphere.getslicefun(N,400);
tmp=zeros(N,N);
for n=1:Nz
    slice=fun2(n);
    tmp=tmp+slice;
end
toc


display('direkt')
tic
tmp=zeros(N,N);
[X,Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);

for n=1:Nz
   slice=double((X.^2+Y.^2+n^2) <= (400)^2);
    tmp = tmp+ slice;
end
toc

% display('arrayfun')
% tic
% tmp=zeros(N,N);
% [X,Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);
% XY=X.^2+Y.^2;
% for n=1:10
%    slice=arrayfun(@(xy)slicefun3(n,xy),XY);
%     tmp = tmp+ slice;
% end
% toc

display('fun')
tic
tmp=zeros(N,N);
[X,Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);

for n=1:Nz
    slice=slicefun(n,400,X,Y);
    tmp=tmp+slice;
end
toc


display('fun')
tic
tmp=zeros(N,N);
[X,Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);

for n=1:Nz
    slice=slicefun(n,400,X,Y);
    tmp=tmp+slice;
end
toc
display('fun handler')
tic
tmp=zeros(N,N);
[X,Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);
XY=X.*X+Y.*Y;
han=@(n)double(slicefun2(n,400^2,XY));
for n=1:Nz
    slice=han(n);
    tmp=tmp+slice;
end
toc

% display('rand')
% disp('direkt')
% tic
% tmp=0;
% for n=1:Nz
%     tmp=tmp+rand(1);
% end
% toc
%
% disp('func')
% tic
% tmp=0;
% for n=1:Nz
%     tmp=tmp+test_rand(1);
% end
% toc
%
% disp('handle')
% handle=@test_rand;
% tic
% tmp=0;
% for n=1:Nz
%     tmp=tmp+handle(1);
% end
% toc
%
% disp('anon')
% handle1=@()test_rand(1);
% tic
% tmp=0;
% for n=1:Nz
%     tmp=tmp+handle1();
% end
% toc

    function out=test_rand(a)
        out=rand(a);
    end


    function slice=slicefun(z,radius,X,Y)
        slice = double((X.^2+Y.^2+z^2) <= (radius)^2);
    end
   function slice=slicefun2(z,radius2,XY)
        slice = double((XY+z^2) <= (radius2));
   end
  function slice=slicefun3(z,XY)
        slice = double((XY+z^2) <= (400^2));
   end
end