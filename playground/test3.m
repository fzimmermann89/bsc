xv = [1 4 4 1 1 NaN 2 2 3 3 2];
yv = [1 1 4 4 1 NaN 2 3 3 2 2];

xq = rand(500,1)*5;
yq = rand(500,1)*5;

in =  scatterObjects.poly2mat(10,xv,yq,5);