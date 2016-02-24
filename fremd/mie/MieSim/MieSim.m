function varargout = MieSim(varargin)
% MIESIM MATLAB code for MieSim.fig
%      MIESIM, by itself, creates a new MIESIM or raises the existing
%      singleton*.
%
%      H = MIESIM returns the handle to a new MIESIM or the handle to
%      the existing singleton*.
%
%      MIESIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIESIM.M with the given input arguments.
%
%      MIESIM('Property','Value',...) creates a new MIESIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MieSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MieSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MieSim

% Last Modified by GUIDE v2.5 20-Jan-2016 10:46:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MieSim_OpeningFcn, ...
                   'gui_OutputFcn',  @MieSim_OutputFcn, ...
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


% --- Executes just before MieSim is made visible.
function MieSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MieSim (see VARARGIN)

% Choose default command line output for MieSim
handles.output = hObject;

% add scripts for Mie simulation
addpath('scripts');

% load measured profile
load('MieSim_MeasuredProfile.mat');

% Create structure to store current values for Mie simulation
MieData = struct('lambda', {57.7}, 'radius', {520}, 'nprime', {1.09}, 'n2prime', {1.0}, 'mieprofile', {NaN}, 'mieangle', {NaN}, 'radprof', {RadProf}, 'scatangle', {ScatAngle}, 'npoints', {500}, 'scaling', {1.3});
handles.MieData = MieData;
handles.nprimeTxt.String = ['n'' = ' sprintf('%.2f',handles.MieData.nprime)];
handles.nprimeSld.Value = handles.MieData.nprime;
handles.n2primeTxt.String = ['n'''' = ' sprintf('%.2f',handles.MieData.n2prime)];
handles.n2primeSld.Value = handles.MieData.n2prime;
handles.RadiusTxt.String = ['R = ' sprintf('%.0f',handles.MieData.radius) ' nm'];
handles.RadiusSld.Value = handles.MieData.radius;
handles.nPointsEdit.String = num2str(handles.MieData.npoints);
handles.ScalingEdit.String = num2str(handles.MieData.scaling);
handles.LambdaEdit.String = num2str(handles.MieData.lambda);
PlotProfiles(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MieSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = MieSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function PlotProfiles(hObject, handles)

handles.StatusTxt.String = 'calculating...';
pause(0.001);
disp(['Simulating Mie profile: ' num2str(handles.MieData.nprime) ' ' num2str(handles.MieData.n2prime) ' ' num2str(handles.MieData.lambda) ' ' num2str(handles.MieData.radius)]);
tic
[handles.MieData.mieangle, handles.MieData.mieprofile] = SimulateMieProfile(handles.MieData.nprime,handles.MieData.n2prime,handles.MieData.lambda,handles.MieData.radius,handles.MieData.npoints);
semilogy(handles.MieData.mieangle, handles.MieData.mieprofile*handles.MieData.scaling, '-k', 'LineWidth', 1.5, 'Parent', handles.PlotAxes);
axes(handles.PlotAxes);
xlim([0 40]); 
ylim([0.001 1000]);
hold off;
toc
handles.StatusTxt.String = '';


function LambdaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to LambdaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LambdaEdit as text
%        str2double(get(hObject,'String')) returns contents of LambdaEdit as a double

        handles.MieData.lambda = str2double(handles.LambdaEdit.String);
%         disp(handles.LambdaEdit.String);
%         disp(num2str(handles.MieData.lambda));
        % Update handles structure
        guidata(hObject, handles);
        PlotProfiles(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LambdaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LambdaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end



function RadiusEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RadiusEdit as text
%        str2double(get(hObject,'String')) returns contents of RadiusEdit as a double


% --- Executes during object creation, after setting all properties.
function RadiusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function nprimeSld_Callback(hObject, eventdata, handles)
% hObject    handle to nprimeSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

SliderValue = handles.nprimeSld.Value;
handles.MieData.nprime = round(SliderValue,2);
% Update handles structure
guidata(hObject, handles);
handles.nprimeTxt.String = ['n'' = ' sprintf('%.2f',SliderValue)];
PlotProfiles(hObject, handles);


% --- Executes during object creation, after setting all properties.
function nprimeSld_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nprimeSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function n2primeSld_Callback(hObject, eventdata, handles)
% hObject    handle to n2primeSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

SliderValue = handles.n2primeSld.Value;
handles.MieData.n2prime = round(SliderValue,2);
% Update handles structure
guidata(hObject, handles);
handles.n2primeTxt.String = ['n'''' = ' sprintf('%.2f',SliderValue)];
PlotProfiles(hObject, handles);



% --- Executes during object creation, after setting all properties.
function n2primeSld_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n2primeSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key press with focus on LambdaEdit and none of its controls.
function LambdaEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to LambdaEdit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'return'
        handles.MieData.lambda = str2double(handles.LambdaEdit.String);
%         disp(handles.LambdaEdit.String);
%         disp(num2str(handles.MieData.lambda));
        % Update handles structure
%         guidata(hObject, handles);
%         PlotProfiles(hObject, handles);
%     case 'rightarrow'
%         ForthBtn_Callback(hObject, eventdata, handles);
%     case 'p'
%         PlotBtn_Callback(hObject, eventdata, handles);
end


% --- Executes on slider movement.
function RadiusSld_Callback(hObject, eventdata, handles)
% hObject    handle to RadiusSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SliderValue = handles.RadiusSld.Value;
handles.MieData.radius = round(SliderValue,0);
% Update handles structure
guidata(hObject, handles);
handles.RadiusTxt.String = ['R = ' sprintf('%.0f',SliderValue) ' nm'];
PlotProfiles(hObject, handles);


% --- Executes during object creation, after setting all properties.
function RadiusSld_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RadiusSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in SetBtn.
function SetBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SetBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function nPointsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to nPointsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nPointsEdit as text
%        str2double(get(hObject,'String')) returns contents of nPointsEdit as a double

        handles.MieData.npoints = str2double(handles.nPointsEdit.String);
        % Update handles structure
        guidata(hObject, handles);
        PlotProfiles(hObject, handles);


% --- Executes during object creation, after setting all properties.
function nPointsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nPointsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on nPointsEdit and none of its controls.
function nPointsEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to nPointsEdit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'return'
        handles.MieData.npoints = str2double(handles.nPointsEdit.String);
end



function ScalingEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ScalingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScalingEdit as text
%        str2double(get(hObject,'String')) returns contents of ScalingEdit as a double
        handles.MieData.scaling = str2double(handles.ScalingEdit.String);
        % Update handles structure
        guidata(hObject, handles);
        PlotProfiles(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ScalingEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScalingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on ScalingEdit and none of its controls.
function ScalingEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ScalingEdit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'return'
        handles.MieData.scaling = str2double(handles.ScalingEdit.String);
end


% --- Executes during object creation, after setting all properties.
function rad_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rad_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function n1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function n2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rad_edit_Callback(hObject, eventdata, handles)
set(handles.RadiusSld,'Value',str2double(get(handles.rad_edit,'String')));
SliderValue = handles.RadiusSld.Value;
handles.MieData.radius = round(SliderValue,0);
% Update handles structure
guidata(hObject, handles);
handles.RadiusTxt.String = ['R = ' sprintf('%.0f',SliderValue) ' nm'];
PlotProfiles(hObject, handles);
guidata(hObject, handles);guidata(hObject, handles);

function n1_edit_Callback(hObject, eventdata, handles)
set(handles.nprimeSld,'Value',str2double(get(handles.n1_edit,'String')));
SliderValue = handles.nprimeSld.Value;
handles.MieData.nprime = round(SliderValue,2);
handles.nprimeTxt.String = ['n'' = ' sprintf('%.2f',SliderValue)];
PlotProfiles(hObject, handles);
guidata(hObject, handles);

function n2_edit_Callback(hObject, eventdata, handles)
set(handles.n2primeSld,'Value',str2double(get(handles.n2_edit,'String')));
SliderValue = handles.n2primeSld.Value;
handles.MieData.n2prime = round(SliderValue,2);
handles.n2primeTxt.String = ['n'' = ' sprintf('%.2f',SliderValue)];
PlotProfiles(hObject, handles);
guidata(hObject, handles);