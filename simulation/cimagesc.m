function  cimagesc( img,plottitle )
    if ~exist('plottitle','var');
        plottitle='';
    end
    subplot(1,2,1);imagesc(abs(img));title(['abs ' plottitle]);axis square;colorbar;
    subplot(1,2,2);imagesc(angle(img));title(['phase' plottitle]);axis square;colorbar;
end

