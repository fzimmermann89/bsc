classdef run2<handle
    %RUN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        settings;
        objects;
        exitwave
        scatter
        error
        mie
        exitwave_scale
        scatter_scale
        profile_scale
        profile_mie
        profile_scatter
        profile_error
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

