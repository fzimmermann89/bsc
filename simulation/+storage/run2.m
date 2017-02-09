classdef run2<handle
% Stores the data of one simulation run
    
    properties
        settings;
        objects;
        exitwave
        scatter
        error_abs
        error_rel
        mie
        exitwave_scale
        scatter_scale
        profile_scale
        profile_mie
        profile_scatter
        profile_error_abs
        profile_error_rel
    end
    
    methods
        function  obj= run2(N,dx,dz,wavelength,objects)
            settings.N=N;
            settings.dx=dx;
            settings.dz=dz;
            settings.wavelength=wavelength;
            obj.settings=settings;
            obj.objects=objects;
        end
         
    end
    
end

