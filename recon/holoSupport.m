function [ support ] = holoSupport( scatterImage )
    %generates Support based on holography
    refRadius=30;
    [xx,yy]=meshgrid(-refRadius:1:refRadius);
    refImage=xx.^2+yy.^2<refRadius^2;
    
   
    %do ifft2 as reconstruction
    recon=(abs(ift2(scatterImage)));
    
    %find auto & cross correlation
    
    thresholdRelative = 0.0001;
    threshold=min(recon(:))+thresholdRelative*(max(recon(:))-min(recon(:)));
    bwrecon = recon > threshold;
    
    threshold=graythresh(gather(recon));
    reconBw = im2bw(gather(recon),threshold);
    reconBw = imfill(gpuArray(reconBw), 'holes');
    
    props=regionprops(reconBw, {'Area','Centroid','Image'});
    
    %auto correlation is biggest area
    [~,nauto]=max([props.Area]);
    auto=props(nauto);
    cross=props;
    cross(nauto)=[];
    
    %find distance between reference and object=distance auto and cross
    %correlations
    diff=(cross(2).Centroid-cross(1).Centroid)/2;
    
    %Construct support
    support=gpuArray.false(size(recon));
    
    %set cross correlation in the center of support
    crosssize=size(cross(1).Image);
    support(1+ceil(end/2-crosssize(1)/2):ceil(end/2+crosssize(1)/2),1+ceil(end/2-crosssize(2)/2):ceil(end/2+crosssize(2)/2))=cross(1).Image;
    
    %and the reference in the calculated distance away
    support(1+floor(end/2+diff(2)-refRadius):ceil(end/2+diff(2)+refRadius),1+floor(end/2+diff(1)-refRadius):ceil(end/2+diff(1)+refRadius))=refImage;
%         support(1+floor(end/2-diff(1)-refRadius):ceil(end/2-diff(1)+refRadius),1+floor(end/2-diff(2)-refRadius):ceil(end/2-diff(2)+refRadius))=refImage;
%         support(1+floor(end/2+diff(1)-refRadius):ceil(end/2+diff(1)+refRadius),1+floor(end/2-diff(2)-refRadius):ceil(end/2-diff(2)+refRadius))=refImage;
%   support(1+floor(end/2-diff(1)-refRadius):ceil(end/2-diff(1)+refRadius),1+floor(end/2+diff(2)-refRadius):ceil(end/2+diff(2)+refRadius))=refImage;
    %not yet working
    
    %dilate image (XXX)
%     support=imdilate(support,ones(refRadius));
end

