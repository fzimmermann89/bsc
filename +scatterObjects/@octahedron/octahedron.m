classdef octahedron<scatterObjects.polyhedron
    properties (Constant)
        % coordinates
        % use values given by P. Bourke, see:
        % http://paulbourke.net/geometry/platonic/
        coords = ([ ...
            -1/(sqrt(2))  0  1/(sqrt(2)); -1/(sqrt(2))  0 -1/(sqrt(2));  0  1  0; ...
            -1/(sqrt(2))  0 -1/(sqrt(2));  1/(sqrt(2))  0 -1/(sqrt(2));  0  1  0; ...
            1/(sqrt(2))  0 -1/(sqrt(2));  1/(sqrt(2))  0  1/(sqrt(2));  0  1  0; ...
            1/(sqrt(2))  0  1/(sqrt(2)); -1/(sqrt(2))  0  1/(sqrt(2));  0  1  0; ...
            1/(sqrt(2))  0 -1/(sqrt(2)); -1/(sqrt(2))  0 -1/(sqrt(2));  0 -1  0; ...
            -1/(sqrt(2))  0 -1/(sqrt(2)); -1/(sqrt(2))  0  1/(sqrt(2));  0 -1  0; ...
            1/(sqrt(2))  0  1/(sqrt(2));  1/(sqrt(2))  0 -1/(sqrt(2));  0 -1  0; ...
            -1/(sqrt(2))  0  1/(sqrt(2));  1/(sqrt(2))  0  1/(sqrt(2));  0 -1  0; ...
            ]);
        
        NFaces=8;
        NEdgesPerFace=3;
        NEdges=12;
    end
    
    methods
        %uses methods defined in polyhedron
        function this=octahedron(varargin)
            this=this@scatterObjects.polyhedron(varargin{:});
        end
        
    end
    
end

