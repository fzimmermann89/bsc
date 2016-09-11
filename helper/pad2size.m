function output=pad2size(input,tosize,val)
    tosize=[0,0]+tosize;
    if nargin<3||val==0
        output=zeros(tosize,'like',input);
    else
      output=zeros(tosize,'like',input)+val;  
    end
    
    diff=tosize-size(input);
    if ~(diff>=0)
        error('shrinking not supported')
    end
    pad=ceil(diff/2);
%     idx=1+pad(1):pad(1)+size(input,1);
%     idy=1+pad(2):pad(2)+size(input,2);
    output(1+pad(1):pad(1)+size(input,1),1+pad(2):pad(2)+size(input,2))=input;
end