% Testbench for the polyhedrons used as scatterobject

N=128;
dx=10;
deltaz=dx/64;
Lz=dx*N/2;
maxXY=N/2*dx;
gpu=true;

%create one object
objects=cell(1);
objects{1}=scatterObjects.dodecahedron;
objects{1}.rotationX=0*pi/180;
objects{1}.rotationY=0*pi/180;
objects{1}.rotationZ=0*pi/180;
rad=maxXY/2
objects{1}.radius=rad;

%% 3d plot
m=scatterObjects.toMatrix(objects,N,dx,gpu);

figure(11)
[px,py,pz] = ind2sub(size(m),find(m));
points = [px py pz];
DT = DelaunayTri(points);  %# Create the tetrahedral mesh
hullFacets = convexHull(DT);       %# Find the facets of the convex hull
trisurf(hullFacets,DT.X(:,1),DT.X(:,2),DT.X(:,3),'FaceColor','c','LineStyle','none')
light('Position',[-1 0 0],'Style','local')
% mArrow3([N/2,N/2,N/2-400],[N/2,N/2,N/2-200]);
axis square;
view(90,90);
title(' hull');
lighting flat


%% Stepwise plot
for nobj=length(objects):-1:1
    slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
end


f=figure(12);
im=imagesc(zeros(N,N));
axis square;
caxis([0,1]);
for z=-Lz/2:deltaz:Lz/2
    
    curslice=zeros(N,N);
    
    for nobj=1:length(objects)
        o=objects{nobj};
        osliceIndex=slicefun{nobj}(z); %where is the object?
        curslice=curslice+osliceIndex;
    end
    im.CData=gather(curslice);
    drawnow;
    title(sprintf('z=%f',z));
    
    if sum(curslice(:))>0
        waitforbuttonpress
    end
end


for nobj=length(objects):-1:1
    objects{nobj}.unlock();
end

