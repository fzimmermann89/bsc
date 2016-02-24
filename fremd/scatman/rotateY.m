function [xOut,yOut,zOut] = rotateY(x,y,z,alpha)

alpha = alpha*pi/180;


xOut = cos(alpha) * x - sin(alpha) * z;
yOut = y;
zOut = sin(alpha) * x + cos(alpha) * z;

end

