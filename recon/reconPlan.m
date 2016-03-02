classdef reconPlan<handle
    %Plan for phase retrieval
    
    properties
        steps=struct('method',{},'iterations',{},'parameters',{});
        iterations=0;
    end
    
    methods
        function addStep(this,method,iterations,parameters)
            step.method=method;
           
            if exist('iterations','var')
                step.iterations=iterations;
            else
                step.iterations=1;
            end
            
            if exist('parameters','var')
                step.parameters=parameters;
            else
                step.parameters=[];
            end
            
            this.steps(end+1)=step;
            this.iterations=this.iterations+step.iterations;
        end
        function step=getStep(this,n)
            if n<=length(this.steps);
                step=this.steps(n);
            else
                step=false;
            end
        end
        function out=length(this)
            out=length(this.steps);
        end
    end
end

