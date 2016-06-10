function varargout = viewer(varargin)
    % viewer MATLAB code for viewer.fig
    % Explorer for beta, delta, radius multirun data
    
    % Last Modified by GUIDE v2.5 10-Jun-2016 18:07:16
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @viewer_OpeningFcn, ...
        'gui_OutputFcn',  @viewer_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before viewer is made visible.
function viewer_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    if (length(varargin)==1) && ischar(varargin{1}) && (exist(varargin{1}, 'file') == 2)
        
        handles=loaddata(handles,varargin{1});
        draw(handles);
    end
    
    guidata(hObject, handles);
end


function handles=loaddata(handles,path)
    try
        data=load(path);
        handles.N=data.N;
        handles.wavelength=data.wavelength;
        handles.dx=data.dx;
        handles.dz=data.dz;
        handles.beta=data.beta;
        handles.delta=data.delta;
        handles.radius=data.radius;
        handles.x=data.profiles_x;
        handles.y=data.profiles_y;
        handles.mie=data.profile_mie;
        handles.error_abs=data.errors_abs;
        handles.profiles_min=data.profiles_min;
        handles.profiles_max=data.profiles_max;
        handles.profiles_stdev=data.profiles_stdev;
        clear data;
        
        handles.uN=unique(handles.N); handles.list_N.String=cellstr(num2str(handles.uN','%.2e'));
        handles.uwavelength=unique(handles.wavelength); handles.list_wavelength.String=cellstr(num2str(handles.uwavelength','%.2e'));
        handles.udx=unique(handles.dx); handles.list_dx.String=cellstr(num2str(handles.udx','%.2e'));
        handles.udz=unique(handles.dz); handles.list_dz.String=cellstr(num2str(handles.udz','%.2e'));
        handles.ubeta=unique(handles.beta); handles.list_beta.String=cellstr(num2str(handles.ubeta','%.2e'));
        handles.udelta=unique(handles.delta); handles.list_delta.String=cellstr(num2str(handles.udelta','%.2e'));
        handles.uradius=unique(handles.radius); handles.list_radius.String=cellstr(num2str(handles.uradius','%.2e'));
        
       handles.list_N.Value=1;
       handles.list_wavelength.Value=1;
              handles.list_dx.Value=1;
       handles.list_dz.Value=1;
       handles.list_radius.Value=1;
       handles.list_beta.Value=1;
       handles.list_delta.Value=1;

        
        handles.axes.Visible='on';
        handles.p_param.Visible='on';
        handles.p_settings.Visible='on';
    catch
        warning('could not load data')
    end
end


function draw(handles)
    cla(handles.axes);
    N=handles.uN(handles.list_N.Value);
    wavelength=handles.uwavelength(handles.list_wavelength.Value);
    dx=handles.udx(handles.list_dx.Value);
    dz=handles.udz(handles.list_dz.Value);
    beta=handles.ubeta(handles.list_beta.Value);
    delta=handles.udelta(handles.list_delta.Value);
    radius=handles.uradius(handles.list_radius.Value);
    
    id=find((handles.N==N)&(handles.wavelength==wavelength)&(handles.dx==dx)&(handles.dz==dz)&(handles.beta==beta)&(handles.delta==delta)&(handles.radius==radius));
    if numel(id)==1
        x=handles.x(:,id);
        
        labels={};
        if handles.rb_profile.Value
            %plot profiles, needs to plot mie
            y=handles.y(id);
            ipx=(interp1(1:numel(x),x(:),linspace(1,numel(x),4*numel(x))))';
            [~,ipmie,~,~]=mie(1,radius,beta,delta,ipx);
            ipmie=(ipmie./max(ipmie(:)));
            plot(handles.axes,ipx,ipmie);
            hold on;
            labels{end+1}='mie';
            
        elseif handles.rb_abserr.Value
            %plot abs errors
            y=handles.error_abs(id);
        else
            %plot rel errors
            algos = fieldnames(handles.error_abs(id));
            for n = 1:numel(algos)
                cury=handles.y(id).(algos{n});
                curerr=handles.error_abs(id).(algos{n});
                y.(algos{n}) =( curerr./ cury);
            end
            
        end
        
        if handles.cb_msft.Value;
            plot(handles.axes,x,y.msft);
            hold on;
            labels{end+1}='msft';
        end
        
        if handles.cb_thibault.Value;
            plot(handles.axes,x,y.thibault);
            hold on;
            labels{end+1}='thibault';
        end
        
        if handles.cb_multislice.Value;
            plot(handles.axes,x,y.multislice);
            hold on;
            labels{end+1}='multislice';
        end
        
        if handles.cb_FTproj.Value;
            plot(handles.axes,x,y.FTproj);
            hold on;
            labels{end+1}='ft proj';
        end
        
        hold off;
        if handles.rb_profile.Value
            %plot profiles, log scale
            handles.axes.YScale='log';
        else
            handles.axes.YScale='linear';
        end
        
        hold off;
        axis(handles.axes,'auto')
        if ~isempty(labels); legend(handles.axes,labels); end
        drawnow;
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = viewer_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end


% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
    [filename,path]=uigetfile({'*.mat';'*.dat'},'File Selector');
    file=fullfile(path,filename);
    handles=loaddata(handles,file);
    guidata(hObject, handles);
    draw(handles);
end


% --- Executes on button press in rb_profile.
function rb_profile_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in rb_relerr.
function rb_relerr_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in rb_abserr.
function rb_abserr_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_msft.
function cb_msft_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_multislice.
function cb_multislice_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_thibault.
function cb_thibault_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_FTproj.
function cb_FTproj_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on selection change in list_beta.
function list_beta_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_beta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_delta.
function list_delta_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_delta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_radius.
function list_radius_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_radius_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_wavelength.
function list_wavelength_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_wavelength_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_dx.
function list_dx_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_dx_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_dz.
function list_dz_Callback(hObject, eventdata, handles)
    draw(handles);
end

% --- Executes during object creation, after setting all properties.
function list_dz_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_N.
function list_N_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_N_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
