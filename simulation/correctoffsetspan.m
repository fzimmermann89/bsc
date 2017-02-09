function x=correctoffsetspan(x,ref,ids)
    % corrects the offset and span of a 1d x with regard to ref considering only
    % those entries where ids is true
    
    err([0,1,0])
    param=fminsearch(@(p) err(p),[min(x(ids)),1,min(x(ids))],optimset('Display','off','TolX',1e-14,'TolFun',1e-14));
    x=val(param);
    err([0,1,0])
    function out=err(p)
        v=val(p);
        tmp=abs((v-ref)./ref);
        out=median(tmp(ids))+1e9*sum(abs(v(v<0)));
    end
    function out=val(p)
        out=(x-p(1))*p(2)+p(3);
    end
end