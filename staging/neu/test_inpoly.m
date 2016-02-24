N=1024;
tic
for n=1:N
g=(0);
z1=repmat(g,N,N);
end
toc


tic
a=gpui
for n=1:N
z1=a.zeros(N,N);
end
toc
% function out=test_inpoly
% N=(1000);
% Np=10;
% Nz=1000;
% range=(gpuArray.linspace(1,N,N));
% [x,y] = meshgrid (range, range);
% xv=((ceil(rand(Np,1)*N)));
% yv=((ceil(rand(Np,1)*N)));
% 
% % xv=([1,N,1]);
% %     yv=([1,1,N]);
% % in=gpuArray(zeros(N,N));
% % tic
% % for n=1:Nz
% %     in = in+inpolygon (x, y, xv, yv);
% % end
% % toc
% % 
% % in2=gpuArray(zeros(N,N));
% % tic
% % for n=1:Nz
% %     in2 = in2+inpolygon_for_gpu (x, y, xv, yv);
% % end
% % toc
% 
% 
%     function out=poly2mat(N,vertx,verty)
%         x=gpuArray.linspace(1,N,N);
%         y=x.';
%         Np=length(vertx);
%         function bool_out = inpoly(testx,testy)
%             %Simple InPolygon Implementation. 
%             % Uses parent's Np, vertx & verty
%             %Based on C Code: Copyright (c) 1970-2003, Wm. Randolph Franklin, BSD-License
%             %http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
%             
%             bool_out=logical(false);
%             ind1=1;
%             ind2=Np;
%       
%             while ind1<=Np
%                 if ((verty(ind1)>testy) ~= (verty(ind2)>testy)) && ...
%                         (testx <...
%                         ( (vertx(ind2)-vertx(ind1)) * (testy-verty(ind1)) / (verty(ind2)-verty(ind1)) + vertx(ind1)  )...
%                         )
%                     
%                     bool_out=~bool_out;
%                 end
%                 ind2=ind1;
%                 ind1=ind1+1;
%             end
%         end
%         
%             out = arrayfun(@inpoly, x, y);
%     end
% 
% in3=(zeros(N,N));
% tic
% for n=1:Nz
%     in3 = in3+poly2mat (N, xv, yv);
% end
% toc
% a=gather(in3);
% toc
% c=1+1;
% % tic
% % % in=arrayfun(@inpoly,x,y);
% % %     function o=inpoly(x1,y1)
% % %         o=inpolygon(x1,y1,xv,yv);
% % %     end
% % % toc
% % tic
% % in2=poly2mask(xv,xv,N,N);
% % toc
% %
% % a=(in-in2);
% 
% 
% 
%     function [bool_out] = inpolygon_for_gpu(testx,testy,vertx,verty)
%         %inpolygon function that works with gpuArrays. This implementation is faster
%         %than the traditional inpolygon function when ran on a GPU, whenever the number
%         %of test points is much greater than the number of vertices in the polygon.
%         %For a  test point, this code will run much slower than MATLAB's original inpolygon function.
%         
%         %This code applies a ray casting algorithm based on C code by W.
%         %Randolf Franklin, which can be found at
%         %http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
%         
%         %I plan to implement this using a CUDA mex file for greater speed
%         
%         %Any advice is welcome on how to speed up the algorithm, thanks!
%         
%         
%         ind1=1;
%         nvert=length(vertx);
%         ind2=nvert;
%         bool_out=zeros(size(testx));
%         while ind1<=nvert
%             
%             bools_to_change=find(    (   (verty(ind1)>testy) ~= (verty(ind2)>testy)) & ...
%                 (testx < (vertx(ind2)-vertx(ind1)) * ...
%                 (testy-verty(ind1)) / (verty(ind2)-verty(ind1)) + vertx(ind1) )       );
%             
%             bool_out(bools_to_change)=~bool_out(bools_to_change);
%             ind2=ind1;
%             ind1=ind1+1;
%         end
%     end
% 
% 
% 
% 
% end
% 
% 
