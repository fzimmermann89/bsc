function out=icorrectoffsetspan(x,ref,ids)
    start=min(x(ids));
    xo=gpuArray(single(x(ids)));
    ref=gpuArray(single(ref(ids)));
    
    
    param= fminsearch(@(p) errabs([p(1),p(2),p(3)]),[start,1,start],optimset('Display','off','TolX',1e-35,'TolFun',1e-35));
    %     param(3)=param(1);
    %     fprintf('params %d %d %d',param(1),param(2),param(3))
    out=val(x,param);
    
    function out=errabs(p)
        v=(xo-p(1))*p(2)+p(3);
        out=abs(gather(mean(abs(single((v-ref)./ref)))))+gather(1e3*sum(abs(min(v(:),0))));
        %        out=abs(gather(median(single((v-ref)./ref))))+gather(median(abs(single((v-ref)./ref))))+gather(1e3*sum(abs(min(v(:),0))));
    end
    
    
    function out=val(x,p)
        out=(x-p(1))*p(2)+p(3);
    end
end