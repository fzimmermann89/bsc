function [dens, gridX, gridY, gridZ] = dens_ellipsoid(longAxis,shortAxis,alphaZ,alphaY,densResolution)
    nbox = round(densResolution/2);
    grid = (-nbox:nbox)/nbox;

    dGrid = abs(grid(2)-grid(1));

    [x,y,z] = meshgrid(grid,grid,grid);

    b = shortAxis/longAxis;
    c = 1.;
    a = shortAxis/longAxis;
 
    [x,y,z] = rotateZ(x,y,z,alphaZ);
    [x,y,z] = rotateY(x,y,z,alphaY); 
    
    dens = ((x.^2/a^2+y.^2/b^2+z.^2/c^2)<=1); 
    
    gridX = grid*longAxis/2;
    gridY = grid*longAxis/2;
    gridZ = grid*longAxis/2;  
   
end