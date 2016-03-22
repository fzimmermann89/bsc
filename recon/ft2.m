function data=ft2(data)
    N=size(data,1);
    %works for uneven and even
    % index= mod((0:N-1)-double(rem(floor(N/2),N)), N)+1;
    %works only for even
    index=mod((0:N-1)-N/2,N)+1;
    data = data(index,index);
    data=fft2(data);
    data=data(index,index);
end
