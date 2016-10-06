function [start,support]=genericSupport(scatterImage,softmask,relThreshold,halfbox)
    %creates a support and start values without using holography. if halfbox is
    %true, the support will be half of the boundingbox of the autocorrelation,
    %otherwise it will be the autocorrelation.
    
    if nargin<3;relThreshold=0.005;end
    support=abs(ift2(scatterImage.*softmask));
    support=abs(support-support(1))>max(abs(support(:)-support(1)))*relThreshold;   
    support = imdilate(support,ones(3));
    support = imfill(support, 'holes');
   
    if nargin>3&&halfbox
        st = regionprops(uint16(support), 'BoundingBox' );
        support=zeros(size(scatterImage));
        support(end/2-st.BoundingBox(4)/4:end/2+st.BoundingBox(4)/4,end/2-st.BoundingBox(3)/4:end/2+st.BoundingBox(3)/4)=1;
    end
    
    randPhase=2*pi*rand(size(scatterImage));
    start=(ift2(sqrt(scatterImage).*exp(1i*randPhase).*softmask));
end
