classdef stl<objects.obj
   
    %Scatter object from STL file
    %stl(x,y,z,size,filename)
    properties
        filename
     %   mesh
    end
    
    methods
        function this=stl(varargin)
                     this@objects.obj(varargin{:});
             if (nargin==5)
            this.filename=varargin{5};
             end
            
        end
        function data=data(this)
          
           data= objects.VOXELISE(this.size,this.size,this.size,this.filename,'x');
                 

        end
        function copy=copy(this)
        copy=objects.stl(this.x,this.y,this.z,this.size,this.filename);
        end
              function prop=getProperties(this)
            prop=getProperties@objects.obj(this);
            prop{5}={'filename',filename}
        end    
%         function set.filename(this,filename)
%             this.filename=filename;
%             this.mesh= objects.READ_stl(filename);
%         end
%         function filename=get.filename(this)
%             filename=this.filename;
%         end
    end
    
end

