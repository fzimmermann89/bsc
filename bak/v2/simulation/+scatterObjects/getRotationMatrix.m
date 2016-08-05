function matrix = getRotationMatrix( anglex,angley,anglez )
%getRotationMatrix - Constructs rotation matrix around origin
% compute coefs

rotationX = [...
    1               0                   0                       ;...
    0               cos(anglex)         -sin(anglex)            ;...
    0               sin(anglex)         cos(anglex)             ];

rotationY = [...
    cos(angley)     0                   sin(angley)             ;...
    0               1                   0                       ;...
    -sin(angley)    0                   cos(angley)             ];

rotationZ = [...
    cos(anglez)     -sin(anglez)        0                       ;...
    sin(anglez)     cos(anglez)         0                       ;...
    0               0                   1                       ];

matrix = rotationZ * rotationY * rotationX;

end

