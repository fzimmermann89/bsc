function [start,support]=genericSupport(scatterImage,softmask,relThreshold)
    %creates a support and start values without using holography
    if nargin<3;relThreshold=0.005;end
    support=abs(ift2(scatterImage.*softmask));
    support=support>max(support(:))*relThreshold;
    support = imdilate(support,ones(3));
    support = imfill(support, 'holes');
    randPhase=randn(size(scatterImage));
    start=abs(ift2(sqrt(scatterImage).*exp(1i*randPhase).*softmask));
end
