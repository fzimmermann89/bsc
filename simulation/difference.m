function [x,absdy,reldy,ids]=difference(x1,y1,x2,y2)
    % calculates the difference between to (x,y)-series.
    % by finding the corresponding element in x2 for each element in x1
    % and comparing the corrosponding y's.
    % returns absolute (y1-y2) and relative (with respect to y2) difference and
    % the ids used to index into x2,y2. GPU aware.
    
    
    % make sure x1 and x2 are sorted
    if ~issorted(x1)
        [x1,id]=sort(x1);
        y1=y1(id);
    end
    if ~issorted(x2)
        [x2,id]=sort(x2);
        y2=y2(id);
    end
    
    %find matching x's
    %arrayfun
        nx2=length(x2);
        ids=arrayfun(@match,x1,repmat(nx2,nx2,1));   
        function out=match(x,nx2)
            if x2(1)>=x
                out=1;
                return;
            end
            for n=2:nx2
                if x2(n)>=x
                    if abs(x2(n)-x)<abs(x2(n-1)-x)
                    out=n;
                    else
                        out=n-1;
                    end
                    return;
                end
            end
            out=nx2;
        end
    
    
    % %using min
    % ids=repmat(length(x2),length(x1),1);
    % for m=1:length(x1);
    %     [~,t]=min(abs(x2-x1(m)));
    %     ids(m)=t;
    % end
    
    %%loops
    %ids=repmat(length(x2),length(x1),1);
    %     for m=1:length(x1);
    %         curx=x1(m);
    %         if x2(1)>=curx
    %             ids(m)=1;
    %         else
    %             for n=2:length(x2)
    %                 if x2(n)>=curx
    %                     if abs(x2(n)-curx)<abs(x2(n-1)-curx)
    %                         ids(m)=n;
    %                     else
    %                         ids(m)=n-1;
    %                     end
    %                     break;
    %                 end
    %             end
    %         end
    %     end
    
    
    x=x2(ids);
    absdy=(y1-y2(ids));
    reldy=absdy./y2(ids);
    %
end