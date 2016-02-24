function varargout = simple_gui(varargin)
% SIMPLE_GUI MATLAB code for simple_gui.fig
%      SIMPLE_GUI, by itself, creates a new SIMPLE_GUI or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI returns the handle to a new SIMPLE_GUI or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI.M with the given input arguments.
%
%      SIMPLE_GUI('Property','Value',...) creates a new SIMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simple_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple_gui

% Last Modified by GUIDE v2.5 15-Feb-2016 14:42:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_gui_OutputFcn, ...
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


% --- Executes just before simple_gui is made visible.
function simple_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_gui (see VARARGIN)

% Choose default command line output for simple_gui
handles.output = hObject;
handles.shape = 3;
handles.directoryName = 'snapshots/';

[y,Fs]=audioread('scatman_short.mp3');
sound(y,Fs); 


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function input_longAxis_Callback(hObject, eventdata, handles)
% hObject    handle to input_longAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_longAxis as text
%        str2double(get(hObject,'String')) returns contents of input_longAxis as a double

fftResolutionInstant = str2double(get(handles.input_fftResolution_instant,'String'));
densResolutionInstant = str2double(get(handles.input_densResolution_instant,'String'));
fftResolution = str2double(get(handles.input_fftResolution,'String'));
densResolution = str2double(get(handles.input_densResolution,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
dGridInstant = longAxis/densResolutionInstant;
dqInstant = 2*pi/(fftResolutionInstant*dGridInstant);
dGrid = longAxis/densResolution;
dq = 2*pi/(fftResolution*dGrid);
k = 2*pi/lambda;
set(handles.text_qmaxInstant,'String',sprintf('%.2g',fftResolutionInstant/2*dqInstant/k));
set(handles.text_dqInstant,'String',sprintf('%.1g',dqInstant/k));
set(handles.text_qmax,'String',sprintf('%.2g',fftResolution/2*dq/k));
set(handles.text_dq,'String',sprintf('%.1g',dq/k));

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_longAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_longAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function input_rotateX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_rotateX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_shortAxis_Callback(hObject, eventdata, handles)
% hObject    handle to input_shortAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_shortAxis as text
%        str2double(get(hObject,'String')) returns contents of input_shortAxis as a double

shortAxis = str2double(get(handles.input_shortAxis,'String'));

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_shortAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_shortAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_rotateY_Callback(hObject, eventdata, handles)
% hObject    handle to input_rotateY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_rotateY as text
%        str2double(get(hObject,'String')) returns contents of input_rotateY as a double

alphaY = str2double(get(handles.input_rotateY,'String'));
set(handles.slider_rotateY,'Value',alphaY);
guidata(hObject,handles)

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function input_rotateY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_rotateY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_rotateZ_Callback(hObject, eventdata, handles)
% hObject    handle to input_rotateZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_rotateZ as text
%        str2double(get(hObject,'String')) returns contents of input_rotateZ as a double

alphaZ = str2double(get(handles.input_rotateZ,'String'));
set(handles.slider_rotateZ,'Value',alphaZ);
guidata(hObject,handles)
if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function input_rotateZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_rotateZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to input_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_wavelength as text
%        str2double(get(hObject,'String')) returns contents of input_wavelength as a double

fftResolutionInstant = str2double(get(handles.input_fftResolution_instant,'String'));
densResolutionInstant = str2double(get(handles.input_densResolution_instant,'String'));
fftResolution = str2double(get(handles.input_fftResolution,'String'));
densResolution = str2double(get(handles.input_densResolution,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
dGridInstant = longAxis/densResolutionInstant;
dqInstant = 2*pi/(fftResolutionInstant*dGridInstant);
dGrid = longAxis/densResolution;
dq = 2*pi/(fftResolution*dGrid);
k = 2*pi/lambda;
set(handles.text_qmaxInstant,'String',sprintf('%.2g',fftResolutionInstant/2*dqInstant/k));
set(handles.text_dqInstant,'String',sprintf('%.1g',dqInstant/k));
set(handles.text_qmax,'String',sprintf('%.2g',fftResolution/2*dq/k));
set(handles.text_dq,'String',sprintf('%.1g',dq/k));

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function input_wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in button_scatt.
function button_scatt_Callback(hObject, eventdata, handles)
% hObject    handle to button_scatt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lambda = str2double(get(handles.input_wavelength,'String'));
absorptionLength = str2double(get(handles.input_absorptionLength,'String'));
fftResolution = str2double(get(handles.input_fftResolution,'String'));
k=2*pi/lambda;

plot_dens(hObject,handles);

[handles.intDetFFT,handles.qxFFT,handles.qyFFT] = fft_fast(handles.dens,handles.gridX,handles.gridY,lambda,fftResolution);
plot_fft(hObject,handles);
[handles.intDet,handles.qx,handles.qy] = msft_dens(handles.dens,handles.gridX,handles.gridY,handles.gridZ,lambda,absorptionLength,fftResolution,handles.axes_load);
plot_msft(hObject,handles);

guidata(hObject,handles)


% --- Executes on button press in apply_input.
function apply_input_Callback(hObject, eventdata, handles)
% hObject    handle to apply_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alphaZ = str2double(get(handles.input_rotateZ,'String'));
alphaY = str2double(get(handles.input_rotateY,'String'));
shortAxis = str2double(get(handles.input_shortAxis,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
depth = str2double(get(handles.input_depth,'String'));

if (get(handles.input_instant,'Value')==1)
    densResolution = str2double(get(handles.input_densResolution_instant,'String'));
else 
    densResolution = str2double(get(handles.input_densResolution,'String'));
end

if (handles.shape==1)
    [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_ellipsoid(longAxis,shortAxis,alphaZ,alphaY,densResolution);
    plot_ellipsoid(longAxis,shortAxis,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
    else if (handles.shape==3)
        [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_tictac(longAxis,shortAxis,alphaZ,alphaY,densResolution);
        plot_tictac(longAxis,shortAxis,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
        else if (handles.shape==4)
                [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_wheel(longAxis,shortAxis,alphaZ,alphaY,densResolution);
                plot_wheel(longAxis,shortAxis,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
            else if (handles.shape==2)
                [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_sphere(longAxis,densResolution);
                plot_sphere(longAxis,handles.shape_axes,handles.dens_proj_axes);
                else if (handles.shape==5)
                    [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_dumbbell(longAxis,shortAxis,depth,alphaZ,alphaY,densResolution);
                    plot_dumbbell(longAxis,shortAxis,depth,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
                end
            end
        end
    end
end

plot_dens(hObject,handles);

guidata(hObject,handles)



function instant(hObject,eventdata,handles)

depth = str2double(get(handles.input_depth,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
absorptionLength = str2double(get(handles.input_absorptionLength,'String'));

fftResolution = str2double(get(handles.input_fftResolution_instant,'String'));
k = 2*pi/lambda;

alphaZ = str2double(get(handles.input_rotateZ,'String'));
alphaY = str2double(get(handles.input_rotateY,'String'));
shortAxis = str2double(get(handles.input_shortAxis,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
densResolution = str2double(get(handles.input_densResolution_instant,'String'));


if (handles.shape==1)
    [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_ellipsoid(longAxis,shortAxis,alphaZ,alphaY,densResolution);
    plot_ellipsoid(longAxis,shortAxis,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
    else if (handles.shape==3)
        [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_tictac(longAxis,shortAxis,alphaZ,alphaY,densResolution);
        plot_tictac(longAxis,shortAxis,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
        else if (handles.shape==4)
                [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_wheel(longAxis,shortAxis,alphaZ,alphaY,densResolution);
                plot_wheel(longAxis,shortAxis,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
            else if (handles.shape==2)
                [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_sphere(longAxis,densResolution);
                plot_sphere(longAxis,handles.shape_axes,handles.dens_proj_axes);
                else if (handles.shape==5)
                    [handles.dens,handles.gridX,handles.gridY,handles.gridZ] = dens_dumbbell(longAxis,shortAxis,depth,alphaZ,alphaY,densResolution);
                    plot_dumbbell(longAxis,shortAxis,depth,alphaZ,alphaY,handles.shape_axes,handles.dens_proj_axes);
                end
            end
        end
    end
end

plot_dens(hObject,handles);

[handles.intDetFFT,handles.qxFFT,handles.qyFFT] = fft_fast(handles.dens,handles.gridX,handles.gridY,lambda,fftResolution); 
plot_fft(hObject,handles);
[handles.intDet,handles.qx,handles.qy] = msft_dens(handles.dens,handles.gridX,handles.gridY,handles.gridZ,lambda,absorptionLength,fftResolution,handles.axes_load);
plot_msft(hObject,handles);

guidata(hObject,handles)

function plot_circles(hObject,handles)

lambda = str2double(get(handles.input_wavelength,'String'));
k=2*pi/lambda;

theta1 = str2double(get(handles.input_angle1,'String'))*pi/180;
theta2 = str2double(get(handles.input_angle2,'String'))*pi/180;
theta3 = str2double(get(handles.input_angle3,'String'))*pi/180;

if (get(handles.input_instant,'Value')==1)
    qmax = str2double(get(handles.text_qmaxInstant,'String'));
    dq = str2double(get(handles.text_dqInstant,'String'));
else
    qmax = str2double(get(handles.text_qmax,'String'));
    dq = str2double(get(handles.text_dq,'String'));
end

r1 = k*sqrt(1-(1-2*sin(theta1/2)^2)^2);
r2 = k*sqrt(1-(1-2*sin(theta2/2)^2)^2);
r3 = k*sqrt(1-(1-2*sin(theta3/2)^2)^2);

ang=0:0.01:2*pi+0.01; 
qx1=r1*cos(ang);
qy1=r1*sin(ang);
qx2=r2*cos(ang);
qy2=r2*sin(ang);
qx3=r3*cos(ang);
qy3=r3*sin(ang);

axes(handles.axes_circles)
hold on
plot(qx1,qy1,'Color',[1 1 1],'LineWidth',1.5);
plot(qx2,qy2,'Color',[1 1 1],'LineWidth',1.5);
plot(qx3,qy3,'Color',[1 1 1],'LineWidth',1.5);

axes(handles.axes_circles2)
hold on
plot(qx1,qy1,'Color',[1 1 1],'LineWidth',1.5);
plot(qx2,qy2,'Color',[1 1 1],'LineWidth',1.5);
plot(qx3,qy3,'Color',[1 1 1],'LineWidth',1.5);


guidata(hObject,handles)



function plot_msft(hObject,handles)

lambda = str2double(get(handles.input_wavelength,'String'));
k = 2*pi/lambda;

if (get(handles.checkbox_qlim,'Value')==1)
    qlim = str2double(get(handles.input_qlim,'String'));
    qmin = -qlim;
    qmax = qlim;
else
if (max(handles.qx)>k)
    qmin = -k; qmax = k;
else
    qmin = min(handles.qx); qmax = max(handles.qx);
end
end

cmin = str2double(get(handles.input_cmin,'String'));
cmax = str2double(get(handles.input_cmax,'String'));

axes(handles.scatt_axes);
hold off
imagesc(handles.qx,handles.qy,log10(handles.intDet/max(max(handles.intDet))));
col = colormap(jet(256));
col(1,:)=[0 0 0];
colormap(col);
caxis([cmin cmax])
axis square;
axis([qmin qmax qmin qmax])
xlabel('q_x [1/nm]')
ylabel('q_y [1/nm]')
if (get(handles.colorbar_switch,'Value')==1)
colorbar
end

axes(handles.axes_circles)
axis([qmin qmax qmin qmax])
axis off
axis square

axes(handles.axes_circles2)
axis([qmin qmax qmin qmax])
axis off
axis square

if (get(handles.checkbox_circles,'Value')==1)
    plot_circles(hObject,handles);
end


guidata(hObject,handles)




function plot_fft(hObject,handles)

lambda = str2double(get(handles.input_wavelength,'String'));
k = 2*pi/lambda;

if (get(handles.checkbox_qlim,'Value')==1)
    qlim = str2double(get(handles.input_qlim,'String'));

    qmin = -qlim;
    qmax = qlim;
else
if (max(handles.qxFFT)>k)
    qmin = -k; qmax = k;
else
    qmin = min(handles.qxFFT); qmax = max(handles.qxFFT);
end
end

cmin = str2double(get(handles.input_cmin,'String'));
cmax = str2double(get(handles.input_cmax,'String'));

axes(handles.fft_axes);
hold off
imagesc(handles.qxFFT,handles.qyFFT,log10(handles.intDetFFT/max(max(handles.intDetFFT))));
col = colormap(jet(256));
col(1,:)=[0 0 0];
colormap(col);
axis square
caxis([cmin cmax])
xlabel('q_x [1/nm]')
ylabel('q_y [1/nm]')
axis([qmin qmax qmin qmax])
if (get(handles.colorbar_switch,'Value')==1)
colorbar
end

if (get(handles.checkbox_circles,'Value')==1)
    plot_circles(hObject,handles)
end

guidata(hObject,handles)



function plot_dens(hObject,handles)

axes(handles.density_axes);
imagesc(handles.gridX,handles.gridY,sum(handles.dens,3));
col = colormap(jet(256));
col(1,:)=[0 0 0];
colormap(col);
axis square;
axis tight;





% --- Executes on button press in button_sphere.
function button_sphere_Callback(hObject, eventdata, handles)
% hObject    handle to button_sphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_sphere
handles.shape = 2;

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)




% --- Executes on button press in button_wheel.
function button_wheel_Callback(hObject, eventdata, handles)
% hObject    handle to button_wheel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_wheel

handles.shape = 4;

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes on button press in button_dumbbell.
function button_dumbbell_Callback(hObject, eventdata, handles)
% hObject    handle to button_dumbbell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_dumbbell

handles.shape = 5;

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)

% --- Executes on button press in button_tictac.
function button_ellipsoid_Callback(hObject, eventdata, handles)
% hObject    handle to button_tictac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_tictac

handles.shape = 1;

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)



% --- Executes on button press in button_tictac.
function button_tictac_Callback(hObject, eventdata, handles)
% hObject    handle to button_tictac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_tictac

handles.shape = 3;

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)



% --- Executes on slider movement.
function slider_rotateY_Callback(hObject, eventdata, handles)
% hObject    handle to slider_rotateY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

alphaY = get(handles.slider_rotateY,'Value');
alphaY = round(alphaY);
set(handles.slider_rotateY,'Value',alphaY);
set(handles.input_rotateY,'String',alphaY);

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function slider_rotateY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_rotateY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on slider movement.
function slider_rotateZ_Callback(hObject, eventdata, handles)
% hObject    handle to slider_rotateZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

alphaZ = get(handles.slider_rotateZ,'Value');
alphaZ = round(alphaZ);
set(handles.slider_rotateZ,'Value',alphaZ);
set(handles.input_rotateZ,'String',alphaZ);

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function slider_rotateZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_rotateZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function input_fftResolution_Callback(hObject, eventdata, handles)
% hObject    handle to input_fftResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_fftResolution as text
%        str2double(get(hObject,'String')) returns contents of input_fftResolution as a double

fftResolution = str2double(get(handles.input_fftResolution,'String'));
densResolution = str2double(get(handles.input_densResolution,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
dGrid = longAxis/densResolution;
dq = 2*pi/(fftResolution*dGrid);
k = 2*pi/lambda;
set(handles.text_qmax,'String',sprintf('%.2g',fftResolution/2*dq/k));
set(handles.text_dq,'String',sprintf('%.1g',dq/k));

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_fftResolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_fftResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_densResolution_Callback(hObject, eventdata, handles)
% hObject    handle to input_densResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_densResolution as text
%        str2double(get(hObject,'String')) returns contents of input_densResolution as a double

fftResolution = str2double(get(handles.input_fftResolution,'String'));
densResolution = str2double(get(handles.input_densResolution,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
dGrid = longAxis/densResolution;
dq = 2*pi/(fftResolution*dGrid);
k = 2*pi/lambda;
set(handles.text_qmax,'String',sprintf('%.2g',fftResolution/2*dq/k));
set(handles.text_dq,'String',sprintf('%.1g',dq/k));

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function input_densResolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_densResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_fftResolution_instant_Callback(hObject, eventdata, handles)
% hObject    handle to input_fftResolution_instant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_fftResolution_instant as text
%        str2double(get(hObject,'String')) returns contents of input_fftResolution_instant as a double

fftResolution = str2double(get(handles.input_fftResolution_instant,'String'));
densResolution = str2double(get(handles.input_densResolution_instant,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
dGrid = longAxis/densResolution;
dq = 2*pi/(fftResolution*dGrid);
k = 2*pi/lambda;
set(handles.text_qmaxInstant,'String',sprintf('%.2g',fftResolution/2*dq/k));
set(handles.text_dqInstant,'String',sprintf('%.1g',dq/k));

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function input_fftResolution_instant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_fftResolution_instant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_densResolution_instant_Callback(hObject, eventdata, handles)
% hObject    handle to input_densResolution_instant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_densResolution_instant as text
%        str2double(get(hObject,'String')) returns contents of input_densResolution_instant as a double


fftResolution = str2double(get(handles.input_fftResolution_instant,'String'));
densResolution = str2double(get(handles.input_densResolution_instant,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));
dGrid = longAxis/densResolution;
dq = 2*pi/(fftResolution*dGrid);
k = 2*pi/lambda;
set(handles.text_qmaxInstant,'String',sprintf('%.2g',fftResolution/2*dq/k));
set(handles.text_dqInstant,'String',sprintf('%.1g',dq/k));

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_densResolution_instant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_densResolution_instant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in input_instant.
function input_instant_Callback(hObject, eventdata, handles)
% hObject    handle to input_instant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of input_instant

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to input_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_wavelength as text
%        str2double(get(hObject,'String')) returns contents of input_wavelength as a double

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

D = dir(handles.directoryName);
loop = length(D(not([D.isdir])))/5 + 1;
filenameMSFT = [handles.directoryName,sprintf('/%04d',loop),'_msft.png'];
filenameFFT = [handles.directoryName,sprintf('/%04d',loop),'_fft.png'];
filenameObject = [handles.directoryName,sprintf('/%04d',loop),'_object.png'];
filenameDens = [handles.directoryName,sprintf('/%04d',loop),'_dens_proj.png'];
parameterFile = [handles.directoryName,sprintf('/%04d',loop),'_parameter.txt'];


export_fig(handles.scatt_axes,filenameMSFT);
export_fig(handles.fft_axes,filenameFFT);
export_fig(handles.shape_axes,filenameObject);
export_fig(handles.density_axes,filenameDens);

alphaZ = str2double(get(handles.input_rotateZ,'String'));
alphaY = str2double(get(handles.input_rotateY,'String'));
shortAxis = str2double(get(handles.input_shortAxis,'String'));
longAxis = str2double(get(handles.input_longAxis,'String'));
lambda = str2double(get(handles.input_wavelength,'String'));

if (handles.shape==1)
    shape = 'ellipsoid';
    else if (handles.shape==3)
        shape = 'tictac';
        else if (handles.shape==4)
                shape = 'wheel';
            else if (handles.shape==2)
                    shape = 'sphere';
                else if (handles.shape==5)
                    shape = 'dumbbell';
                end
            end
        end
    end
end

fileID = fopen(parameterFile, 'wt');
fprintf(fileID, 'Shape: %s\r\n', shape); 
if (handles.shape==2)
    fprintf(fileID, 'Radius: %snm\r\n', num2str(longAxis)); 
else
    fprintf(fileID, 'Long axis: %snm\r\n', num2str(longAxis)); 
    fprintf(fileID, 'Short axis: %snm\r\n', num2str(shortAxis)); 
    fprintf(fileID, 'Rotation around y: %d°\r\n', alphaY); 
    fprintf(fileID, 'Rotation around z: %d°\r\n', alphaZ); 
end
fprintf(fileID, 'Wavelength: %snm\r\n', num2str(lambda)); 

fclose(fileID); 


% --- Executes during object creation, after setting all properties.
function name_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function name_dir_Callback(hObject, eventdata, handles)
% hObject    handle to name_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_dir as text
%        str2double(get(hObject,'String')) returns contents of name_dir as a double

handles.directoryName = get(handles.name_dir,'String');
guidata(hObject,handles)


% --- Executes on button press in changeDirectory.
function changeDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to changeDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.directoryName = uigetdir('');
set(handles.name_dir,'String',handles.directoryName);

guidata(hObject,handles)



function input_cmin_Callback(hObject, eventdata, handles)
% hObject    handle to input_cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_cmin as text
%        str2double(get(hObject,'String')) returns contents of input_cmin as a double
cmin = str2double(get(handles.input_cmin,'String'));
cmax = str2double(get(handles.input_cmax,'String'));
axes(handles.scatt_axes)
caxis([cmin cmax]);
axes(handles.fft_axes)
caxis([cmin cmax]);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function input_cmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_cmax_Callback(hObject, eventdata, handles)
% hObject    handle to input_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_cmax as text
%        str2double(get(hObject,'String')) returns contents of input_cmax as a double


cmin = str2double(get(handles.input_cmin,'String'));
cmax = str2double(get(handles.input_cmax,'String'));
axes(handles.scatt_axes)
caxis([cmin cmax]);
axes(handles.fft_axes)
caxis([cmin cmax]);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function input_cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in colorbar_switch.
function colorbar_switch_Callback(hObject, eventdata, handles)
% hObject    handle to colorbar_switch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colorbar_switch

if get(handles.colorbar_switch,'Value')==1
    axes(handles.scatt_axes)
    c1 = colorbar;
    pos1 = get(c1,'Position')
    pos2 = get(gca,'Position')
    pos1(2) = pos2(2);
    pos1(1) = pos1(1)+pos1(3);
    set(c1,'Position',pos1);
    axes(handles.fft_axes)
    c2 = colorbar;
    pos1 = get(c2,'Position')
    pos2 = get(gca,'Position')
    pos1(2) = pos2(2);
    pos1(1) = pos1(1)+pos1(3);
    set(c2,'Position',pos1);
else
    axes(handles.scatt_axes)
    colorbar off;
    axes(handles.fft_axes)
    colorbar off;
end
if (get(handles.checkbox_circles,'Value')==1)
   plot_circles(hObject,handles)
end


guidata(hObject,handles)



function input_qlim_Callback(hObject, eventdata, handles)
% hObject    handle to input_qlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_qlim as text
%        str2double(get(hObject,'String')) returns contents of input_qlim as a double

if (get(handles.checkbox_qlim,'Value')==1)

qlim = str2double(get(handles.input_qlim,'String'));
qmin = -qlim;
qmax = qlim;
axes(handles.scatt_axes)
axis([qmin qmax qmin qmax])
axes(handles.fft_axes)
axis([qmin qmax qmin qmax])
axes(handles.axes_circles)
axis([qmin qmax qmin qmax])
axes(handles.axes_circles2)
axis([qmin qmax qmin qmax])

end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_qlim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_qlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_depth_Callback(hObject, eventdata, handles)
% hObject    handle to input_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_depth as text
%        str2double(get(hObject,'String')) returns contents of input_depth as a double
if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function input_absorptionLength_Callback(hObject, eventdata, handles)
% hObject    handle to input_absorptionLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_absorptionLength as text
%        str2double(get(hObject,'String')) returns contents of input_absorptionLength as a double

if (get(handles.input_instant,'Value')==1)
    instant(hObject,eventdata,handles);
end

guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function input_absorptionLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_absorptionLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_circles.
function checkbox_circles_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_circles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_circles

cla(handles.axes_circles)
cla(handles.axes_circles2)

if (get(handles.checkbox_circles,'Value')==1)
    plot_circles(hObject,handles)
end

guidata(hObject,handles)



function input_angle1_Callback(hObject, eventdata, handles)
% hObject    handle to input_angle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_angle1 as text
%        str2double(get(hObject,'String')) returns contents of input_angle1 as a double

if (get(handles.checkbox_circles,'Value')==1)
    cla(handles.axes_circles)
    cla(handles.axes_circles2)
    plot_circles(hObject,handles)
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function input_angle1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_angle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_qlim.
function checkbox_qlim_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_qlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_qlim

if (get(handles.checkbox_qlim,'Value')==1)
    qlim = str2double(get(handles.input_qlim,'String'));
    qmin = -qlim;
    qmax = qlim;
    
    axes(handles.scatt_axes)
    axis([qmin qmax qmin qmax])
    axes(handles.axes_circles)
    axis([qmin qmax qmin qmax])
    axes(handles.fft_axes)
    axis([qmin qmax qmin qmax])
    axes(handles.axes_circles2)
    axis([qmin qmax qmin qmax])
    
else
    lambda = str2double(get(handles.input_wavelength,'String'));
    k=2*pi/lambda;
    if (get(handles.input_instant,'Value')==1)
        qlim = str2double(get(handles.text_qmaxInstant,'String'))*k;
        qmin = -qlim; qmax = qlim;
    else
        qlim = str2double(get(handles.text_qmax,'String'))*k;
        qmin = -qlim; qmax = qlim;
    end
   
    axes(handles.scatt_axes)
    axis([qmin qmax qmin qmax])
    axes(handles.axes_circles)
    axis([qmin qmax qmin qmax])
    axes(handles.fft_axes)
    axis([qmin qmax qmin qmax])
    axes(handles.axes_circles2)
    axis([qmin qmax qmin qmax])
    
end



guidata(hObject,handles)



function input_angle2_Callback(hObject, eventdata, handles)
% hObject    handle to input_angle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_angle2 as text
%        str2double(get(hObject,'String')) returns contents of input_angle2 as a double

    
if (get(handles.checkbox_circles,'Value')==1)
    cla(handles.axes_circles)
    cla(handles.axes_circles2)
    plot_circles(hObject,handles)
end

guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function input_angle2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_angle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_angle3_Callback(hObject, eventdata, handles)
% hObject    handle to input_angle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_angle3 as text
%        str2double(get(hObject,'String')) returns contents of input_angle3 as a double

if (get(handles.checkbox_circles,'Value')==1)
    cla(handles.axes_circles)
    cla(handles.axes_circles2)
    plot_circles(hObject,handles)
end

guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function input_angle3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_angle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
