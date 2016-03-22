classdef sphere<scatterObjects.base
    %scatterObjects.sphere - A simple sphere
    %(x,y,z) - Position of the center
    %radius  - Its radius
    %gpu-aware.
    properties (SetAccess = protected)
        gpu=true;
    end
    properties
        N=0;
        radius=0;
        x=0;
        y=0;
        z=0;
    end
    properties (Access=private)
        x2y2
    end

    methods
        function this=sphere(N,gpu)
            this.N=gather(N);
            this.x=ceil(this.N/2);
            this.y=ceil(this.N/2);
            this.z=ceil(this.N/2);
            this.radius=ceil(this.N/4);
            this.gpu=gpu;
            this.prepare();
        end

        function slice=getSlice(this,z)
            slice=(((this.x2y2+(gather(z)-this.z)^2)<=this.radius^2));
        end

        function set.N(this,N)
            this.N=N;
            this.prepare();
        end
        function set.x(this,x)
            this.x=x;
            this.prepare();
        end
        function set.y(this,y)
            this.y=y;
            this.prepare();
        end
      %for z and radius no setter needed. Precalc depends an x, N and y
      %only


    end
    methods (Access=private)
        function prepare(this)
            if (this.gpu==true)
                range=gpuArray.linspace(1,this.N,this.N);
            else
                range=linspace(1,this.N,this.N);
            end

            [xx,yy]=meshgrid(range);
            this.x2y2=(xx-this.x).^2+(yy-this.y).^2;
        end

    end
end