%clear all;
N=1024;
rep=1024;
a=0;
b=0;
c=0;

Nm=[N N];

x0=gpuArray(rand(Nm)+1i*rand(Nm));
tic
idx=getIdx(N);
for n=1:rep

    x1 = x0(idx{:});
    x1=fft2(x1);
    x1=x1(idx{:});
    %  xr=fftshift(real(x0),dim);
    %  xi=fftshift(imag(x0),dim);
    %  x1 =complex(xr,xi);
    %  x1=fft(x1,[],dim);
    %  xr=fftshift(real(x1),dim);
    %  xi=fftshift(imag(x1),dim);
    %  x1 =complex(xr,xi);
    %
    % clear xr xi;
    a=a+max(max(x1));
end
toc
tic
for n=1:rep


    x2 = fftshift(x0);
    x2=fft2(x2);
    x2=fftshift(x2);
    b=b+max(max(x2));
end
toc

tic

for n=1:rep


    x2 = circshift(x0,(floor(size(x0)/2)));
    x2=fft2(x2);
    x2=circshift2(x2,(floor(size(x2)/2)));
    b=b+max(max(x2));
end
toc


tic
for n=1:rep
    x3 = ft2(x0);
    c=c+max(max(x3));
end
toc

% clear all;
% N=1024;
% rep=1024;
% a=0;
% b=0;
% c=0;
%
% Nm=[N N];
%
% x0=(rand(Nm)+1i*rand(Nm));
% tic
% idx=getIdx(N);
% for n=1:rep
%
%     x1 = x0(idx{:});
%     x1=fft2(x1);
%     x1=x1(idx{:});
%     %  xr=fftshift(real(x0),dim);
%     %  xi=fftshift(imag(x0),dim);
%     %  x1 =complex(xr,xi);
%     %  x1=fft(x1,[],dim);
%     %  xr=fftshift(real(x1),dim);
%     %  xi=fftshift(imag(x1),dim);
%     %  x1 =complex(xr,xi);
%     %
%     % clear xr xi;
%     a=a+max(max(x1));
% end
% toc
% tic
% for n=1:rep
%
%
%     x2 = fftshift(x0);
%     x2=fft2(x2);
%     x2=fftshift(x2);
%     b=b+max(max(x2));
% end
% toc
% tic
% for n=1:rep
%     x3 = ft2(x0);
%     c=c+max(max(x3));
% end
% toc



