function varargout = viewer(varargin)
    % viewer MATLAB code for viewer.fig
    % Explorer for beta, delta, radius multirun data
    
    % Last Modified by GUIDE v2.5 14-Aug-2016 20:19:43
    
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
        handles.data=load(path,'N','wavelength','dx','dz','beta','delta','radius','profile_x','profile_y','profile_mie','profile_error_abs','profile_error_rel');
        
        if all(handles.data.beta==handles.data.delta)
            handles.link_betadelta=true;
            handles.btn_link.String='=';
        else
            handles.link_betadelta=false;
            handles.btn_link.String='';
        end
        
        handles.uN=unique(handles.data.N); handles.list_N.String=cellstr(num2str(handles.uN','%d'));
        handles.uwavelength=unique(handles.data.wavelength); handles.list_wavelength.String=cellstr(num2str(handles.uwavelength','%0.2f nm'));
        handles.udx=unique(handles.data.dx); handles.list_dx.String=cellstr(num2str(handles.udx','%.5g'));
        handles.udz=unique(handles.data.dz); handles.list_dz.String=cellstr(num2str(handles.udz','%.5g'));
        handles.ubeta=unique(handles.data.beta); handles.list_beta.String=cellstr(num2str(handles.ubeta','%.2e'));
        handles.udelta=unique(handles.data.delta); handles.list_delta.String=cellstr(num2str(handles.udelta','%.2e'));
        handles.uradius=unique(handles.data.radius); handles.list_radius.String=cellstr(num2str(handles.uradius','%.2f nm'));
        
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
    
    id=find((handles.data.N==N)&(handles.data.wavelength==wavelength)&(handles.data.dx==dx)&(handles.data.dz==dz)&(handles.data.beta==beta)&(handles.data.delta==delta)&(handles.data.radius==radius));
    if numel(id)==1
        x=handles.data.profile_x(:,id);
        labels={};
        if handles.rb_profile.Value
            hold on;
            valmie=handles.data.profile_mie(:,id);
            plot(handles.axes,x,valmie,'-');
            labels{end+1}='mie';
            y=handles.data.profile_y(id);
        elseif handles.rb_abserr.Value
            y=handles.data.profile_error_abs(id);
        else
            y=handles.data.profile_error_rel(id);
        end
        if handles.cb_msft.Value;
            plot(handles.axes,x,y.msft,'x');
            hold on;
            labels{end+1}='msft';
        end
        
        if handles.cb_thibault.Value;
            plot(handles.axes,x,y.thibault,'x');
            hold on;
            labels{end+1}='thibault';
        end
        
        if handles.cb_multislice.Value;
            plot(handles.axes,x,y.multislice,'x');
            hold on;
            labels{end+1}='multislice';
        end
        
        if handles.cb_FTproj.Value;
            plot(handles.axes,x,y.FTproj,'x');
            hold on;
            labels{end+1}='ft proj';
        end
        
        hold off;
        if handles.rb_profile.Value || handles.rb_abserr.Value
            %plot profiles, log scale
            handles.axes.YScale='log';
        else
            handles.axes.YScale='linear';
        end
        
        hold off;
        axis(handles.axes,'auto')
        handles.axes.XLim=[0 min(20,max(x))];
        if ~isempty(labels); legend(handles.axes,labels); end
        drawnow;
        
    end
end

function x=normalize(x)
    x=x./sum(abs(x(2:end/2)));
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
    if exist('handles.data','var');
        draw(handles);
    end
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
    if strcmp(handles.btn_link.String,'=')
        handles.list_delta.Value=  handles.list_beta.Value;
    end
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
    if strcmp(handles.btn_link.String,'=')
        handles.list_beta.Value=  handles.list_delta.Value;
    end
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


% --- Executes on button press in btn_link.
function btn_link_Callback(hObject, eventdata, handles)
    if strcmp(handles.btn_link.String,'=')
       handles.btn_link.String='';
    else
        handles.btn_link.String='=';
        handles.list_delta.Value=handles.list_beta.Value;
    end
end