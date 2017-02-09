classdef scene<handle
    %Scene

    properties
        resolution=struct('x',256,'y',256,'z',256);
        angle=struct('a',0,'b',0,'c',0);
        objects={}
    end

    properties(Dependent)
        data
    end

    methods
        function index=AddObject(this,obj)
            this.objects{end+1}=obj;
            index=length(this.objects);
        end
        function remaining=RemoveObject(this,index)
            this.objects{index}=[];
            this.objects(cellfun(@(o) isempty(o),this.objects))=[];
            remaining=length(this.objects)
        end
        function ResetObjects(this)
            this.objects={};
        end
    end
end


