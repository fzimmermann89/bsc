function [ start,support,crossImag ] = holoSupport( scatterImage,softmask,refImage )
    %generates Support based on holography
    radFilter=10;
    radDilate=5;
    radClose=5;
    %do ifft2 as reconstruction
    recon=((ift2(scatterImage.*softmask)));
    reconAbs=abs(recon);
    
    %find auto & cross correlation
    
    %partially supress noise
    reconAbsFilt=medfilt2(reconAbs,[radFilter,radFilter]);
    
    %Create BW mask
    reconBw=reconAbsFilt>2*median(reconAbsFilt(:));
    reconBw = imfill((reconBw), 'holes');
    
    %remove single pixels
    reconBw = imopen((reconBw),strel('disk',floor(radFilter))); %5%25
    
    %smooth support
    reconBw = imclose((reconBw),strel('disk',radClose));%50%60 %25
    
%     figure(11);subplot(211);imagesc(reconBw.*(reconAbs+1));caxis([0,2]);title('supp holo');
%     figure(11);subplot(212);imagesc(~reconBw.*(reconAbs));caxis([0,1]);title('not sup');
    
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
    if isa('scatterImage','gpuArray')
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
    
    %dilate for loose support (XXX)
    support=imdilate(support,strel('disk',radDilate));
    support = imfill((support), 'holes');
    
end











