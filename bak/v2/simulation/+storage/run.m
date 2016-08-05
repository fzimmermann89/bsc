classdef run<handle
    %RUN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        settings;
        objects;
        exitwaves
        exitwaves_scale
        scatters
        scatters_scale
        profiles_x
        profiles_y
        profiles_min
        profiles_max
        profiles_stdev
        errors_rel
        errors_abs
        errors_rms
        mie
        rayleigh
    end
    
    methods
        function  obj= run(N,dx,dz,wavelength,objects)
            settings.N=N;
            settings.dx=dx;
            settings.dz=dz;
            settings.wavelength=wavelength;
            obj.settings=settings;
            obj.objects=objects;
        end
         
    end
    
end

