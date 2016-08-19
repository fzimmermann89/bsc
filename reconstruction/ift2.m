function data=ift2(data)
    N=size(data,1);
    %works for even and uneven
    %     index= mod((0:N-1)-double(rem(ceil(N/2),N)), N)+1;
    %works for even only
    index=mod((0:N-1)-N/2,N)+1;
    data = data(index,index);
    data=ifft2(data);
    data=data(index,index);
end
