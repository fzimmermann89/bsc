function [dens, gridX, gridY, gridZ] = dens_sphere(rad,densResolution);
    nbox = round(densResolution/2);
    grid = (-nbox:nbox)/nbox;
    dGrid = abs(grid(2)-grid(1));
    [x,y,z] = meshgrid(grid,grid,grid);
 
    dens=x.^2+y.^2+z.^2<1;
 
    gridX = grid*rad;
    gridY = grid*rad;
    gridZ = grid*rad;  
   
end