function varargout = Insect_Lidar_manual_insect_finder_step3(varargin)
% INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3 MATLAB code for Insect_Lidar_manual_insect_finder_step3.fig
%      INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3, by itself, creates a new INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3 or raises the existing
%      singleton*.
%
%      H = INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3 returns the handle to a new INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3 or the handle to
%      the existing singleton*.
%
%      INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3.M with the given input arguments.
%
%      INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3('Property','Value',...) creates a new INSECT_LIDAR_MANUAL_INSECT_FINDER_STEP3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Insect_Lidar_manual_insect_finder_step3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Insect_Lidar_manual_insect_finder_step3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Insect_Lidar_manual_insect_finder_step3

% Last Modified by GUIDE v2.5 06-Dec-2016 09:08:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Insect_Lidar_manual_insect_finder_step3_OpeningFcn, ...
                   'gui_OutputFcn',  @Insect_Lidar_manual_insect_finder_step3_OutputFcn, ...
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


% --- Executes just before Insect_Lidar_manual_insect_finder_step3 is made visible.
function Insect_Lidar_manual_insect_finder_step3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Insect_Lidar_manual_insect_finder_step3 (see VARARGIN)

% Choose default command line output for Insect_Lidar_manual_insect_finder_step3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Insect_Lidar_manual_insect_finder_step3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Insect_Lidar_manual_insect_finder_step3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function time_th_Callback(hObject, eventdata, handles)
% hObject    handle to time_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function time_th_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function freq_th_Callback(hObject, eventdata, handles)
% hObject    handle to freq_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function freq_th_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in multi_insects.
function multi_insects_Callback(hObject, eventdata, handles)
% hObject    handle to multi_insects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function lower_bound_Callback(hObject, eventdata, handles)
% hObject    handle to lower_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lower_bound as text
%        str2double(get(hObject,'String')) returns contents of lower_bound as a double


% --- Executes during object creation, after setting all properties.
function lower_bound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in advance.
function advance_Callback(hObject, eventdata, handles)
% hObject    handle to advance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in very_unlikely.
function very_unlikely_Callback(hObject, eventdata, handles)
% hObject    handle to very_unlikely (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sw_unlikely.
function sw_unlikely_Callback(hObject, eventdata, handles)
% hObject    handle to sw_unlikely (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sw_likely.
function sw_likely_Callback(hObject, eventdata, handles)
% hObject    handle to sw_likely (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in very_likely.
function very_likely_Callback(hObject, eventdata, handles)
% hObject    handle to very_likely (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
