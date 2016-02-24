classdef sphere<objects.obj
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    methods
        
        function data=data(this,nx,ny,nz)
            [X,Y,Z] = meshgrid(-this.x+1 :1: this.size/2+this.x, -this.y+1 :1: this.size/2+this.y,-this.z+1 :1: this.size/2+this.z);
            data = ((X.^2+Y.^2+Z.^2) <= (this.size)^2); 
            data(nx,ny,nz)=0;
        end
        
        function this=sphere(varargin)
            this@objects.obj(varargin{:});
        end
        function copy=copy(this)
            copy=objects.sphere(this.x,this.y,this.z,this.size);
        end
        function prop=getProperties(this)
            prop=getProperties@objects.obj(this);
        end
    end
end

