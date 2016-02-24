function out = sameSide(v1, v2, v3, v4, p)
    normal = cross(v2 - v1, v3 - v1);
    dotV4 = dot(normal, v4 - v1);
    dotP = dot(normal, p - v1);
    out = sign(dotV4) == sign(dotP);