function out=normalize(mat)
   % Normalize Scatter Image by removing center and scaling to max
   
   mat(end/2+1,end/2+1)=0;
   out=mat./max(mat(:));
end