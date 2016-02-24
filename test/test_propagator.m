function test_propagator
    %minimalbeispiel meiner propagatoren
    
    %alle einheiten sind in nm;
    wavelength=100;
    
    dx=10; %auflösung realraum
    
    %abstand zw zwei slices, bzw propagationsentfernung
    deltaz=dx/8; %geht wenn deltaz=100*dx
    
    k=2*pi/wavelength;
    
    N=512;
    gpu=false;
    fprintf('%0.2f soll viel größer pi sein \n',(k*2*dx^2)/(2*deltaz)); %bedingugn aus hare war kleiner..
    
    function propagatorReal=getPropagatorReal%(N,wavelength,deltaz)
        %seperate function to create closure for tmp variables
        if gpu
            range=gpuArray.linspace(-N/2,N/2-1,N)*dx;
        else
            range=linspace(-N/2,N/2-1,N)*dx;
        end
        %TODO x,y skalieren
        [xx,yy]=meshgrid(range,range);
        %     propagatorReal=exp(-1i*k*sqrt(xx.^2+yy.^2+deltaz^2)); %ungenähert
        propagatorReal=exp(-1i*k*(xx.^2+yy.^2)/(2*deltaz)); %genähert
    end
    
    
    function propagator=getPropagator()
        %seperate function to create closure for tmp variables
        if gpu
            
            range=gpuArray.linspace(-N/2,N/2-1,N)*(1/(N*dx));
            
        else
            range=gpuArray.linspace(-N/2,N/2-1,N)*(1/(N*dx));
        end
        [uu,vv]=meshgrid(range,range);
        propagator=exp((uu.^2+vv.^2)*(-1i*pi*wavelength*deltaz)); %minus eingefügt XXXX
    end
    
    
    figure(1)
    imag2show=(getPropagatorReal());
    subplot(1,3,1)
    imagesc(1:N,1:N,abs(imag2show));axis square;
    subplot(1,3,2)
    imagesc(1:N,1:N,real(imag2show));axis square;
    subplot(1,3,3)
    imagesc(1:N,1:N,imag(imag2show));axis square;
    
    figure(2)
    imag2show=ift2(getPropagator());
    % imag2show=ift2(padarray(getPropagator(),[N/2,N/2])); %dann müssen die Plot bereiche angepasst werden
    subplot(1,3,1)
    imagesc(1:N,1:N,(abs(imag2show)));axis square;
    subplot(1,3,2)
    imagesc(1:N,1:N,real(imag2show));axis square;
    subplot(1,3,3)
    imagesc(1:N,1:N,imag(imag2show));axis square;
    
    
    %FFT-Funktionen, machen fftshift(fft(fftshift(data))
    %so geschrieben weil sonst auf gpu schnarch lahm. Kommt aber das
    %richtige raus (für grade N..)
    
    function data=ift2(data)
        N=size(data,1);
        %works for even and uneven
        %     index= mod((0:N-1)-double(rem(ceil(N/2),N)), N)+1;
        
        %works for even only
        index=mod((0:N-1)-N/2,N)+1;
        data = data(index,index);
        data=ifft2(data);
        data=data(index,index);
    end
    
    function data=ft2(data)
        N=size(data,1);
        %works for uneven and even
        % index= mod((0:N-1)-double(rem(floor(N/2),N)), N)+1;
        
        %works only for even
        index=mod((0:N-1)-N/2,N)+1;
        data = data(index,index);
        data=fft2(data);
        data=data(index,index);
    end
    
end