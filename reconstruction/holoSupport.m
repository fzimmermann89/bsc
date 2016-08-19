function [ start,support,crossImag ] = holoSupport( scatterImage,refImage )
    %generates Support based on holography
    %     [xx,yy]=meshgrid(-refRadius:1:refRadius);
    %     refImage=xx.^2+yy.^2<refRadius^2;
    %     maybe filtering?

    %do ifft2 as reconstruction
    recon=((ift2(scatterImage)));
    reconAbs=abs(recon);
    %find auto & cross correlation

    %partially supress noise
%         reconAbs=medfilt2(reconAbs);

    reconAbsFilt=medfilt2(reconAbs,[15,15]);
    reconBw=reconAbsFilt>3*median(reconAbs(:));
%     thresholdRelative = 0.008%0.008;%0.002%0.001;
%     threshold=min(reconAbs(:))+thresholdRelative*(max(reconAbs(:))-min(reconAbs(:)))
% %        threshold=0.2;
%     reconBw = reconAbs > threshold;
% 
%     %     threshold=graythresh(gather(recon));
%     %     reconBw = im2bw(gather(recon),threshold);

     reconBw = imfill((reconBw), 'holes');

    %remove single pixels
%     reconBw = imopen((reconBw),strel('disk',5)); %5%25

%     %increase support and smoothen it
    reconBw = imdilate((reconBw),strel('disk',15)); %15%25
    reconBw = imclose((reconBw),strel('disk',10));%50%60 %25
%     reconBw = imdilate((reconBw),strel('disk',5));%20 %25
    reconBw = imfill((reconBw), 'holes');
    
    figure(11);subplot(211);imagesc(reconBw.*(reconAbs+1));caxis([0,2]);title('supp holo');
        figure(11);subplot(212);imagesc(~reconBw.*(reconAbs));caxis([0,1]);title('not sup');

    props=regionprops(reconBw,reconAbs, 'all');%

    %auto correlation is biggest area
    [~,nauto]=max([props.Area]);
    auto=props(nauto);
    props(nauto)=[];

    %cross correlation are next two biggest areas
    [~,ncross]=max([props.Area]);
    cross(1)=props(ncross);
    props(ncross)=[];

    [~,ncross]=max([props.Area]);
    cross(2)=props(ncross);
    props(ncross)=[];

    %find distance between reference and object=0.5*distance between cross
    %correlations
    diff=round((cross(2).Centroid-cross(1).Centroid)/2);

    %Construct support
    if strcmp(class(scatterImage),'gpuArray')
        %got gpu input
        start=gpuArray.zeros(size(reconAbs));
        support=gpuArray.false(size(reconAbs));
    else
        start=zeros(size(reconAbs));
        support=false(size(reconAbs));
    end

    crossSize=size(cross(1).Image);
    refSize=size(refImage);
    crossImag=recon(cross(1).SubarrayIdx{1},cross(1).SubarrayIdx{2});
    refSup=abs(refImage)>1e-1;
    refSup = imfill((refSup), 'holes');

    %set the reference
    support(...
        1+  ceil (end/2-refSize(1)/2)+  floor(diff(2)/2):...
        0+  ceil (end/2+refSize(1)/2)+  floor(diff(2)/2),...
        1+  ceil (end/2-refSize(2)/2)+  floor(diff(1)/2):...
        0+  ceil (end/2+refSize(2)/2)+  floor(diff(1)/2)...
        )=refSup;

    start(...
        1+  ceil (end/2-refSize(1)/2)+  floor(diff(2)/2):...
        0+  ceil (end/2+refSize(1)/2)+  floor(diff(2)/2),...
        1+  ceil (end/2-refSize(2)/2)+  floor(diff(1)/2):...
        0+  ceil (end/2+refSize(2)/2)+  floor(diff(1)/2)...
        )=abs(refImage);%.*rand(size(refImage));

    %set cross correlation
    crossImag=crossImag./max(abs(crossImag(:)));
    start(...
        1+  ceil (end/2-crossSize(1)/2)-  ceil(diff(2)/2):...
        0+  ceil (end/2+crossSize(1)/2)-  ceil(diff(2)/2),...
        1+  ceil (end/2-crossSize(2)/2)-  ceil(diff(1)/2):...
        0+  ceil (end/2+crossSize(2)/2)-  ceil(diff(1)/2)...
        )=crossImag;
    support(...
        1+  ceil (end/2-crossSize(1)/2)-  ceil(diff(2)/2):...
        0+  ceil (end/2+crossSize(1)/2)-  ceil(diff(2)/2),...
        1+  ceil (end/2-crossSize(2)/2)-  ceil(diff(1)/2):...
        0+  ceil (end/2+crossSize(2)/2)-  ceil(diff(1)/2)...
        )=cross(1).Image;



    %         support(1+floor(end/2-diff(1)-refRadius):ceil(end/2-diff(1)+refRadius),1+floor(end/2-diff(2)-refRadius):ceil(end/2-diff(2)+refRadius))=refImage;
    %         support(1+floor(end/2+diff(1)-refRadius):ceil(end/2+diff(1)+refRadius),1+floor(end/2-diff(2)-refRadius):ceil(end/2-diff(2)+refRadius))=refImage;
    %   support(1+floor(end/2-diff(1)-refRadius):ceil(end/2-diff(1)+refRadius),1+floor(end/2+diff(2)-refRadius):ceil(end/2+diff(2)+refRadius))=refImage;
    %not yet working





    %dilate image (XXX)
        support=imdilate(support,strel('disk',2));
end











