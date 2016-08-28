function [offset,val]=findTranslation2d(a,b,subpixel)
    % finds translational offset between image a and b by crosscorrelation. 
    % if subpixel is set to true subpixel values will be calculated. 
    % supports gpuarray inputs. Returns offsets and correlation value.
    
    if size(a)~=size(b);error('a and be must have same size');end;
    Nx=size(a,1);
    Ny=size(a,2);
    if isa('a','gpuArray')||isa('b','gpuArray')
        a=gpuArray(single(a));
        b=gpuArray(single(b));
        rangex=(-2i*pi*gpuArray.linspace(-1/2+1/Nx,1/2,Nx));
        rangey=(-2i*pi*gpuArray.linspace(-1/2+1/Ny,1/2,Ny));
    else
        a=single(a);
        b=single(b);
      rangex=(-2i*pi*linspace(-1/2+1/Nx,1/2,Nx));
        rangey=(-2i*pi*linspace(-1/2+1/Ny,1/2,Ny));
    end
    
    tmp=ift2(ft2(a).*conj(ft2(b)));
    [val,ind]=max(abs(tmp(:)));
    [subx,suby]=ind2sub(size(a),gather(ind));
    offset=  [subx,suby]-[Nx/2+1,Ny/2+1];
    if nargin>2&&subpixel
    [yF,xF] = meshgrid(rangex,rangey);
    [offset,val]=fminsearch(@(x)-move(x(1),x(2)),offset,optimset('TolX',1e-3));
    offset=round(offset,2);
    end
    val=abs(val);
    
    function out=move(x,y)
        temp=abs(ift2(ft2(a).*conj(ft2(b).*exp(xF*x+yF*y))));
        out=gather(temp(end/2+1,end/2+1));
    end
    
end