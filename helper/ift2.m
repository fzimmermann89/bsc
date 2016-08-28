function data=ift2(data)
    % perform 2d iFT for even N with correct (and fast) shifting
    % Necessary because fftshift is extremly slow on gpuArrays
    
    N=size(data,1);
    %works for even and uneven
    %     index= mod((0:N-1)-double(rem(ceil(N/2),N)), N)+1;
    %works for even only
    index=mod((0:N-1)-N/2,N)+1;
    data = data(index,index);
    data=ifft2(data);
    data=data(index,index);
end
