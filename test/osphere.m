classdef osphere<handle
    properties
        N=0
        radius=0;
    end
    properties (Access=private)
        X,Y,XY
    end
    methods
        function this=osphere(N,radius)
            this.N=N;
            this.radius=radius;
            [this.X,this.Y] = meshgrid(-this.N/2+1:1:this.N/2,-this.N/2+1:1:this.N/2);
            this.XY=this.X.^2+this.Y.^2;
        end
        function slice=getslice(this,z)
            slice = double((this.X.^2+this.Y.^2+z^2) <= (this.radius)^2);
        end
        function fun=getslicefunc(this)
            fun=@(z)double(osphere.slicefun2(z,this.radius,this.XY));
        end
        function slice=gpu_slice(this,z)
            range=gpuArray.linspace(-this.N/2+1,this.N/2,this.N);
            [xx,yy]=meshgrid(range);
            tmp=(xx.^2+yy.^2+z^2)<this.radius^2;
            slice=gather(tmp);
        end
        
        
        
    end
    methods (Static)
        function fun=getslicefun(N,radius)
            [X1,Y1] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);
            fun=@(z)osphere.slicefun(z,radius,X1,Y1);
        end
        function slice=slicefun(z,radius,X,Y)
            
            slice = double((X.^2+Y.^2+z^2) <= (radius)^2);
            
            
        end
        function slice=slicefun2(z,radius,XY)
            
            slice = double((XY+z^2) <= (radius)^2);
            
            
        end
    end
end