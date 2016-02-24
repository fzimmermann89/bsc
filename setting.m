classdef setting<handle
    %SETTING(value,minValue,maxValue,unit,<optional>description)
    %   A single Setting used in the Simulation
    %   Provides means to bundle a value with its limits and unit
    
    properties
        value=0;
        minValue=-realmax;
        maxValue=realmax;
        description='';
        unit='';
    end
    
    methods
        function set.value(this,value)
            this.value=max(this.minValue,min(value,this.maxValue));
        end
        function set.minValue(this,minValue)
            this.minValue=minValue;
            %call setter with updated minValue
            this.value=this.value;
        end
        
        function set.maxValue(this,maxValue)
            this.maxValue=maxValue;
            %call setter with updated maxValue
            this.value=this.value;
        end
        function this=setting(value,minValue,maxValue,unit,description)
            this.minValue=minValue;
            this.maxValue=maxValue;
            this.value=value;
            if (nargin==5)
                this.description=description;
            end
        end
    end
end

