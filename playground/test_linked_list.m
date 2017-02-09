clear classes
clear all
clc
import linkedlist.list
tic
% n1=linkedlist.node;
% n2=linkedlist.node;
% l=linkedlist.list;
% l.addElement(n1);
% l.addElement(n2);
%
%

s1=objects.stl(10,10,10,20,'sample.stl')
s2=objects.sphere(200,100,200,50);
 objs=list(s1,s2);
data=false(500,500,500);
tmp=objs.first;
while(~isempty(tmp))
    tmp2=tmp.data;
    tmp2(500,500,500)=0;
    data=data|tmp2;
tmp=tmp.next;
end

 [x,y,z]=ind2sub(size(data),find(data));
        figure
        scatter3(x,z,y,'filled') ;view(35,30);axis equal;
