
function exitWave=multislice(wavelength,objects,N,dx,gpu,debug)
    % calculate exitWave after scene.
    % wavelength (in nm),objects (cell arra),N,dx,distanceDetektor,gpu (bool use gpu),debug (bool show progress)
    
    deltaz=dx/2;
    k=2*pi/wavelength;
    Lz=dx*N/2; %max z values are half of N because Nx,Ny must be padded
    
    ndebug=0;
    
    if gpu
        one=gpuArray.ones(N,N);
        %         one2=gpuArray.ones(2*N,2*N);
        zero=gpuArray.zeros(N,N);
    else
        one=ones(N,N);
        zero=zeros(N,N);
    end
    
    %input wave
    waveR=one;
    
    %windows function bw limiting, vgl. Kirkland
    w=window(N);
    
        %bw limit input wave (not necessary if PW)
%             waveF=ft2(waveR)*(dx^2);
%             waveF=waveF.*w2;
%             waveR=ift2(waveF)/(dx^2);
%     
  %  display('start');
    
    %prepare Objects and retrieve slice functions
    for nobj=length(objects):-1:1
        slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
    end
    
    %Propagator in fourier space for single step
    propagatorSingleStep=getPropagator(N,dx,wavelength,deltaz);
    
    %bw limit propagator, allows symetrical bw limit on propagator and transission->
    %better resolution, vgl kirkland
%         propagatorSingleStep=propagatorSingleStep.*w;
    
    for z=-Lz/2:deltaz:Lz/2
        
        %output of progress if enabled every 100 iterations
        if debug&&ndebug==100
            imagesc(1:N,1:N,abs(waveR));
            title(sprintf('%d nm',round(z)));
            caxis([0.5 1.5]);
            drawnow;
            ndebug=0;
        else
            ndebug=ndebug+1;
        end
        
        %get slices
        curslice=zero;
        %slice=one %hare paper
        for nobj=1:length(objects)
            %                     %Set slice=refractive index<=> slice=1-sum_over_objects(delta+ibeta where getSlice==1, else 1) (hare);
            %Set slice=1-refractive index<=> slice=sum_over_objects(delta+ibeta where getSlice==1, else 0);
            o=objects{nobj};
            bd=(o.delta+1i*o.beta);
            %                     oslice=zero; %contribution of object o to current slice;
            osliceIndex=slicefun{nobj}(z); %where is the object?
            %                     oslice(osliceIndex)=-bd; %its contribition
            curslice=curslice-osliceIndex*bd;
            %                     slice=slice+oslice;
        end
        
        
        %Transmission function, vgl Hare
        if any(curslice(:))
            transmissionR=exp((-1i*k*deltaz)*curslice);
            
%             
% %             % Transmission bw limit
%             transmissionF=ft2(transmissionR);
%             transmissionF=transmissionF.*w;
%             transmissionR=ift2(transmissionF);
            
            %multiply wave=wave*transfer to get wave after transmission through slice
            waveR=waveR.*transmissionR;
        end
        %hint: going back and forth between real an fourier not necessary if there is no
        %slice. done anyways for debug
        
        waveF=ift2(waveR)*(dx^2);
        waveF=waveF.*propagatorSingleStep;
        waveR=ft2(waveF)/(dx^2);
        
    end

    exitWave=waveR;
    
    %check intensity, should be close to 1 without absorption
    %fprintf('Check= %f (should be ~1 w/o absorption)\n',  sum(abs(waveR(:)))/(N*N));
    
    %unlock objects
    for nobj=length(objects):-1:1
        objects{nobj}.unlock();
    end
    
    function propagator=getPropagator(N,dx,wavelength,deltaz)
        %propagator in fourier space
        %seperate function to create namespace for tmp variables
        if gpu
            range=gpuArray.linspace(-N/2,N/2-1,N)*(1/(N*dx));
            %     range=floor(linspace(-N/4,N/4-1/2,N))*2/N*dx;
        else
            range=linspace(-N/2,N/2-1,N)*(1/(N*dx)); %TODO
        end
        [uu,vv]=meshgrid(range,range);
        evanescence_mask=wavelength^-2>(uu.^2+vv.^2);
        propagator=exp(1i*deltaz*2*pi*sqrt(complex(wavelength^-2-uu.^2-vv.^2))).*evanescence_mask;
    end
    
    function out=window(N)
        %super gaussian window for N
        if gpu
            [nx, ny] = meshgrid(gpuArray.linspace(-N/2,N/2-1,N));
        else
            [nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
        end
        nsq = nx.^2 + ny.^2;
        wt = 0.25*N;
        out = exp(-nsq.^8/wt^16);
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
    
    
end

