function [dens, gridX, gridY, gridZ] = dens_wheel(longAxis,shortAxis,alphaZ,alphaY,densResolution);
    
%     densResolution = 100;
%     longAxis = 300;
%     shortAxis = 100;
%     alphaY = 90;
%     alphaZ = 0;

    nbox = round(densResolution/2);
    grid = (-nbox:nbox)/nbox;
    dGrid = abs(grid(2)-grid(1));
    [x,y,z] = meshgrid(grid,grid,grid);

    [x,y,z] = rotateZ(x,y,z,alphaZ);
    [x,y,z] = rotateY(x,y,z,alphaY);
  
    radLong = 1.;
    radShort = shortAxis/longAxis;
    radCyl = radLong-radShort;

    rr = x.^2+y.^2;

    dens1 = (abs(z)<radShort);
    dens2 = (rr<=radCyl^2);
    dens3 = (rr>(radCyl)^2);
    dens4 = (rr<=radLong^2);
    
    phi = atan2(y,x);
    xm = radCyl * cos(phi);
    ym = radCyl * sin(phi);
    
    dens5 = ((x-xm).^2+(y-ym).^2+z.^2)<=radShort^2;
        
    dens = dens1.*dens2 + dens1.*dens5.*dens3.*dens4;


    gridX = grid*longAxis/2;
    gridY = grid*longAxis/2;
    gridZ = grid*longAxis/2;  
% 
%     figure
%     imagesc(gridX,gridY,sum(dens,3))

   
end