% Copyright (c) 2015 Anatoli Ulmer <anatoli.ulmer@gmail.com>

function varargout = streuOmat(varargin)
% STREUOMAT M-file for streuOmat.fig
%      STREUOMAT, by itself, creates a new STREUOMAT or raises the existing
%      singleton*.
%
%      H = STREUOMAT returns the handle to a new STREUOMAT or the handle to
%      the existing singleton*.
%
%      STREUOMAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STREUOMAT.M with the given input arguments.
%
%      STREUOMAT('Property','Value',...) creates a new STREUOMAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before streuOmat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to streuOmat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help streuOmat

% Last Modified by GUIDE v2.5 09-Sep-2014 15:55:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @streuOmat_OpeningFcn, ...
    'gui_OutputFcn',  @streuOmat_OutputFcn, ...
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


% --- Executes just before streuOmat is made visible.
function streuOmat_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to streuOmat (see VARARGIN)

% Choose default command line output for streuOmat
handles.output = hObject;
% Update handles structure
addpath(pwd);
guidata(hObject, handles);


% UIWAIT makes streuOmat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = streuOmat_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function r2rad_slider_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
set(handles.r2rad_slider,'Value', round(get(handles.r2rad_slider,'Value')*100)/100);
set(handles.r2rad_edit,'String', get(handles.r2rad_slider,'Value'));
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function radius_slider_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
set(handles.radius_slider,'Value', ceil(get(handles.radius_slider,'Value')));
set(handles.radius_edit,'String', get(handles.radius_slider,'Value'));
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function shift_slider_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
set(handles.shift_edit,'String', get(handles.shift_slider,'Value'));
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function r2rad_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
set(handles.r2rad_edit,'String', round(str2num(get(handles.r2rad_edit,'String'))*100)/100); %#ok<ST2NM>
set(handles.r2rad_slider,'Value', str2num(get(handles.r2rad_edit,'String'))); %#ok<ST2NM>
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function radius_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
set(handles.radius_edit,'String', ceil(str2num(get(handles.radius_edit,'String')))); %#ok<ST2NM>
set(handles.radius_slider,'Value', str2num(get(handles.radius_edit,'String'))); %#ok<ST2NM>
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);

function shift_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
set(handles.shift_edit,'String', ceil(str2num(get(handles.shift_edit,'String'))*100)/100); %#ok<ST2NM>
set(handles.shift_slider,'Value', ceil(str2num(get(handles.shift_edit,'String'))*100)/100); %#ok<ST2NM>
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function msft_button_Callback(hObject, ~, handles)
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
guidata(hObject, handles);
drawnow;
lambda = str2double(get(handles.lambda_edit,'String'));
voxelScale = str2num(get(handles.voxel_edit,'String')); %#ok<ST2NM>
N = str2num(get(handles.N_edit,'String')); %#ok<ST2NM>
fftN = str2num(get(handles.fftN_edit,'String')); %#ok<ST2NM>

% if 1+round(fftN/(3*lambda*voxelScale)) > fftN/2
%     errordlg('Increase number of Voxels or wavelength!','Not enough Voxels');
% erstmal rausgenommen weil nicht klar ob wirklich notwendig
if str2double(get(handles.N_edit,'String')) > str2double(get(handles.fftN_edit,'String'))
    errordlg('fftN must be equal or larger than N!');
else
    handles.scatteringPicture=msft(handles);
    set(streuOmat,'CurrentAxes',handles.axes2);
    factor = 3.14*voxelScale/2; % rounded pi for better appearance
    xScaleValues = -2*factor+4*factor/fftN:4*factor/fftN:2*factor;
    imagesc(xScaleValues,xScaleValues,log(handles.scatteringPicture));
    colormap(fire);
    xlabel('kx in 1/nm');
    ylabel('ky in 1/nm');
    radialDataX = handles.scatteringPicture(fftN/2,:);
    radialDataY = handles.scatteringPicture(:,fftN/2)';
    set(streuOmat,'CurrentAxes',handles.axes3);
    semilogy(xScaleValues,radialDataX,'Color','b');
    hold on;
    semilogy(xScaleValues,radialDataY,'Color','r');
    hold off;
    axis tight;
    if get(handles.save_checkbox, 'Value')
        newFolder = fullfile(pwd, get(handles.save_edit,'String'));
        if ~exist([pwd, get(handles.save_edit,'String')], 'dir')
            mkdir([pwd, get(handles.save_edit,'String')])
        end
        h = figure(1);
        imagesc(xScaleValues,xScaleValues,log(handles.scatteringPicture));
        colormap(hot);
        axis square;
        saveas(h,fullfile(newFolder,['radius-', num2str(get(handles.radius_slider,'Value')), 'nm',...
            '_r2rad-', num2str(get(handles.r2rad_slider,'Value')),...
            '_shift-', num2str(get(handles.shift_slider,'Value')),...
            '_rotX-', get(handles.rotateX_edit,'String'),...
            '_rotY-', get(handles.rotateY_edit,'String'),...
            '_absFac1-', get(handles.absFac1_edit,'String'),...
            '_absFac2-', get(handles.absFac2_edit,'String'),...
            '_refFac1-', get(handles.refFac1_edit,'String'),...
            '_refFac2-', get(handles.refFac2_edit,'String'), '.png']), 'png');
        delete(h);
        dlmwrite(fullfile(newFolder,['radius-', num2str(get(handles.radius_slider,'Value')), 'nm',...
            '_r2rad-', num2str(get(handles.r2rad_slider,'Value')),...
            '_shift-', num2str(get(handles.shift_slider,'Value')),...
            '_rotX-', get(handles.rotateX_edit,'String'),...
            '_rotY-', get(handles.rotateY_edit,'String'),...
            '_absFac1-', get(handles.absFac1_edit,'String'),...
            '_absFac2-', get(handles.absFac2_edit,'String'),...
            '_refFac1-', get(handles.refFac1_edit,'String'),...
            '_refFac2-', get(handles.refFac2_edit,'String'), '.txt']), handles.scatteringPicture,'delimiter','\t');
        dlmwrite(fullfile(newFolder,['radius-', num2str(get(handles.radius_slider,'Value')), 'nm',...
            '_r2rad-', num2str(get(handles.r2rad_slider,'Value')),...
            '_shift-', num2str(get(handles.shift_slider,'Value')),...
            '_rotX-', get(handles.rotateX_edit,'String'),...
            '_rotY-', get(handles.rotateY_edit,'String'),...
            '_absFac1-', get(handles.absFac1_edit,'String'),...
            '_absFac2-', get(handles.absFac2_edit,'String'),...
            '_refFac1-', get(handles.refFac1_edit,'String'),...
            '_refFac2-', get(handles.refFac2_edit,'String'),...
            '_scale.txt']), xScaleValues,'delimiter','\t');
        h = figure(1);
        semilogy(xScaleValues,radialDataX,'Color','b');
        hold on;
        semilogy(xScaleValues,radialDataY,'Color','r');
        hold off;
        axis tight;
        saveas(h,fullfile(newFolder,['radialPlot_radius-', num2str(get(handles.radius_slider,'Value')), 'nm',...
            '_r2rad-', num2str(get(handles.r2rad_slider,'Value')),...
            '_shift-', num2str(get(handles.shift_slider,'Value')),...
            '_rotX-', get(handles.rotateX_edit,'String'),...
            '_rotY-', get(handles.rotateY_edit,'String'),...
            '_absFac1-', get(handles.absFac1_edit,'String'),...
            '_absFac2-', get(handles.absFac2_edit,'String'),...
            '_refFac1-', get(handles.refFac1_edit,'String'),...
            '_refFac2-', get(handles.refFac2_edit,'String'),'.png']), 'png');
        delete(h);
    end
end
set(handles.text8, 'String', 'done!');
set(handles.figure1, 'pointer', 'arrow');
set(handles.radius_edit,'String', get(handles.radius_slider,'Value'));
set(handles.r2rad_edit,'String', get(handles.r2rad_slider,'Value'));
guidata(hObject, handles);


function dimensions_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function opening_checkbox_Callback(~, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');


function rotateX_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function rotateY_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function N_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
N = round(str2num(get(handles.N_edit,'String'))); %#ok<ST2NM>
if mod(N,2) > 0
    set(handles.N_edit,'String',num2str(N+1));
end
%set(handles.radius_slider, 'Max', str2num(get(handles.N_edit,'String'))/2/str2num(get(handles.voxel_edit,'String'))); %#ok<ST2NM>
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function voxel_edit_Callback(~, ~, handles) %#ok<DEFNU>
set(handles.voxel_text,'String',['1 Voxel = ',num2str(1/str2num(get(handles.voxel_edit,'String'))),' nm']); %#ok<ST2NM>
%set(handles.radius_slider, 'Max', str2num(get(handles.N_edit,'String'))/2/str2num(get(handles.voxel_edit,'String'))); %#ok<ST2NM>


function object_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


function lambda_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
msft_button_Callback(hObject,1,handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function r2rad_slider_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to r2rad_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function radius_slider_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to radius_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function r2rad_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to r2rad_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function radius_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function N_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to N_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function lambda_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function msft_button_CreateFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to msft_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function object_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to object_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dimensions_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to dimensions_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function opening_checkbox_CreateFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to opening_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function rotateX_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to rotateX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function r2rad_slider_DeleteFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to r2rad_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function radius_slider_DeleteFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to radius_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function msft_button_DeleteFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to msft_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over msft_button.
function msft_button_ButtonDownFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to msft_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in easterEgg_button.
function easterEgg_button_Callback(~, ~, ~) %#ok<DEFNU>
theRealSimulation();
% hObject    handle to easterEgg_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on msft_button and none of its controls.
function msft_button_KeyPressFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to msft_button (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function rotateY_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to rotateY_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function detDist_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to detDist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detDist_edit as text
%        str2double(get(hObject,'String')) returns contents of detDist_edit as a double


% --- Executes during object creation, after setting all properties.
function detDist_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to detDist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function detDist_edit_DeleteFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to detDist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function shift_slider_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to shift_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object deletion, before destroying properties.
function shift_slider_DeleteFcn(~, ~, ~) %#ok<DEFNU>
% hObject    handle to shift_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function refFac1_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to refFac1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of refFac1_edit as text
%        str2double(get(hObject,'String')) returns contents of refFac1_edit as a double


% --- Executes during object creation, after setting all properties.
function refFac1_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to refFac1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function absFac1_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to absFac1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of absFac1_edit as text
%        str2double(get(hObject,'String')) returns contents of absFac1_edit as a double


% --- Executes during object creation, after setting all properties.
function absFac1_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to absFac1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function refFac2_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to refFac2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of refFac2_edit as text
%        str2double(get(hObject,'String')) returns contents of refFac2_edit as a double


% --- Executes during object creation, after setting all properties.
function refFac2_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to refFac2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function absFac2_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to absFac2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of absFac2_edit as text
%        str2double(get(hObject,'String')) returns contents of absFac2_edit as a double


% --- Executes during object creation, after setting all properties.
function absFac2_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to absFac2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function voxel_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to voxel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in series_button.
function series_button_Callback(hObject, ~, handles) %#ok<DEFNU>
seriesData = get(handles.seriesTable,'Data');
handles.abort=false;
for a = seriesData(1,1):seriesData(1,2):seriesData(1,3)
    for b = seriesData(2,1):seriesData(2,2):seriesData(2,3)
        for c = seriesData(3,1):seriesData(3,2):seriesData(3,3)
            for d = seriesData(4,1):seriesData(4,2):seriesData(4,3)
                for e = seriesData(5,1):seriesData(5,2):seriesData(5,3)
                    for f = seriesData(6,1):seriesData(6,2):seriesData(6,3)
                        for g = seriesData(7,1):seriesData(7,2):seriesData(7,3)
                            for h = seriesData(8,1):seriesData(8,2):seriesData(8,3)
                                for i = seriesData(9,1):seriesData(9,2):seriesData(9,3)
                                    if get(handles.abort_checkbox,'Value')
                                        break
                                    end
                                    set(handles.text8, 'String', 'busy...');
                                    set(handles.figure1, 'pointer', 'watch');
                                    drawnow;
                                    set(handles.radius_slider,'Value',a);
                                    set(handles.radius_edit,'String',num2str(a));
                                    set(handles.r2rad_slider,'Value',b);
                                    set(handles.r2rad_edit,'String',num2str(b));
                                    set(handles.shift_slider,'Value',c);
                                    set(handles.shift_edit,'String',num2str(c));
                                    set(handles.rotateX_edit,'String',num2str(d));
                                    set(handles.rotateY_edit,'String',num2str(e));
                                    set(handles.absFac1_edit,'String',num2str(f));
                                    set(handles.absFac2_edit,'String',num2str(g));
                                    set(handles.refFac1_edit,'String',num2str(h));
%                                     set(handles.refFac2_edit,'String',num
%                                     2str(i));
                                    handles.core=i;
                                    set(handles.core_edit,'String',num2str(i));
                                    drawnow;
                                    handles.current_data = calculateAndDraw(handles);
                                    set(handles.text8, 'String', 'ready');
                                    set(handles.figure1, 'pointer', 'arrow');
                                    msft_button_Callback(hObject, 1, handles);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


function save_checkbox_Callback(~, ~, ~) %#ok<DEFNU>


function abort_checkbox_Callback(~, ~, ~) %#ok<DEFNU>



function save_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to save_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_edit as text
%        str2double(get(hObject,'String')) returns contents of save_edit as a double


% --- Executes during object creation, after setting all properties.
function save_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to save_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function shift_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to shift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fftN_edit_Callback(hObject, eventdata, handles)
msft_button_Callback(hObject,1,handles);


% --- Executes during object creation, after setting all properties.
function fftN_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fftN_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function detSize_edit_Callback(hObject, eventdata, handles)
% hObject    handle to detSize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detSize_edit as text
%        str2double(get(hObject,'String')) returns contents of detSize_edit as a double


% --- Executes during object creation, after setting all properties.
function detSize_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detSize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function core_edit_Callback(hObject, eventdata, handles)
set(handles.text8, 'String', 'busy...');
set(handles.figure1, 'pointer', 'watch');
drawnow;
handles.current_data = calculateAndDraw(handles);
set(handles.text8, 'String', 'ready');
set(handles.figure1, 'pointer', 'arrow');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function core_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to core_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
