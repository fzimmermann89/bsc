function scatteringObject = setData(handles)
% This functions sets the scattering object. It needs the handles-Object and
% returns the scattering object. 
%
% Include new scattering objects here!

N = round(str2double(get(handles.N_edit,'String')));
%voxelScale = str2double(get(handles.voxel_edit,'String'));
r2rad = get(handles.r2rad_slider,'Value');
radius = N/2-2;%/get(handles.radius_slider,'Value')/voxelScale;
shift = get(handles.shift_slider,'Value');
core = str2double(get(handles.core_edit,'String'));
scatteringObject = zeros(N,N,N);

val = get(handles.object_popupmenu, 'Value');
str = get(handles.object_popupmenu, 'String');

switch str{val}
    case 'twins'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        scatteringObject1 = double((Y.^2+(X-radius*(1-r2rad)).^2+Z.^2) <= (radius*r2rad)^2);
        scatteringObject2 = double((Y.^2+(X+radius*(1-r2rad)).^2+Z.^2) <= (radius*r2rad*shift)^2);
        scatteringObject = scatteringObject1 + core*scatteringObject2;
    case 'sphere'
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        scatteringObject = double((X.^2+Y.^2+Z.^2) <= (radius)^2);
    case 'ellipsoid'
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        scatteringObject = double(((X/shift).^2+(Y/r2rad).^2+Z.^2) <= (radius)^2);
%         scatteringObject = scatteringObject.*((X/shift)<=(radius*0.5));
%         scatteringObject = scatteringObject.*(-(X/shift)-(Z/r2rad)<=(radius*0.5));
        
    case 'core-shell'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        scatteringObject1 = double((Y.^2+X.^2+Z.^2) <= radius^2);
        scatteringObject2 = double((Y.^2+(X-shift*radius*(1-r2rad)).^2+Z.^2) <= (radius*r2rad)^2);
        scatteringObject = scatteringObject1 + core*scatteringObject2;
    case 'debris'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        
        for x=-N/2+1:5:N/2
            for y=-N/2+1:5:N/2
                for z=-N/2+1:5:N/2
                    if (x^2+z^2+y^2) <= (radius)^2
                        scatteringObject(x+N/2,y+N/2,z+N/2)=floor(rand(1)*2);
                    end
%                     if (x^2+z^2+(y+radius*(1-r2rad))^2) <= (radius*r2rad*shift)^2
%                         scatteringObject(x+N/2,y+N/2,z+N/2)=1;
%                     end
                end
            end
        end
    case 'polygon'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        
        [X Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);
        for h=-round(N/2*r2rad):round(N/2*r2rad)
            vertices = [0 1 h; cos(pi/6) sin(pi/6) h; cos(pi/6) -sin(pi/6) h; 0 -1 h; -cos(pi/6) -sin(pi/6) h; -cos(pi/6) sin(pi/6) h; 0 1 h];
            vertices = vertices*(1-shift*abs(h))*radius;
            scatteringObject(:,:,h+N/2)=double(inpolygon(X,Y,vertices(:,1),vertices(:,2)));
        end
        
        %melting
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        melt1 = double((X.^2+Y.^2+Z.^2) <= (radius*core)^2);
        melt2 = double((X.^2+Y.^2+Z.^2) > (radius*core)^2);
        if core < 1
            fac = -log(10^-2)/(radius-radius*core);
        else
            fac = 1;
        end
        melt3 = exp(-fac*(sqrt(X.^2+Y.^2+Z.^2)-radius*core));
        meltMask = melt1 + melt2.*melt3;
        scatteringObject = scatteringObject.*meltMask;
    case 'holo'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');

        scatteringObject1 = zeros(N,N,N);
        [X Y] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2);        
        for h=-round(N/2*r2rad/3):round(N/2*r2rad/3)
            vertices = [0 1 h; cos(pi/6) sin(pi/6) h; cos(pi/6) -sin(pi/6) h; 0 -1 h; -cos(pi/6) -sin(pi/6) h; -cos(pi/6) sin(pi/6) h; 0 1 h];
            vertices = vertices*(1-0.02*abs(h))*radius;
            vertices = vertices*r2rad;
            scatteringObject1(:,:,h+N/2)=double(inpolygon(X-radius*(1-r2rad),Y,vertices(:,1),vertices(:,2)));
        end
        clear X Y;
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        scatteringObject2 = double(((Y+radius*(1-r2rad)).^2+(X+radius*(1-r2rad)).^2+Z.^2) <= (radius*r2rad*shift)^2);
        scatteringObject = scatteringObject1 + core*scatteringObject2;
    case 'three spheres'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        center1 = [-0.5 -0.5 -0.5]*radius*(1-r2rad)*2;
        center2 = [0.5 -0.5 -0.5]*radius*(1-r2rad)*2;
        center3 = [0 0.866-0.5 -0.5]*radius*(1-r2rad)*2;
        sphere1 = double(((Y-center1(2)).^2+(X-center1(1)).^2+(Z-center1(3)).^2) <= (radius*r2rad*(1-shift))^2);
        sphere2 = double(((Y-center2(2)).^2+(X-center2(1)).^2+(Z-center2(3)).^2) <= (radius*r2rad*(1-shift))^2);
        sphere3 = double(((Y-center3(2)).^2+(X-center3(1)).^2+(Z-center3(3)).^2) <= (radius*r2rad*(1-shift))^2);
        scatteringObject = double(sphere1 + sphere2 + sphere3 >0);
    case 'tetraeder spheres'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        center1 = [-0.5 -0.5 -0.5]*radius*(1-r2rad)*2;
        center2 = [0.5 -0.5 -0.5]*radius*(1-r2rad)*2;
        center3 = [0 0.866-0.5 -0.5]*radius*(1-r2rad)*2;
        center4 = [0 0.289-0.5 0.817-0.5]*radius*(1-r2rad)*2;
        sphere1 = double(((Y-center1(2)).^2+(X-center1(1)).^2+(Z-center1(3)).^2) <= (radius*r2rad*(1-shift))^2);
        sphere2 = double(((Y-center2(2)).^2+(X-center2(1)).^2+(Z-center2(3)).^2) <= (radius*r2rad*(1-shift))^2);
        sphere3 = double(((Y-center3(2)).^2+(X-center3(1)).^2+(Z-center3(3)).^2) <= (radius*r2rad*(1-shift))^2);
        sphere4 = double(((Y-center4(2)).^2+(X-center4(1)).^2+(Z-center4(3)).^2) <= (radius*r2rad*(1-shift))^2);
        scatteringObject = double(sphere1 + sphere2 + sphere3 + sphere4>0);
    case 'tetraeder'
        set(handles.r2rad_slider,'Enable','on');
        set(handles.shift_slider,'Enable','on');
        %         [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        v1 = [-0.5 -0.5 -0.5]*radius;
        v2 = [0.5 -0.5 -0.5]*radius;
        v3 = [0 0.866-0.5 -0.5]*radius;
        v4 = [0 0.289-0.5 0.817-0.5]*radius;
        
        for x=-N/2+1:N/2
            for y=-N/2+1:N/2
                for z=-N/2+1:N/2
                    if PointInTetrahedron(v1, v2, v3, v4, [x y z])
                        scatteringObject(x+N/2,y+N/2,z+N/2)=1;
                    end
                end
            end
        end
        
                [X Y Z] = meshgrid(-N/2+1:1:N/2,-N/2+1:1:N/2,-N/2+1:1:N/2);
        meltmask = double((Y.^2+X.^2+Z.^2) <= (radius*r2rad*shift)^2);
        scatteringObject = scatteringObject.*meltmask;
end
