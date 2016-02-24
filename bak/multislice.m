
function out=multislice(wavelength,objects,N,dx,distanceDetektor,gpu,maskactive)
    tmp=0;
    if gpu
%         g=gpuDevice;
        one=gpuArray.ones(N,N);
        zero=gpuArray.zeros(N,N);
    else
        one=ones(N,N);
        zero=zeros(N,N);
    end
    k=2*pi/wavelength;
    mask=getMask(N);
    display('start');
    wave=ft2(one);
    plot(1);
    imagesc(1:N,1:N,abs(wave));
    caxis([0.5 1.5]);
    colorbar;
    
    %super gauss filter
    %     [nx ny] = meshgrid((-N/2 : 1 : N/2 - 1));
    %  nsq = nx.^2 + ny.^2;
    %  w = 0.47*N;
    % mask2 = exp(-nsq.^8/w^16);
    
    
    %prepare Objects and retrieve slice functions
    for nobj=length(objects):-1:1
        slicefun{nobj}=objects(nobj).prepareSliceMethod(N,dx,gpu);
    end
    
    drawnow;
    deltaz=dx/4;
    Lz=dx*N/2;
    (k*2)/(2*deltaz)
    
    propagator=getPropagator();%(N,wavelength,deltaz);
%     %     propReal=getPropagatorReal();
%     % %     propReal=padarray(propReal,[N,N]);
%     %     prop2=ift2(propagator);
%     % %     propagator=ift2(propagator);
%     % %     propagator(mask)=0;
%     % %     propagator=ft2(propagator);
%     %     figure(2)
%     figure(2)
%     imag2show=(getPropagatorReal());
%     imag2show=ft2(imag2show);
%     imag2show(mask)=0;
%     imag2show=ift2(imag2show);
%     subplot(1,3,1)
%     imagesc(1:N,1:N,abs(imag2show));axis square;axis off;
%     subplot(1,3,2)
%     imagesc(1:N,1:N,real(imag2show));axis square;axis off;
%     subplot(1,3,3)
%     imagesc(1:N,1:N,imag(imag2show));axis square;axis off;
%     figure(3)
%     imag2show=ift2(getPropagator());
%     % imag2show=ft2(padarray(imag2show,[N/2,N/2]));
%     subplot(1,3,1)
%     imagesc(1:N,1:N,(abs(imag2show)));axis square; axis off;
%     subplot(1,3,2)
%     imagesc(1:N,1:N,real(imag2show));axis square;axis off;
%     subplot(1,3,3)
%     imagesc(1:N,1:N,imag(imag2show));axis square;axis off;
%     figure(1)
    % subplot(1,2,2)
    % plot(1:N,real(prop2(N/2,:)),'b',1:N,imag(prop2(N/2,:)),'r')
    %
    %     figure(1);
    %
    for z=-Lz:deltaz:Lz
        
        slice=one;
        
        %output of progress
        if tmp==100
            imagesc(1:N,1:N,abs(wave));
            title(sprintf('%d nm',round(z)));
            caxis([0.5 1.5]);
            colorbar;
            drawnow;
            tmp=0;
            %             pause(5);
        else
            tmp=tmp+1;
        end
        
        %getslices
        %         for nobj=1:length(objects)
        %             %Set slice=refractive index<=> slice=1-sum_over_objects(delta+ibeta where getSlice==1, else 1);
        %             o=objects(nobj);
        %             bd=(o.delta+1i*o.beta);
        %             oslice=zero; %contribution of object o to current slice;
        %             osliceIndex=slicefun{nobj}(z); %where is the object?
        %             oslice(osliceIndex)=-bd; %its contribition
        %
        %             slice=slice+oslice;
        %         end
        
        
        
        %Transmission function, vgl Hare
        
        transmissionReal=exp((-1i*k*deltaz)*slice);
        
        if z==-Lz %just for debug: a single circlular slit at z=0
            range=linspace(-1,1,N);
            [xx,yy]=meshgrid(range,range);
            transmissionReal=xx.^2+yy.^2>(1/16)^2;
        end
        
        %Mask wave and transfer, vgl Kirkland book
        % transfer(mask)=0;
        if maskactive
%             wave(mask)=exp(-1i*k*(Lz+z)); %noch das beste XXXX
        end
        %         wave=ft2(wave);
        %         wave(mask)=0;
        %         wave=wave.*mask2;
        %         wave=ift2(wave);
        
        %         transmission=ft2(transmission);
        %         transmission(mask)=0;
        % transmission=transmission.*mask2;
        %         transmission=ift2(transmission);
        
        % wave=(wave-1).*gmask+1;
        transmission=ft2(transmissionReal);
        transmission(mask)=0;
        transmissionReal=ift2(transmission);
        %multiply wave=wave*transfer to get wave after transmission through slice
%         wave=wave.*transmission;
wave=ft2(ift2(wave).*(transmissionReal));
        %propagate (convulution with fresnel prop, evaluated by fft->mul->fft)
        %        wave(mask)=0;
%         wave=ft2(wave); %wave=fftshift(fft2((fftshift(wave)));
        
        %         wave(mask)=0;
        
        %         wave=ft2(wave);
        %         wave(mask)=0;
        %         wave=ift2(wave);
        
        %         propagator=ft2(propagator);
        %         propagator(mask)=0;
        %         propagator=ift2(propagator);
        %
        wave=wave.*propagator;
%         wave=ift2(wave);   %wave=ifftshift(ifft2(ifftshift(wave)));
        
        
    end
    
    %     %     projektion auf detektor
    %     image=project(wave,detektor);
    %     wave=ft2(wave);
    %     wave=wave.*getPropagatorDetektor(distanceDetektor);
    %     wave=ift2(wave);
    
    out=ift2(wave);
    %check intensity, should be close to 1 without absorption
    %     sum(abs(wave(:)))/((pi/9)*N*N) %with  mask?
    sum(abs(wave(:)))/(N*N)
    %unlock objects
    
    for nobj=length(objects):-1:1
        objects(nobj).unlock();
    end

function propagator=getPropagator()
    %seperate function to create closure for tmp variables
    if gpu
        
        range=gpuArray.linspace(-N/2,N/2-1,N)*(1/(N*dx));
        %     range=floor(linspace(-N/4,N/4-1/2,N))*2/N*dx;
    else
        range=linspace(-N/2,N/2-1,N)*(1/(N*dx)); %TODO
    end
    [uu,vv]=meshgrid(range,range);
    propagator=exp((uu.^2+vv.^2)*(-1i*pi*wavelength*deltaz)); %minus eingefügt XXXX
end

%NOT WORKING
function propagator=getPropagatorDetektor(distanceDetektor)%(N,wavelength,deltaz)
    %seperate function to create closure for tmp variables
    if gpu %scaling wrong
        range=gpuArray.linspace(-N/2,N/2,N);
    else
        range=linspace(-N/2,N/2,N);
    end
    %TODO x,y skalieren
    [xx,yy]=meshgrid(range,range);
    propagatorReal=exp(-1i*k*sqrt(xx.^2+yy.^2+distanceDetektor^2));
    propagator=ft2(propagatorReal);
end

function propagatorReal=getPropagatorReal%(N,wavelength,deltaz)
    %seperate function to create closure for tmp variables
    if gpu %scaling wrong
        %halbe bandbreite wäre floor(linspace(-N/4,N/4-1/2,N))*2
        range=gpuArray.linspace(-N/2,N/2-1,N)*dx;
    else
        range=linspace(-N/2,N/2-1,N)*dx;
    end
    %TODO x,y skalieren
    [xx,yy]=meshgrid(range,range);
%     propagatorReal=exp(-1i*k*sqrt(xx.^2+yy.^2+deltaz^2));
      propagatorReal=exp(-1i*k*(xx.^2+yy.^2)/(2*deltaz)); %genähert
end
function idx=getMask(N)
    if gpu
        range=gpuArray.linspace(-1,1,N);
    else
        range=linspace(-1,1,N);
    end
    [xx,yy]=meshgrid(range,range);
    
    idx=xx.^2+yy.^2>(1/8)^2;
    
end
end

