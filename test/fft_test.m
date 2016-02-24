clear all
%clear classes
% in(1)=(rand(4*1024) * 2-ones(4*1024));
% in(2)=(rand(4*1024) * 2-ones(4*1024));
% in(3)=(rand(4*1024) * 2-ones(4*1024));
% in(4)=(rand(4*1024) * 2-ones(4*1024));
% 
% sin=single(in);
% fin32=fi(in,1,32);
% tic
tic

max=10;
in=zeros(4*1024,4*1024,max);
out=complex(zeros(4*1024,4*1024));
for n=1:max
   in(:,:,n)= (rand(4*1024) * 2-ones(4*1024));
end

parfor n=1:max
    tmp=fft2(in(:,:,n))
end
toc
% out
% for n=1:10
%     out=fft2(in(n,:,:)
    

% for n=0:10
%     
%     
%     in=fft2(in);
%     in=fft2(in);
%     in=in./1000;
%     in=ifft2(in);
% 

% end
% toc
% tic
% for n=0:10
%     
%     
%     sin=fft2(sin);
%     sin=fft2(sin);
%     sin=sin./1000;
%     sin=ifft2(sin);
% 
%     
% end
% toc
% 
% tic
% for n=0:10
%     
%     
%     fin32=fft2(fin32);
%     fin32=fft2(fin32);
%     fin32=fin32./1000;
%     fin32=ifft2(fin32);
%   
% end
% toc

%max(max(((sin-in)./in)))
