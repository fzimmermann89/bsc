classdef matrix<scatterObjects.base
    %Makes a (boolean) 3D Matrix compatible with the scatterObjects interface
    %Set objmatrix to a boolean Matrix after creation describing the presence
    %of the object. No scaling, only padding to N will be used. The object will
    %be centered.


    properties (Access = protected)
        gpu;
        N;
        dx;
        objmatrix;
        padtop;
        padleft;
        locked
    end
    methods
        function this=matrix(objmatrix)
            this.objmatrix=objmatrix;
        end
        function fun=prepareSliceMethod(this,N,dx,gpu)
            %locks the object and returns slice method
            if this.locked
                error('Object locked. Please Unlock first.')
            end
            if N<max(size(this.objmatrix))
                error('Matrix bigger than requested N. Scaling not implemented');
            end
            this.N=N;
            this.dx=dx;
            this.gpu=gpu;
            fun=@this.getSlice;
            this.locked=true;
            this.padleft=ceil((N-size(this.objmatrix,1))/2);
            this.padtop=ceil((N-size(this.objmatrix,2))/2);

        end
        function unlock(this)
            this.locked=false;
        end

    end
    methods (Access=protected)
        function slice=getSlice(this,z)
            %returns a single slice of the object
            if ~(this.locked)
                error('Object not ready')
            end
            indexz=round(z/this.dx+size(this.objmatrix,3)/2);
            slice=false(this.N,this.N);
            if indexz<size(this.objmatrix,3)&&indexz>1
                slice(1+this.padleft:this.padleft+size(this.objmatrix,1),1+this.padtop:this.padtop+size(this.objmatrix,2))=this.objmatrix(:,:,indexz);
            end
        end
    end
end
