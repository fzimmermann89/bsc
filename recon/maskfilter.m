function [ output ] = maskfilter( input,mask,outputSize )
    %filter if mask is bigger than input
    input=gather(input);
    mask=gather(mask);
    tmp=zeros(size(mask));
tmp(1+floor(end/2)-floor(size(input,1)/2):ceil(end/2)+ceil(size(input,1)/2),1+floor(end/2)-floor(size(input,2)/2):ceil(end/2)+ceil(size(input,2)/2))=input;
tmp=abs(ift2(ft2(tmp).*mask));
output=tmp(1+floor(end/2)-floor(outputSize(1)/2):ceil(end/2)+ceil(outputSize(1)/2),1+floor(end/2)-floor(outputSize(2)/2):ceil(end/2)+ceil(outputSize(2)/2));    
end

