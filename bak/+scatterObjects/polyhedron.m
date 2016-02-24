classdef polyhedron<scatterObjects.base
    %scatterObjects.polyhedron - Base class for platonic polyhedrons
    %(x,y,z) - Position of the center
    %radius  - Its radius
    %gpu-aware.
    properties (SetAccess = protected)
        gpu=true;
    end
    properties (Access = protected)
        edgesStart;
        edgesEnd;
    end
    properties
        N=0;
        radius=0;
        x=0;
        y=0;
        z=0;
        rotationX=0;
        rotationY=0;
        rotationZ=0;
    end
    properties (Constant)
        %max number of edges of all derived classes
        maxEdges=100;
        %https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/qeXoDmFC2ug
    end
    methods
        function this=polyhedron(N,gpu)
            this.N=N;
            this.x=ceil(this.N/2);
            this.y=ceil(this.N/2);
            this.z=ceil(this.N/2);
            this.radius=ceil(this.N/4);
            this.gpu=gpu;
            if ~gpu %this warning will otherwise spam the console
                warning('off','MATLAB:inpolygon:ModelingWorldLower')
            end
        end%polyhedron
        
        function slice=getSlice(this,z)
            %get edges in slice
            nVectors=0;
            
            %ugly hack because of https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/qeXoDmFC2ug
            vertx=zeros(this.maxEdges,1);
            verty=zeros(this.maxEdges,1);
            
            for n=1:this.NEdges
                zstart=this.edgesStart(n,3);
                zend=this.edgesEnd(n,3);
                
                if  (zstart<z)~= (zend<z)
                    %z within edge. calculate x and y in the z-plane
                    nVectors=nVectors+1;
                    zdiff=zend-zstart;
                    xstart=this.edgesStart(n,1);
                    xend=this.edgesEnd(n,1);
                    ystart=this.edgesStart(n,2);
                    yend=this.edgesEnd(n,2);
                    vertx(nVectors)=xstart+(xend-xstart)/zdiff*(z-zstart);
                    verty(nVectors)=ystart+(yend-ystart)/zdiff*(z-zstart);
                    
                end
            end
            
            if (nVectors==0) %empty Slice
                if (this.gpu)
                    slice=gpuArray.false(this.N);
                else
                    slice=false(this.N);
                end
            else
                %sort vectors in a circle - could this be avoided by
                %a better getEdges and/or sorting of the coords?
                tmpx=vertx-mean(vertx(1:nVectors));
                tmpy=verty-mean(verty(1:nVectors));
                angle=atan2(tmpx,tmpy);
                [~,I]=sort(angle(1:nVectors),'descend');
                vertx=[vertx(I);vertx(nVectors+1:end)];
                verty=[verty(I);verty(nVectors+1:end)];
                
                %get slice
                if (this.gpu)
                    slice=scatterObjects.poly2mat(this.N,vertx,verty,nVectors);
                else
                    [xx,yy] = meshgrid (1:this.N, 1:this.N);
                    slice=inpolygon(xx,yy,vertx(1:nVectors),verty(1:nVectors));
                end
                
            end
        end%getSlice
        
        %setters recalculate edges
        function set.x(this,x)
            this.x=x;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        function set.y(this,y)
            this.y=y;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        function set.z(this,z)
            this.z=z;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        function set.radius(this,radius)
            this.radius=radius;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        function set.rotationX(this,rotationX)
            this.rotationX=rotationX*pi/180;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        function set.rotationY(this,rotationY)
            this.rotationY=rotationY*pi/180;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        function set.rotationZ(this,rotationZ)
            this.rotationZ=rotationZ*pi/180;
            [this.edgesStart,this.edgesEnd]=this.getEdges();
        end
        
    end%methods
    
    
    
    methods (Access=protected)
        function [startPoint,endPoint]=getEdges(this)
            % gets start and end of each unique edge
            rotation=scatterObjects.getRotationMatrix(this.rotationX,this.rotationY,this.rotationZ);
            scaledCoords=(rotation*this.coords')';
            scaledCoords=scaledCoords*this.radius+repmat([this.x,this.y,this.z],length(this.coords),1);
            % faces using unique vertices
            [verts, ~, N] = unique(scaledCoords, 'rows', 'first');
            ind1 = reshape((1:this.NEdgesPerFace*this.NFaces), [this.NEdgesPerFace this.NFaces])';
            faces = N(ind1);
            
            % unique edges from faces
            ind2 = [reshape(faces(:, 1:this.NEdgesPerFace), [this.NEdgesPerFace*this.NFaces 1]) reshape(faces(:, [2:this.NEdgesPerFace 1]), [this.NEdgesPerFace*this.NFaces 1])];
            ind2 = unique(sort(ind2, 2), 'rows');
            startPoint=verts(ind2(:,1),:,:);
            endPoint=verts(ind2(:,2),:,:);
            
        end%getEdges
    end% protected methods
    
end%class


