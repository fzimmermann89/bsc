function idx=getIdx(N)
    idx = cell(1, 2);
    for k = 1:2
        idx{k} = mod((0:N-1)-double(rem((N/2),N)), N)+1;
    end
end