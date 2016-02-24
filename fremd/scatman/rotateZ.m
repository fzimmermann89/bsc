function [xOut,yOut,zOut] = rotateZ(x,y,z,alpha)

alpha = alpha*pi/180;

xOut = cos(alpha) * x - sin(alpha) * y;
yOut = sin(alpha) * x + cos(alpha) * y;
zOut = z;

end

