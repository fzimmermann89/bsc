function [ start,support,crossImage ] = holoSupport( scatterImage,softmask,refImage,varargin )
    % Generates Start and Support based on holography as well as cross
    % correlation.
    % Parameters: scatterImage, softmask (mask softend to reduce ringing),
    %             refImage(image of the used reference)
    % Optional Parameters:
    %             radFilter (default:15)    radius of median filter
    %             radClose  (default:40)    radius of morphologically closing
    %             radDilate (default:15)    radius of dilation of support
    %             threshold (default:0.5)   threshold for detecting
    %                                       crosscorrelation in times of stddev.
    %             filterRef (default: false)filter reference for support
    %             debug     (default:false) show debug figures
    
    parser = inputParser;
    parser.addOptional('radFilter',15,@isscalar);
    parser.addOptional('radClose',40,@isscalar)
    parser.addOptional('radDilate',15,@isscalar)
    parser.addOptional('threshold',.5,@isscalar)
    parser.addOptional('filterRef',false,@islogical)
    parser.addOptional('debug',false,@islogical)
    parser.parse(varargin{:});
    radFilter=parser.Results.radFilter;%15
    radDilate=parser.Results.radDilate;%10;
    radClose=parser.Results.radClose;%40;
    threshold=parser.Results.threshold;%.5;
    
    if parser.Results.filterRef
        refImage=(maskfilter(double(refImage),softmask,size(refImage)*1.5));
    end
    
    
    %do ifft2 as reconstruction
    recon=((ift2(scatterImage.*softmask)));
    reconAbs=abs(recon);
    
    %find auto & cross correlation
    
    %partially supress noise
    reconAbsFilt=medfilt2(reconAbs,[radFilter,radFilter]);
    
    %Create BW mask
    idx=true(size(recon));
    idx(end/2+1-end/4:end/2+1+end/4,end/2+1-end/4:end/2+1+end/4)=false;
    reconBw=abs(reconAbsFilt-(mean((reconAbsFilt(idx)))))>(threshold*std(reconAbsFilt(idx)));
    
    %reconBw=reconAbsFilt>threshold*median(reconAbsFilt(idx));
    
    
    %remove single pixels
    reconBw = imopen((reconBw),strel('disk',2)); %5%25
    
    %smooth support
    reconBw = imclose((reconBw),strel('disk',radClose));%50%60 %25
    reconBw = imfill((reconBw), 'holes');
    
    %remove smaller areas
    reconBw=bwareaopen(gather(reconBw),(length(recon)/16)^2);
    
    reconBw=imdilate(reconBw,strel('disk',radDilate));
    if parser.Results.debug
        figure(22);imagesc(reconAbs);
        figure(11);subplot(211);imagesc(reconBw.*((reconAbs./max(reconAbs(:)))+1));caxis([0,2]);title('supp holo');
        figure(11);subplot(212);imagesc(~reconBw.*((reconAbs./max(reconAbs(:)))));caxis([0,1]);title('not sup');
    end
    props=regionprops(reconBw,reconAbs, {'Area','Centroid','SubarrayIdx','Image'});%
    
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
    if isa(scatterImage,'gpuArray')
        %got gpu input
        start=gpuArray.zeros(size(reconAbs));
        support=gpuArray.false(size(reconAbs));
    else
        start=zeros(size(reconAbs));
        support=false(size(reconAbs));
    end
    
    crossSize=size(cross(1).Image);
    refImage=padarray(refImage,[radDilate,radDilate],refImage(1),'both');
    refSize=size(refImage);
    crossImage=recon(cross(1).SubarrayIdx{1},cross(1).SubarrayIdx{2});%.*imdilate(cross(1).Image,strel('disk',2*radDilate));
    refSupport=abs(refImage-refImage(1))>1e-3*max(max(abs(refImage-refImage(1))));
    refSupport=imdilate(refSupport,strel('disk',ceil(radDilate/2)));
    refSupport = imfill((refSupport), 'holes');
    
    %set the reference
    support(...
        1+  ceil (end/2-refSize(1)/2)+  floor(diff(2)/2):...
        0+  ceil (end/2+refSize(1)/2)+  floor(diff(2)/2),...
        1+  ceil (end/2-refSize(2)/2)+  floor(diff(1)/2):...
        0+  ceil (end/2+refSize(2)/2)+  floor(diff(1)/2)...
        )=refSupport;
    
    start(...
        1+  ceil (end/2-refSize(1)/2)+  floor(diff(2)/2):...
        0+  ceil (end/2+refSize(1)/2)+  floor(diff(2)/2),...
        1+  ceil (end/2-refSize(2)/2)+  floor(diff(1)/2):...
        0+  ceil (end/2+refSize(2)/2)+  floor(diff(1)/2)...
        )=refImage./max(abs(refImage(:)));%.*rand(size(refImage));
    
    %set cross correlation
    %     crossImage=crossImage./max(abs(crossImage(:)));
    start(...
        1+  ceil (end/2-crossSize(1)/2)-  ceil(diff(2)/2):...
        0+  ceil (end/2+crossSize(1)/2)-  ceil(diff(2)/2),...
        1+  ceil (end/2-crossSize(2)/2)-  ceil(diff(1)/2):...
        0+  ceil (end/2+crossSize(2)/2)-  ceil(diff(1)/2)...
        )=crossImage./max(abs(crossImage(:)));
    support(...
        1+  ceil (end/2-crossSize(1)/2)-  ceil(diff(2)/2):...
        0+  ceil (end/2+crossSize(1)/2)-  ceil(diff(2)/2),...
        1+  ceil (end/2-crossSize(2)/2)-  ceil(diff(1)/2):...
        0+  ceil (end/2+crossSize(2)/2)-  ceil(diff(1)/2)...
        )=cross(1).Image;
    
    %dilate for loose support (XXX)
    support = imfill((support), 'holes');
    
end