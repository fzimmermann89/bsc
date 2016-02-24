function negLog2(handles,input)

% maskP = input > 0;
% maskN = input < 0;

% (log(input.*maskP)>-Inf).*log(input.*maskP).*maskP + (log(-input.*maskN)>-Inf).*log(-input.*maskN).*maskN;
N = length(input);
% figure(1); 
% subplot(1,2,1); imagesc(log((abs(input(N/4+1:3/4*N,N/4+1:3/4*N))))); axis square; colorbar; colormap fire;
% subplot(1,2,2); imagesc(cart2pol(imag(input),real(input))); axis square; colorbar;

h=figure(2);
% data2D = sum(handles.current_data,3);
% subplot(1,2,1); imagesc(data2D); axis square; colormap fire;
% set(gca, 'XTick', []);
% set(gca, 'YTick', []);
% subplot(1,2,2); 
imagesc(log((abs(input(N/4+1:3/4*N,N/4+1:3/4*N)))),[4 10]); axis square; colormap fire;
set(gca, 'XTick', []);
set(gca, 'YTick', []);
%         newFolder = fullfile(pwd, '\holo');
%         if ~exist([pwd,'\holo'], 'dir')
%             mkdir([pwd, '\holo'])
%         end
% dlmwrite(fullfile(newFolder,['Int_1zu',get(handles.core_edit,'String'),'_rad_1zu',get(handles.shift_edit,'String'),'holo.dat']),abs(input(N/4+1:3/4*N,N/4+1:3/4*N)))
% saveas(h,fullfile(newFolder,['Int_1zu',get(handles.core_edit,'String'),'_rad_1zu',get(handles.shift_edit,'String'),'holo.tif']));