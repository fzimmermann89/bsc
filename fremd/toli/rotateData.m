function output = rotateData(handles, angleX, angleY)
% This function rotates arbitary cubic data (all three dimensions of the
% scattering matrix mus be equal. It needs the handles-Object and two
% angles in degrees. It returns the rotated data.

data=handles.current_data;
N = size(data,2);
output=zeros(N,N,N);
alpha=angleX/180*pi;
beta=angleY/180*pi;
Rx = [1 0 0; 0 cos(alpha) -sin(alpha); 0 sin(alpha) cos(alpha)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
koordVec = zeros(3,1); %#ok<NASGU>

val = get(handles.object_popupmenu, 'Value'); %#ok<NASGU>
str = get(handles.object_popupmenu, 'String'); %#ok<NASGU>

% [X Y Z] = meshgrid(-N/2+1 : N/2,-N/2+1 : N/2,-N/2+1 : N/2);
% xi = -N/2+1 : N/2;
% yi = -N/2+1 : N/2;
% zi = -N/2+1 : N/2;
% % koordVec = round(Ry*Rx*[X;Y;Z])*data(X.,Y.,Z.);
% rotMat(xi+N/2,yi+N/2,zi+N/2) = Ry*Rx*[xi;yi;zi];
% output(xi+N/2,yi+N/2,zi+N/2) = .*data(xi+N/2,yi+N/2,zi+N/2);
for i = -N/2+1 : N/2
    if sum(sum(data(i+N/2,:,:)))>0
        for j = -N/2+1 : N/2
            for k = -N/2+1 : N/2
                if data(i+N/2,j+N/2,k+N/2) > 0
                    koordVec = round(Ry*Rx*[i;j;k]);
                    if koordVec > [-N/2+1; -N/2+1; -N/2+1] & koordVec < [N/2; N/2; N/2] %#ok<BDSCA,AND2>
                        output(koordVec(1)+N/2,koordVec(2)+N/2,koordVec(3)+N/2) = data(i+N/2,j+N/2,k+N/2);
                    end
                end
            end
        end
    end
end

if get(handles.opening_checkbox, 'Value')
    output = opening(output);
end