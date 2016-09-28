function out=normalize(in)%,ids)
    out=in./in(end/2+2,end/2+2);
% out=(out-min(out(ids)));
end