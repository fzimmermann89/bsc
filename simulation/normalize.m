function out=normalize(mat)
   mat(end/2+1,end/2+1)=0;
   out=mat./max(mat(:));
end