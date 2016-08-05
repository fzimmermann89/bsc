function data=ft2(data)
    % perform 2d FT for even N with correct (and fast) shifting
    % Necessary because fftshift is extremly slow on gpuArrays
    
    N=size(data,1);
    %works for uneven and even
    % index= mod((0:N-1)-double(rem(floor(N/2),N)), N)+1;
    %works only for even
    index=mod((0:N-1)-N/2,N)+1;
    data = data(index,index);
    data=fft2(data);
    data=data(index,index);
end
