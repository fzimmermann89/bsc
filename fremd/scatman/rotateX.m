function [xOut,yOut,zOut] = rotateX(x,y,z,alpha)

alpha = alpha*pi/180;

xOut = x;
yOut = cos(alpha) * y - sin(alpha) * z;
zOut = sin(alpha) * y + cos(alpha) * z;

end

