function test
function poly_rectangle(p1, p2, p3, p4)
% The points must be in the correct sequence.
% The coordinates must consider x, y and z-axes.
x = [p1(1) p2(1) p3(1) p4(1)];
y = [p1(2) p2(2) p3(2) p4(2)];
z = [p1(3) p2(3) p3(3) p4(3)];
fill3(x, y, z, rand(size(p1)));

hold on
end

p1 = [0 0 0];
p2 = [2 0 0];
p3 = [2 4 0];
p4 = [0 4 0];
p5 = [0 0 3];
p6 = [2 0 3];
p7 = [2 4 3];
p8 = [0 4 3];

poly_rectangle(p3, p4, p8, p7)
poly_rectangle(p1, p4, p8, p5)
mArrow3(p2,p3);
view(-155, 43)
end