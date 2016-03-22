function output=pad2size(input,tosize)
    tosize=[0,0]+tosize;
    output=zeros(tosize).*input(1,1);
    diff=tosize-size(input);
    if ~(diff>0)
        error('shrinking not supported')
    end
    pad=ceil(diff/2);
    idx=1+pad(1):pad(1)+size(input,1);
    idy=1+pad(2):pad(2)+size(input,2);
    output(idx,idy)=input;
end