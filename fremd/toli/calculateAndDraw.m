function output = calculateAndDraw(handles)
% This function executes the setData function, which sets the chosen data,
% rotates this data with the rotateData function and plots the scattering
% data in two or three dimensions. It needs the handles-Object and returns
% the scattering data.

N=round(str2double(get(handles.N_edit,'String')));
voxelScale = (N/2-2)/get(handles.radius_slider,'Value');%str2num(get(handles.voxel_edit,'String')); %#ok<ST2NM>
set(handles.voxel_edit,'String',num2str(voxelScale));
set(handles.voxel_text,'String',['1 Voxel = ',num2str(1/str2num(get(handles.voxel_edit,'String'))),' nm']); %#ok<ST2NM>
handles.current_data=setData(handles);

rotX = str2double(get(handles.rotateX_edit,'String'));
rotY = str2double(get(handles.rotateY_edit,'String'));
if rotX ~= 0 || rotY ~= 0
    handles.current_data=rotateData(handles, rotX, rotY);
end
set(streuOmat,'CurrentAxes',handles.axes1);

val = get(handles.dimensions_popupmenu, 'Value');
str = get(handles.dimensions_popupmenu, 'String');

switch str{val}
    case '2D projection'
        data2D = sum(handles.current_data,3);
        xScaleValues = -(N/2+1)/voxelScale : 1/voxelScale : N/2/voxelScale;
        imagesc(xScaleValues,xScaleValues,data2D);colormap(hot);
    case '3D shape'
        m=1;
        for i=1:N
            for j=1:N
                temp=0.;
                for k=1:N
                    temp = temp + handles.current_data(i,j,k);
                    if handles.current_data(i,j,k) > 0 % || (i==N/2 && j==N/2) das einkommentieren um eine Linie entlang der Streurichtung einzuzeichnen
                        x(m)=i; %#ok<AGROW>
                        y(m)=j; %#ok<AGROW>
                        z(m)=k; %#ok<AGROW>
                        m=m+1;
                    end
                    
                end
            end
        end
        scatter3(x,z,y,'filled');axis([1 N 1 N 1 N]); axis square;
end

output = handles.current_data;
