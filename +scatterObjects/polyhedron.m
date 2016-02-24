classdef polyhedron<scatterObjects.base
    %scatterObjects.polyhedron - Base class for platonic polyhedrons
    %(x,y,z) - Position of the center
    %radius  - Its radius
    %gpu-aware.
    properties (Access = protected)
        edgesStart;
        edgesEnd;
        gpu;
        N;
        dx;
        locked=false;
        kernel;
        empty;
    end
    properties
        positionX=0;
        positionY=0;
        positionZ=0;
        radius=100;
        rotationX=0;
        rotationY=0;
        rotationZ=0;
    end
    properties (Constant)
        %max number of edges of all derived classes
        %         maxEdges=100;
        %https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/qeXoDmFC2ug
    end
    methods
        function this=polyhedron()
        end%polyhedron
        
        function fun=prepareSliceMethod(this,N,dx,gpu)
            %locks the object and returns slice method
            if this.locked
                error('Object locked. Please Unlock first.')
            end
            if ~gpu %this warning will otherwise spam the console
                warning('off','MATLAB:inpolygon:ModelingWorldLower')
            end
            this.N=N;
            this.dx=dx;
            maxsize=N*dx;
            if maxsize<(abs(this.positionX)+this.radius/2)||maxsize<(abs(this.positionY)+this.radius/2)||maxsize<(abs(this.positionZ)+this.radius/2)
                warning('Object outside simulation area! Increase N or dx');
            end
            if gpu
                this.gpu=gpu;
                this.kernel=parallel.gpu.CUDAKernel('+scatterObjects/inpoly.ptx','+scatterObjects/inpoly.cu');
                this.kernel.ThreadBlockSize =[8, 8,1];
                this.kernel.GridSize=[N/8,N/8,1];
                this.empty=gpuArray.false(N,N);
            else
                this.empty=false(N,N);
            end
            [this.edgesStart,this.edgesEnd]=this.getEdges();
            fun=@this.getSlice;
            this.locked=true;
            
            
        end
        function unlock(this)
            this.edgesStart=[];
            this.edgesEnd=[];
            this.empty=[];
            this.locked=false;
        end
        
    end%methods
    
    
    
    methods (Access=protected)
        function [startPoint,endPoint]=getEdges(this)
            % gets start and end of each unique edge
            % caution: the addition of 1 to postion Nx,Ny and of 1/2 to the
            % x and y radius is necessary to have real fft.
            rotation=scatterObjects.getRotationMatrix(this.rotationX,this.rotationY,this.rotationZ);
            positionN=[this.positionX,this.positionY,this.positionZ]/this.dx+[(this.N)/2+1,(this.N)/2+1,0];
            radiusN=diag((this.radius/this.dx)+[1/2;1/2;0]);
            scaledCoords=(rotation*this.coords')';
            scaledCoords=scaledCoords*radiusN+repmat(positionN,length(this.coords),1);
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
        
        function slice=getSlice(this,z)
            if ~(this.locked)
                error('Object not ready')
            end
            %get edges in slice
            nVectors=0;
            
            %ugly hack because of https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/qeXoDmFC2ug
            %             vertx=zeros(this.maxEdges,1);
            %             verty=zeros(this.maxEdges,1);
            %no longer necessary
            
            vertx=zeros(length(this.edgesStart),1);
            verty=zeros(length(this.edgesStart),1);
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
                slice=this.empty;
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
                    %slice=scatterObjects.poly2mat(this.N,single(vertx),single(verty),nVectors);
                    slice=this.empty;
                    slice=feval(this.kernel,this.N,single(vertx),single(verty),nVectors,slice);
                else
                    [xx,yy] = meshgrid (1:this.N, 1:this.N);
                    slice=inpolygon(xx,yy,vertx(1:nVectors),verty(1:nVectors));
                end
                
            end
        end%getSlice
        
    end% protected methods
    
end%class


