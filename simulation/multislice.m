function waveR=multislice(wavelength,objects,N,dx,deltaz,gpu,filter,debug)
    % calculate exitWave after scene.
    % Uses algorith similar to cowley or hare
    % wavelength (in nm),objects (cell arra),N,dx,distanceDetektor,gpu (bool use gpu),debug (bool show progress)
    
    if nargin<6||isempty(gpu);gpu=parallel.gpu.GPUDevice.isAvailable();end
    if nargin<7||isempty(filter); filter=false;end;

    k=2*pi/wavelength;
    Lz=dx*N/2; %max z values are half of N because Nx,Ny must be padded

    if gpu
        %input wave
        waveR=gpuArray.ones(N,N);
        zero=@()gpuArray.zeros(N,N);
    else
        waveR=ones(N,N);
        zero=@()zeros(N,N);
    end

    waveF=ift2(waveR)*(dx^2);

%     %windows function bw limiting, vgl. Kirkland
%     if filter
%         %bw limit input wave (not necessary if PW)
%         waveF=ft2(waveR)*(dx^2);
%         waveF=waveF.*w2;
%         waveR=ift2(waveF)/(dx^2);
%     end

    %prepare Objects and retrieve slice functions
    for nobj=length(objects):-1:1
        slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
    end

    %Propagator in fourier space for single step
    propagatorSingleStep=getPropagator(N,dx,wavelength,deltaz);

    %bw limit propagator, allows symetrical bw limit on propagator and transission->
    %better resolution, vgl kirkland
    if filter
        w=window(N);
        propagatorSingleStep=propagatorSingleStep.*w;
    end
    
    for z=-Lz/2:deltaz:Lz/2
        %get slices deltan
        dnSlice=zero();
        for nobj=1:length(objects)
            bd=(-objects{nobj}.delta+1i*objects{nobj}.beta);
            dnSlice=dnSlice+slicefun{nobj}(z)*bd;
        end

        %Transmission function
        if any(dnSlice(:))
            waveR=ft2(waveF)/(dx^2);
            transmissionR=exp((1i*k*deltaz)*dnSlice);
            if filter
                % Transmission bw limit
                transmissionR=ift2(ft2(transmissionR).*w);
            end
            %multiply wave=wave*transfer to get wave after transmission through slice
            waveR=waveR.*transmissionR;
            waveF=ift2(waveR)*(dx^2);
        end

        waveF=waveF.*propagatorSingleStep;
        
        if nargin>7&&isa(debug,'function_handle')
            debug(ft2(waveF)/(dx^2),z,dnSlice);
        end
    end
    waveR=ft2(waveF)/(dx^2);

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
        else
            range=linspace(-N/2,N/2-1,N)*(1/(N*dx));
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
        wt = 0.33*N;
        out = exp(-nsq.^8/wt^16);
    end
    
end

