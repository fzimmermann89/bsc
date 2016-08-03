classdef sphere<scatterObjects.base
    %scatterObjects.sphere - A simple sphere
    %(positionX,positionY,positionZ) - Position of the center
    %radius  - Its radius
    %gpu-aware.
    properties (SetAccess = private)
        locked=false;
    end
    properties
        radius=100;
        positionX=0;
        positionY=0;
        positionZ=0;
    end
    properties (Access=private)
        x2y2
        N;
        dx;
        gpu;
    end
    
    methods
        function this=sphere()
        end
        
        
        function fun=prepareSliceMethod(this,N,dx,gpu)
            %locks the object and returns slice method
            if this.locked
                error('Object locked. Please Unlock first.')
            end
            
            this.locked=true;
            this.N=N;
            this.dx=dx;
            this.gpu=gpu;
            maxsize=N*dx;
            
            if maxsize<(abs(this.positionX)+this.radius/2)||maxsize<(abs(this.positionY)+this.radius/2)||maxsize<(abs(this.positionZ)+this.radius/2)
                warning('Object outside simulation area! Increase N or dx');
            end
            frac = @(x) (x-round(x));
            
            if (gpu==true)
                range=dx*((gpuArray.linspace((-N/2+1/2+frac(this.radius/this.dx)),(N/2-1/2+frac(this.radius/this.dx)),N)));
            else
                range=dx*((linspace((-N/2+1/2+frac(this.radius/this.dx)),(N/2-1/2+frac(this.radius/this.dx)),N)));
            end
            
            [xx,yy]=meshgrid(range);
            this.x2y2=single(((xx-this.positionX).^2+(yy-this.positionY).^2)/((this.radius))^2);
            fun=@this.getSlice;
        end
        
        function unlock(this)
            %shall not be called while a SliceMethod function handle is
            %still in use.
            this.locked=false;
        end
        
    end
    methods (Access=private)
        function slice=getSlice(this,z)
            
            z2=(gather(z-this.positionZ)^2);
            if (z2<=this.radius^2)
                z2=single(z2/this.radius^2);
                slice=((this.x2y2+ z2)<1);
            else
                if this.gpu
                    slice=gpuArray.false(this.N,this.N);
                else
                    slice=false(this.N,this.N);
                end
            end
        end
        
        
    end
end