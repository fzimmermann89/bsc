function out=halfimage_cpu(data)
    N=floor(length(data)/2);
    [xx,yy]=meshgrid(0:N-1);
    % xx=gpuArray(0:N-1);
    % yy=xx';
    data=gather(data);
        out=arrayfun(@work,xx,yy);
    
    out=zeros(N,N);
%     parfor x=0:(N-1)
%         tmp2=zeros(N,1);
%         for y=0:(N-1)
%             N2=2*N;
%             x2=x*2;
%             y2=y*2;
%             left=0;
%             if (x>0)
%                 left=(2*data(1+(x2-1)*N2+y2)+data(1+(x2-1)*N2+y2+1));
%                 if (y>0);left=left+data(1+(x2-1)*N2+y2-1);end;
%             end
%             if (y>0);left=left/4;else left=left/3;end;
%             
%             center=(2*data(1+x2*N2+y2)+data(1+x2*N2+y2+1));
%             if (y>0); center=center+data(1+x2*N2+y2-1);end;
%             if (y>0); center=center/4; else center=center/3;end
%             
%             right=(2*data(1+(x2+1)*N2+y2)+data(1+(x2+1)*N2+y2+1));
%             if (y>0); right=right+data(1+(x2+1)*N2+y2-1);end;
%             if (y>0); right=right/4;else right=right/3;end;
%             
%             tmp=(left+2*center+right);
%             if (x>0);tmp=tmp/4;else tmp=tmp/3; end
%             tmp2(y+1)=tmp;
%             
%         end
%         out(:,x+1)=tmp2;
%     end
    function out=work(x,y)
        N2=2*N;
        x2=x*2;
        y2=y*2;
        left=0;
        if (x>0)
            left=(2*data(1+(x2-1)*N2+y2)+data(1+(x2-1)*N2+y2+1));
            if (y>0);left=left+data(1+(x2-1)*N2+y2-1);end;
        end
        if (y>0);left=left/4;else left=left/3;end;
        
        center=(2*data(1+x2*N2+y2)+data(1+x2*N2+y2+1));
        if (y>0); center=center+data(1+x2*N2+y2-1);end;
        if (y>0); center=center/4; else center=center/3;end
        
        right=(2*data(1+(x2+1)*N2+y2)+data(1+(x2+1)*N2+y2+1));
        if (y>0); right=right+data(1+(x2+1)*N2+y2-1);end;
        if (y>0); right=right/4;else right=right/3;end;
        
        out=(left+2*center+right);
        if (x>0);out=out/4;else out=out/3; end
        
    end
end