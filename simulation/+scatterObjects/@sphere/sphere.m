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
    properties (Access=public)
        x2y2
        N;
        dx;
        range
    end

    methods
        function this=sphere()
        end


        function fun=prepareSliceMethod(this,N,dx,gpu)
             %locks the object and returns slice method
            if this.locked
                error('Object locked. Please Unlock first.')
            end

            this.N=N;
            this.dx=dx;
            maxsize=N*dx;

            if maxsize<(abs(this.positionX)+this.radius/2)||maxsize<(abs(this.positionY)+this.radius/2)||maxsize<(abs(this.positionZ)+this.radius/2)
                warning('Object outside simulation area! Increase N or dx');
            end

            if (gpu==true)
                %if range is a gpuArray, all following calculations will
                %inherit beeing on the gpu

frac = @(x) (x-round(x));
                %the -1/2dx is a shift to have real fft
                range=dx*((gpuArray.linspace((-N/2+1/2+frac(this.radius/this.dx)),(N/2-1/2+frac(this.radius/this.dx)),N)));
%                 range=dx*(gpuArray.linspace((-N/2),(N/2),N));

            else
                range=linspace((-(N-1)/2)*dx,((N-1)/2)*dx,N);
            end

            [xx,yy]=meshgrid(range);   %
            %dx is added to the radius to force rounding to a bigger sphere
            this.x2y2=((xx-this.positionX).^2+(yy-this.positionY).^2)/((this.radius))^2; %+1/4*this.dx
this.range=range;
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

            z2=(gather(z-this.positionZ)^2/this.radius^2);
            slice=((this.x2y2+ z2)<1);
        end


    end
end