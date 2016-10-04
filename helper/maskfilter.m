function [ output ] = maskfilter( input,mask,outputSize )
    %filter if mask is bigger than input by padding input
    if nargin<3;outputSize=size(input);end;
    tmp=zeros(size(mask),'like',input)+input(1);
    tmp(1+floor(end/2)-floor(size(input,1)/2):ceil(end/2)+ceil(size(input,1)/2),1+floor(end/2)-floor(size(input,2)/2):ceil(end/2)+ceil(size(input,2)/2))=input;
    tmp=(ift2(ft2(tmp).*mask));
    output=tmp(1+floor(end/2)-floor(outputSize(1)/2):ceil(end/2)+ceil(outputSize(1)/2),1+floor(end/2)-floor(outputSize(2)/2):ceil(end/2)+ceil(outputSize(2)/2));
end

