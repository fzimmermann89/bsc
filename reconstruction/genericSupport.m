function [start,support]=genericSupport(scatterImage,softmask,relThreshold)
    %creates a support and start values without using holography
    if nargin<3;relThreshold=0.005;end
   support=abs(ift2(scatterImage.*softmask));
    support=support>max(support(:))*relThreshold;

    support = imdilate(support,ones(3));
    support = imfill(support, 'holes');
    
%     st = regionprops(uint16(support), 'BoundingBox' );
%     support=zeros(size(scatterImage));
%     support(end/2-st.BoundingBox(4)/4:end/2+st.BoundingBox(4)/4,end/2-st.BoundingBox(3)/4:end/2+st.BoundingBox(3)/4)=1;
%    
%     
    
    randPhase=2*pi*rand(size(scatterImage));
    start=(ift2(sqrt(scatterImage).*exp(1i*randPhase).*softmask));
end
