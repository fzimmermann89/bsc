hioiter=50;
iter=400;
rec=10;
%load image and create fourier amplitude
input=gpuArray(rgb2gray(imread('input_2.png')));
tic
plan(1).algo='hio';
plan(1).iter=5;
plan(2).algo='er';
plan(2).iter=500;
% plan(3).algo='hio';
% plan(3).iter=5;
% plan(4).algo='er';
% plan(4).iter=50;

input=(double(padarray(input,size(input)/2,0))/255);
N=size(input);


Finput=ft2(input);
absFinput=abs(Finput).^2;

%create support
support=holoSupport(absFinput);

%initialize
amplitude=sqrt(absFinput);
randPhase=rand(size(absFinput));
curImage=support.*rand(size(absFinput)).*exp(2i*pi*randPhase);
errors=[];

for nplan=1:length(plan)
    switch plan(nplan).algo
        case 'hio'
            for niter=1:plan(nplan).iter
                [curImage,err]=HIOiter(amplitude, curImage, support );
                errors(end+1)=err;
                %                 fprintf('%f\n',err);
            end
        case 'er'
            for niter=1:plan(nplan).iter
                [curImage,err]=ERiter(amplitude, curImage, support );
                %                 fprintf('%f\n',err);
                errors(end+1)=err;
            end
        otherwise
            warning('unknown plan');
    end
end
fprintf('final: %f\n',errors(end));
%     % curImage=support;
%     %run ER
%     errors=zeros(iter/rec);
%     for n=1:1:hioiter
%         [curImage,err]=HIOiter(amplitude, curImage, support );
%         if mod(n,rec)==0
%             errors(n/rec)=err;
%             fprintf('%f\n',err);
%         end
%     end
%     for n=hioiter+1:iter
%
%         if mod(n,rec)==0
%             [curImage,err]=ERiter(amplitude, curImage, support );
%             errors(n/rec)=err;
%             fprintf('%f\n',err);
%
%         else
%             curImage=ERiter(amplitude, curImage, support );
%         end
%     end
%



figure(1)
subplot(2,2,1);imagesc(input);axis square;colormap gray;
subplot(2,2,2);imagesc(abs(ift2(absFinput)));axis square;colormap gray;caxis([0,24])
subplot(2,2,3);imagesc(support);axis square;colormap gray;
subplot(2,2,4);imagesc(abs(curImage));axis square;colormap gray;

figure(2)
plot(errors);

toc