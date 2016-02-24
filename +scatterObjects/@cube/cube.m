classdef cube<scatterObjects.polyhedron
    properties (Constant)
        % coordinates
        % use values given by P. Bourke, see:
        % http://paulbourke.net/geometry/platonic/
        coords = ([ ...
            -1  1 -1;   1  1 -1;   1  1  1;  -1  1  1;...
            -1 -1  1;  -1  1  1;   1  1  1;   1 -1  1;...
            1 -1 -1;   1 -1  1;   1  1  1;   1  1 -1;...
            -1 -1 -1;  -1  1 -1;   1  1 -1;   1 -1 -1;...
            -1 -1 -1;  -1  1 -1;  -1  1  1;  -1 -1  1;...
            -1 -1 -1;  -1 -1  1;   1 -1  1;   1 -1 -1;...
            ]);
        
        NFaces=6;
        NEdgesPerFace=4;
        NEdges=12;
    end
    
    methods
        %uses methods defined in polyhedron
        function this=cube(varargin)
            this=this@scatterObjects.polyhedron(varargin{:});
        end
        
    end
    
end
