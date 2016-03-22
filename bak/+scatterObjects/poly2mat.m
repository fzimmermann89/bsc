function out=poly2mat(N,vertx,verty,Nvectors)
xx=gpuArray.linspace(1,N,N);
yy=xx.';
Nv=Nvectors;
    function bool_out = inpoly(testx,testy)
        %Simple InPolygon Implementation.
        % Uses parent's Nv, vertx & verty
        %Based on C Code: Copyright (c) 1970-2003, Wm. Randolph Franklin, BSD-License
        %http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html

        bool_out=logical(false);
        ind1=1;
        ind2=Nv;

        while ind1<=Nv
            if ((verty(ind1)>testy) ~= (verty(ind2)>testy)) && ...
                    (testx <...
                    ( (vertx(ind2)-vertx(ind1)) * (testy-verty(ind1)) / (verty(ind2)-verty(ind1)) + vertx(ind1)  )...
                    )

                bool_out=~bool_out;
            end
            ind2=ind1;
            ind1=ind1+1;
        end
    end%inpoly
try
    out = arrayfun(@inpoly, xx, yy);
catch ex
    rethrow(ex);
end
end%poly2mat