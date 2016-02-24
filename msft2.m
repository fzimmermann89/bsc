
function out=msft2(wavelength,objects,N,dx,gpu,debug)
%calculates multislice ft of object, based on ingo barke's code
%output is matrix of complex amplitudes over different exit k_x,y (not scatter vectors)
%constant phase shifts are ignored
% wavelength (in nm),objects (cell array),N,dx,distanceDetektor,gpu (bool use gpu),debug (bool show progress)

%scattering
% kout=kin+dk
% kin_z=k
% kin_x,y=0
% I(dk_x,y)=F(slice) (born approx)
% kout_x,y=dk_x,y
% kout_x^2+kout_y^2+kout_z^2=k^2
% <=>kout_z^2=k^2-(kout_x^2+kout_y^2)=k^2-(dk_x^2+dk_y^2) 
% (wave impuls conservation)

%phase:
% distz: distance from leftmost z
% phase_before=z*kin_z
% scattering
% phase after=(maxz-z)*kout_z
% phase=phase_before+phase_after=(maxz-z)*kout_z+distz*kin_z=maxz*out+(z*kin_z-z*kout_z)
% const phase of maxz*kout (and others) will be neglected.
% -> phaseshift=z*(k-kout_z)=z*kdiff with
% kdiff=k-sqrt(k-(dk_x^2+dk_y^2))
deltaz=dx/2;
k=2*pi/wavelength;
Lz=dx*N/2; %cubic box

if gpu
    one=gpuArray.ones(N,N);
    zero=gpuArray.zeros(N,N);
else
    one=ones(N,N);
    zero=zeros(N,N);
end

%initialize output
out=zero;

display('start');

%prepare Objects and retrieve slice functions
for nobj=length(objects):-1:1
    slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
end

%prepare kin_z-kout_z matrix
if gpu
    dk_range=gpuArray.linspace(-N/2,N/2-1,N)*(2*pi/(dx*N));
else
    dk_range=linspace(-N/2,N/2-1,N)*(2*pi/(dx*N));
end
[dk_x,dk_y]=meshgrid(dk_range);
kdiff=k-real(sqrt(complex(k^2-(dk_x.^2+dk_y.^2))));

%prepare mask for evanescence ("no remaining forwards k")
mask=k^2>(dk_x.^2+dk_y.^2);

for z=-Lz/2:deltaz:Lz/2
    
    %get slices
    slice=zero;
    for nobj=1:length(objects)
        o=objects{nobj};
        bd=(o.delta+1i*o.beta);
        osliceIndex=slicefun{nobj}(z); %where is the object?
        slice=slice+osliceIndex*bd;
    end
    
    
    if any(slice(:))
        %calculate contribution of slice
        contrib=ft2(slice)*(dx^2);
        %add with correct phase shift
        phaseshift=exp(1i*z*kdiff);
        out=out+contrib.*phaseshift.*mask;
    end
end


%unlock objects
for nobj=length(objects):-1:1
    objects{nobj}.unlock();
end


end

