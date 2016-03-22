lambda=0.001;
N=256;


U0=ones(N/2,N/2);
U0=padarray(U0,[N/4,N/4]);
k=2*pi/lambda;
dx=1;
dy=1;
z=10000;

[ny, nx] = size(U0);

Lx = dx * nx;
Ly = dy * ny;

dfx = 1./Lx;
dfy = 1./Ly;

u = ones(nx,1)*((1:nx)-nx/2)*dfx;
v = ((1:ny)-ny/2)'*ones(1,ny)*dfy;

O = fftshift(fft2(fftshift(U0)));

H = exp(1i*k*z).*exp(-1i*pi*lambda*z*(u.^2+v.^2));

U = ifftshift(ifft2(ifftshift(O.*H)));
imagesc(1:size(U,1),1:size(U,2),abs(U));