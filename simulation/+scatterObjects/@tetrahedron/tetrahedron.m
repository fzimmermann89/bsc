classdef tetrahedron<scatterObjects.polyhedron
    properties (Constant)
        % coordinates
        % use values given by P. Bourke, see:
        % http://paulbourke.net/geometry/platonic/
        coords = ([ ...
            1  1  1;   -1  1 -1;    1 -1 -1; ...
            -1  1 -1;   -1 -1  1;    1 -1 -1; ...
            1  1  1;    1 -1 -1;   -1 -1  1; ...
            1  1  1;   -1 -1  1;   -1  1 -1; ...
            ]);

        NFaces=4;
        NEdgesPerFace=3;
        NEdges=6;

    end

    methods
        %uses methods defined in polyhedron
        function this=tetrahedron(N)
            this=this@scatterObjects.polyhedron(N);
        end

    end

end

