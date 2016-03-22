classdef (Abstract) base<handle
    %BASE Abstract base class for scatter Objects

    properties
        delta=0;
        beta=0;
    end
    properties(Abstract)
        N;

    end
    properties(Abstract,SetAccess = protected)
        gpu;
    end


    methods
        function clonedObj=clone(this)
            clonedObj=feval(class(this),this.N,this.gpu);
            props = properties(this);
            for n = 1:length(props)
                clonedObj.(props{n}) = this.(props{n});
            end
        end
    end

end

