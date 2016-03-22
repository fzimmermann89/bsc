
function out=multislice(wavelength,objects,N,dx,distanceDetektor,gpu,maskactive)


    deltaz=dx/2;
    k=2*pi/wavelength;

       Lz=dx*N/2;

    tmp=0;
    if gpu
        one=gpuArray.ones(N,N);
        one2=gpuArray.ones(N,N);
        zero=gpuArray.zeros(N,N);
    else
        one=ones(N,N);
        zero=zeros(N,N);
    end
    k=2*pi/wavelength;


%     % % kreisförmiger input
% [nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
% radius=N/4;
% waveR=(nx.^2+ny.^2)<radius^2;

%eingangswelle gepadded auf 2N
waveR=padarray(one,[N/2,N/2],1);

    %super gaussian windows for N and 2N
    [nx, ny] = meshgrid(linspace(-N/2,N/2-1,N));
    nsq = nx.^2 + ny.^2;
    wt = 0.25*N;
    w = exp(-nsq.^8/wt^16);
    [nx2, ny2] = meshgrid(linspace(-N,N-1,2*N));
    nsq2 = nx2.^2 + ny2.^2;
    wt2 = 0.25*(2*N);
    w2 = exp(-nsq2.^8/wt2^16);

    %Eingang bandbreiten beschränken
        waveF=ft2(waveR)*(dx^2);
        waveF=waveF.*w2;
        waveR=ift2(waveF)/(dx^2);

    display('start');

    plot(1);
    imagesc(1:N,1:N,abs(waveR));
    caxis([0.5 1.5]);
    colorbar;



    %prepare Objects and retrieve slice functions
    for nobj=length(objects):-1:1
        slicefun{nobj}=objects(nobj).prepareSliceMethod(N,dx,gpu);
    end

    drawnow;



    %Propagator im Fourier Raum
    propagator=getPropagator();
    propagator=propagator.*w;
    %padden im Realraum
    propagator=ft2(padarray(ift2(propagator),[N/2,N/2]));
    for z=-Lz:deltaz:Lz



        %output of progress
        if tmp==100
            imagesc(1:N,1:N,abs(waveR));
            title(sprintf('%d nm',round(z)));
            caxis([0.5 1.5]);
            colorbar;
            drawnow;
            tmp=0;
        else
            tmp=tmp+1;
        end

        slice=one;
        %getslices
                for nobj=1:length(objects)
                    %Set slice=refractive index<=> slice=1-sum_over_objects(delta+ibeta where getSlice==1, else 1);
                    o=objects(nobj);
                    bd=(o.delta+1i*o.beta);
                    oslice=zero; %contribution of object o to current slice;
                    osliceIndex=slicefun{nobj}(z); %where is the object?
                    oslice(osliceIndex)=-bd; %its contribition

                    slice=slice+oslice;
                end





%               if abs(z)<deltaz %just for debug: a single circlular slit at z=0
%                     range=linspace(-1,1,N);
%                     [xx,yy]=meshgrid(range,range);
%                     slice=xx.^2+yy.^2>(1/4)^2;
%               end

%Transmission function, vgl Hare
                transmissionR=exp((-1i*k*deltaz)*slice);


        %Transmission bandbreiten beschränken
                transmissionF=ft2(transmissionR);
                transmissionF=transmissionF.*w;
                transmissionR=ift2(transmissionF);
        %und padden
        transmissionR=padarray(transmissionR,[N/2,N/2],exp(-1i*k*deltaz));

%         multiply wave=wave*transfer to get wave after transmission through slice
        waveR=waveR.*transmissionR;

        %wellenfeld räumlich beschränken
%         waveR=waveR.*w+exp(-1i*k*z).*(1-w);
        waveF=ft2(waveR)*(dx^2);
        waveF=waveF.*propagator;
        waveR=ift2(waveF)/(dx^2);

    end


    out=waveR;
    %check intensity, should be close to 1 without absorption
    sum(abs(waveR(:)))/(N*N)

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
        evanescence_mask=wavelength^-2>(uu.^2+vv.^2);
        propagator=exp(1i*deltaz*2*pi*sqrt(complex(wavelength^-2-uu.^2-vv.^2))).*evanescence_mask;
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

