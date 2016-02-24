function bench2()
i=rand(10000);
g=gpuArray(i);
tic
og=(arrayfun(@test_gpu,g));
toc

tic
ov=sin(i);
toc

tic
ovg=gather(sin(g));
toc

    function out = test_gpu( in )
out=sin(in);
end



end
% N=1024;
% Nz=2048;
% display('object_cpu')
% tic
% obj=scatterObjects.sphere(N,false);
% cpu=(zeros(N,N));
% for n=1:Nz
%     cpu=cpu+obj.getSlice(gpuArray(n));
% end
% toc
% %
% % display('object_unknown')
% % tic
% % obj=scatterObjects.sphere(N,400,true);
% %
% % obj.N=4000;
% % obj.radius=2000;
% % tmp=(zeros(obj.N,obj.N));
% % for n=1:Nz
% %     tmp=tmp+obj.getSlice(n);
% % end
% % unk=gather(tmp);
% % display(cpu(1,1)-unk(1,1));
% % toc
%
%
% display('object_gpu')
% tic
% obj=scatterObjects.sphere(N,true);
% tmp=(zeros(N,N));
% for n=1:Nz
%     tmp=tmp+obj.getSlice(gpuArray(n));
% end
% gpu=gather(tmp);
% toc
% display(cpu(1,1)-gpu(1,1));
%
%
% % display('object_gpu_allinone')
% % tic
% % obj=scatterObjects.sphere(N,400);
% % tmp=(zeros(N,N));
% % for n=1:Nz
% %     tmp=tmp+obj.getSlice(n,false);
% % end
% % a=gather(tmp);
% % toc
% %
% %
% %
% % display('object_gpu_fest')
% % tic
% % obj=scatterObjects.sphere(N,400);
% % fung=@obj.getSlice_gpu;
% % tmp=(zeros(N,N));
% % for n=1:Nz
% %     tmp=tmp+fung(n);
% % end
% % a=gather(tmp);
% % toc
% %
% %
% %
% %
% %
% % display('object_gpu_var')
% % tic
% % obj=scatterObjects.sphere(N,400);
% % fung=obj.getSliceFunc(true);
% % tmp=(zeros(N,N));
% % for n=1:Nz
% %     tmp=tmp+fung(n);
% % end
% % a=gather(tmp);
% % toc
%
%
%
%
%
% % display('object_cpu_var')
% % tic
% % obj=scatterObjects.sphere(N,400);
% % func=obj.getSliceFunc(false);
% % tmp=zeros(N,N);
% % for n=1:Nz
% %     slice=func(n);
% %     tmp=tmp+slice;
% % end
% % toc
