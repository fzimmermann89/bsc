function varargout = gui_simulator(varargin)
% Main Gui for Multislice Scattering Simulator
%      gui_simulator(), by itself, creates a new Gui or raises the existing
%      singleton returning the handle.

% Last Modified by GUIDE v2.5 02-Feb-2016 20:12:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_simulator_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_simulator_OutputFcn, ...
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

% --- Executes just before gui_simulator is made visible.
function gui_simulator_OpeningFcn(hObject, eventdata, handles, varargin)
gpu=true; %TODO

% Choose default command line output for gui_simulator
handles.output = [];
%Create additional GUI Elements (non-GUIDE)
    %Setting Explorer
    
    %get all posible scatter Objects
    scatterNamespace=what('ScatterObjects');
    creatableObjects=scatterNamespace.classes;
    objects={scatterObjects.sphere(256,gpu)}; %Objects present on Startup

    %create List of Settings
    settings.Detektor.distance=setting(10,0,1e5,'mm');
    settings.Detektor.maxK=setting(1,0,100,'1/nm');
    settings.Simulation.N=setting(256,64,2048,'');
    settings.Simulation.sceneDimension=setting(100,1,1000,'nm');
    settings.Source.Wavelength=setting(1,0.5,100,'nm');

    handles.settings=object_explorer(handles.panelTree,handles.tableSettings,objects,settings,creatableObjects);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_simulator wait for user response (see UIRESUME)
uiwait(hObject);
end



% --- Executes on button press in btnCalc.
function btnCalc_Callback(hObject, eventdata, handles)
% hObject    handle to btnCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes when user attempts to close gui_simulator.
function gui_simulator_CloseRequestFcn(hObject, eventdata, handles)
uiresume()
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_simulator_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
delete(hObject)
end
