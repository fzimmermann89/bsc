classdef obj<handle
    %obj(x,y,z,size)
    %   Detailed explanation goes here
    
    properties
        x=0
        y=0
        z=0
        size=0
        Properties;
    end
    
    methods
        function ret=data(this,nx,ny,nz)
            ret=zeros(nx,ny,nz);
        end
        function obj=obj(varargin)
            if (nargin<4), return,end;
            obj.x=varargin{1};obj.y=varargin{2};obj.z=varargin{3};
            obj.size=varargin{4};
            
        end
        function copy(this)
            error('blub');
        end
        function prop=getProperties(this)
            prop{1}={'x',this.x};
            prop{2}={'y',this.x};
            prop{3}={'z',this.x};
            prop{4}={'size',this.size};
        end
    end
    
end

