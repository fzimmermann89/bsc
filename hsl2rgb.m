function [rgb] = hsl2rgb(hsl)
    l_temp = hsl(:,:,3)*2;
    ind = l_temp <= 1;
    s_temp=(hsl(:,:,2));
    s_temp(ind) = s_temp(ind) .* l_temp(ind);
    s_temp(~ind) = s_temp(~ind) .* (2 - l_temp(~ind));
    hsv=zeros(size(hsl));
    hsv(:,:,3) = (l_temp +s_temp) ./ 2;
    hsv(:,:,2) = (2 * s_temp) ./ (l_temp + s_temp);
    hsv(:,:,1)=hsl(:,:,1);
    rgb=hsv2rgb(hsv);
end
