classdef (Abstract) base<handle
    %BASE Abstract base class for scatter Objects
    
    properties
        delta=0;
        beta=0;
    end
    
    methods
        function dup=copy(this)
           dup=feval(class(this)); 
        end
    end
    methods(Abstract)
        prepareSliceMethod(this)
    end
end

