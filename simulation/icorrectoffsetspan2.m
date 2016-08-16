function out=icorrectoffsetspan2(x,ref,ids)
    xo=gpuArray(single(x(ids)));
    ref=gpuArray(single(ref(ids)));
    
    
    param= fminsearch(@(p) errabs(p),1,optimset('Display','off','TolX',1e-35,'TolFun',1e-35));
%     fprintf('param %d\n',param)
    out=x*param;
    
    function out=errabs(p)
        out=abs(gather(mean(abs(single(((xo*p)-ref)./ref)))));
    end
    
 
end