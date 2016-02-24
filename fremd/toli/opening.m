function output = opening(input)
% This function implements an opening algorithm. Each neighbor of a
% non-zero point is set to one. Afterwards each point with at least one empty
% neighbor is set to zero. This is needed when an object is rotated
% numerically and holes are created through rounding of the rotated pixel.

output=input;
N = size(input,1);
% se = strel('disk',2);
se = ones(3);

for i = 1 : N
    output(i,:,:) = imopen(input(i,:,:),se);
    output(i,:,:) = imclose(output(i,:,:),se);
end

% input=output;

% for i = 2 : N-1
%     for j = 2 : N-1
%         for k = 2 : N-1
%             localMin = 20;
%             for p = -1 : 1
%                 for q = -1 : 1
%                     for r = -1 : 1
%                         if input(i+p,j+q,k+r) < localMin
%                             output(i,j,k) = input(i+p,j+q,k+r);% Bei Graustufen muss hier das MINIMUM rein
%                             localMin = input(i+p,j+q,k+r);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end

% for i = 2 : N-1
%     for j = 2 : N-1
%         for k = 2 : N-1
%             localMax = 0;
%             for p = -1 : 1
%                 for q = -1 : 1
%                     for r = -1 : 1
%                         if input(i+p,j+q,k+r)>localMax
%                             output(i,j,k) = input(i+p,j+q,k+r);% Bei Graustufen muss hier das MAXIMUM rein
%                             localMax = input(i+p,j+q,k+r);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% input=output;
% 
% for i = 2 : N-1
%     for j = 2 : N-1
%         for k = 2 : N-1
%             localMin = 20;
%             for p = -1 : 1
%                 for q = -1 : 1
%                     for r = -1 : 1
%                         if input(i+p,j+q,k+r) < localMin
%                             output(i,j,k) = input(i+p,j+q,k+r);% Bei Graustufen muss hier das MINIMUM rein
%                             localMin = input(i+p,j+q,k+r);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end