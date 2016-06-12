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
% rotmat=scatterObjects.getRotationMatrix(45*pi/180,45*pi/180,0*pi/180);
%
% objects{1}.radius=maxXY/(4);
m=scatterObjects.toMatrix(objects,N,dx,gpu);
%
% % figure(11)
% % m=scatterObjects.toMatrix(objects,N,dx,gpu);
% % [x,y,z]=ind2sub(size(m),find(m));
% %
% % scatter3(x,y,z);
% % axis square;
% m2=m;
% % m2(:,:,end/2:end)=0;
% [px,py,pz] = ind2sub(size(m2),find(m2));
% points = [px py pz];
% points2=(rotmat*(points-repmat(size(m2)/2,[size(px),1]))')'+repmat(size(m2)/2,[size(px),1]);
%
% p3=round(points2);
% idx=sub2ind(size(m),p3(:,1),p3(:,2),p3(:,3));
% m2(:)=0;
% m2(idx)=1;
% m2=imclose(m2,strel('disk',5));
% m=m2;
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
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
%
% for nobj=length(objects):-1:1
%     slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
% end
%
%
% f=figure(12);
% im=imagesc(zeros(N,N));
% axis square;
% caxis([0,1]);
% for z=1:size(m,3)%z=-Lz/2:deltaz:Lz/2
%
%     curslice=zeros(N,N);
%
%     for nobj=1:length(objects)
%         o=objects{nobj};
%         osliceIndex=m(:,:,z);
% %         osliceIndex=slicefun{nobj}(z); %where is the object?
%       curslice=curslice+osliceIndex;
%     end
%     im.CData=gather(curslice);
%     drawnow;
%     title(sprintf('z=%f',z));
%
%     if sum(curslice(:))>0
%       waitforbuttonpress
%     end
% end
%
%
% for nobj=length(objects):-1:1
%     objects{nobj}.unlock();
% end






%
% for nobj=length(objects):-1:1
%     slicefun{nobj}=objects{nobj}.prepareSliceMethod(N,dx,gpu);
% end
%
%
% f=figure(13);
% im=imagesc(zeros(N,N));
% axis square;
% caxis([0,1]);
% lz=0;
% lz2=0;
% n=0;
% for z=-Lz/2:deltaz:Lz/2
%  n=n+1;
%
%     curslice=zeros(N,N);
%
%     for nobj=1:length(objects)
%       o=objects{nobj};
%       osliceIndex=slicefun{nobj}(z); %where is the object?
%       curslice=curslice+osliceIndex;
%     end
%
% %     im.CData=gather(curslice);
% %     drawnow;
%     title(sprintf('z=%f',z));
%
%     if sum(curslice(:))>0
%        lz=z;
% %       waitforbuttonpress
%     elseif (lz==0)
%         lz2=z;
%     end
%
% end
% lz-lz2
%
% for nobj=length(objects):-1:1
%     objects{nobj}.unlock();
% end