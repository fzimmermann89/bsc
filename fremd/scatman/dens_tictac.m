function [dens, gridX, gridY, gridZ] = dens_tictac(longAxis,shortAxis,alphaZ,alphaY,densResolution);
 
% clear all;
% longAxis = 300;
% shortAxis = 100;
% alphaX = 0.;
% alphaY = 90.;
% alphaZ = 0.;
% 
% densResolution = 100;

    nbox = round(densResolution/2);
    grid = (-nbox:nbox)/nbox;

    dGrid = abs(grid(2)-grid(1));

    [x,y,z] = meshgrid(grid,grid,grid);

    [x,y,z] = rotateZ(x,y,z,alphaZ);
    [x,y,z] = rotateY(x,y,z,alphaY);

 
    z_m1 = 1-shortAxis/longAxis;
    x_m1 = 0.;
    y_m1 = 0.;

    z_m2 = -z_m1;
    x_m2 = 0.;
    y_m2 = 0.;

    scalarProduct2 = x*x_m2+y*y_m2+z*z_m2;
    scalarProduct1 = x*x_m1+y*y_m1+z*z_m1;
    n1 = x_m1^2+y_m1^2+z_m1^2;
    n2 = x_m2^2+y_m2^2+z_m2^2;
    i1 = scalarProduct1/n1;
    i2 = scalarProduct2/n2;
    

    densC1 = (i1*x_m1-x).^2+(i1*y_m1-y).^2+(i1*z_m1-z).^2<=(shortAxis/longAxis)^2;
    densC2 = (scalarProduct1-n1) < 0;
    densC3 = (scalarProduct2-n2) < 0;
    
    densS1 = (scalarProduct1-n1) > 0;
    densS2 = (scalarProduct2-n2) > 0;
    densS3 = (x_m1-x).^2+(y_m1-y).^2+(z_m1-z).^2<=(shortAxis/longAxis)^2;
    densS4 = (x_m2-x).^2+(y_m2-y).^2+(z_m2-z).^2<=(shortAxis/longAxis)^2;
    

    dens = densC1.*densC2.*densC3 + densS1.*densS3 + densS2.*densS4;

    gridX = grid*longAxis/2;
    gridY = grid*longAxis/2;
    gridZ = grid*longAxis/2;  

% 
% figure
% imagesc(gridX,gridY, sum(dens,3));
% colorbar

end