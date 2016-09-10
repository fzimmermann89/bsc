function save_image(filename)

I = gca;
CM = get(gcf,'Colormap');
fig = figure;
copyobj(I,fig)

axis off;
colormap(CM);
posisFigure=get(gcf,'position');
maxF=min(posisFigure(3),posisFigure(4));

set(gcf,'position',[2000, 300, maxF*size(I,2)/size(I,1), maxF]);
set(gca,'position',[0 0 1 1],'units','normalized');
set(gcf,'PaperPositionMode','auto'); 
if nargin<1
[FileName, PathName] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Save Image');
      filename=fullfile(PathName, FileName);
end
saveas(gca, filename)
close(fig)