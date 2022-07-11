function varargout = user_cc_gui(varargin)
% USER_CC_GUI MATLAB code for user_cc_gui.fig
%      USER_CC_GUI, by itself, creates a new USER_CC_GUI or raises the existing
%      singleton*.
%
%      H = USER_CC_GUI returns the handle to a new USER_CC_GUI or the handle to
%      the existing singleton*.
%
%      USER_CC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USER_CC_GUI.M with the given input arguments.
%
%      USER_CC_GUI('Property','Value',...) creates a new USER_CC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before user_cc_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to user_cc_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help user_cc_gui

% Last Modified by GUIDE v2.5 29-Apr-2016 16:56:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @user_cc_gui_OpeningFcn, ...
    'gui_OutputFcn',  @user_cc_gui_OutputFcn, ...
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



% --- Executes just before user_cc_gui is made visible.
function user_cc_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to user_cc_gui (see VARARGIN)

IL_dir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08';
start_files=dir(fullfile(IL_dir,'AMK*'));
start_files=start_files([start_files.isdir]);
handles.full_Mdir=[MAML_dir,'\',start_files(7).name];
handles.full_Adir=[ASD_dir,'\',start_files(7).name,'\processed_data\'];
load(fullfile(handles.full_Mdir,'avg_matched_data'));
load(fullfile(handles.full_Adir,'ASD_data'));
handles.ASD_data=ASD_data;
handles.MAML_data=avg_matched_data;
handles.h=1;

Loop_Minutes(hObject,eventdata,handles);

% MAML_dir='R:\MAML\Data';
% ASD_dir='R:\ASD\Data';
% start_files=dir(MAML_dir);
% handle.full_Mdir=[MAML_dir,'\',start_files(3).name];
% handle.full_Adir=[ASD_dir,'\',start_files(3).name,'\processed_data\'];
% load(fullfile(handle.full_Mdir,'matched_data'));
% load(fullfile(handle.full_Adir,'ASD_data'));
% handles.ASD_data=ASD_data;
% handles.MAML_data=matched_data;
% handles.h=1;
% % clear handles.ydata handles.ydepoldata ...
% %     handles.xdata handles.d_num
% handles.ydata=handles.MAML_data(handles.h).copol;
% handles.ydepoldata=handles.MAML_data(handles.h).depol;
% handles.xdata=handles.MAML_data(handles.h).range;
% handles.d_num=handles.MAML_data(handles.h).dnum;
%
% axes(handles.axes1)
% plot(handles.xdata,handles.ydata);
% axes(handles.axes2)
% plot(handles.xdata,handles.ydepoldata);
% ylim([-1 1])
% Choose default command line output for user_cc_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes user_cc_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = user_cc_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in all_liquid.
function all_liquid_Callback(hObject, eventdata, handles)
save_data.ydata = handles.ydata;
save_data.ydepoldata = handles.ydepoldata;
save_data.d_num = handles.d_num;
save_data.range = handles.xdata;

d_str=datestr(handles.d_num,30);
if exist([handles.full_Mdir,'\liquid'],'file')==0
    mkdir(fullfile([handles.full_Mdir,'\liquid']));
save(fullfile([handles.full_Mdir,'\liquid'],['liquid_matches',d_str,num2str(handles.h)]),'-struct','save_data');
else
    save(fullfile([handles.full_Mdir,'\liquid'],['liquid_matches',d_str,num2str(handles.h)]),'-struct','save_data');
end


    
% hObject    handle to all_liquid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in all_ice.
function all_ice_Callback(hObject, eventdata, handles)
save_data.ydata = handles.ydata;
save_data.ydepoldata = handles.ydepoldata;
save_data.d_num = handles.d_num;
save_data.range = handles.xdata;

d_str=datestr(handles.d_num,30);
if exist([handles.full_Mdir,'\ice'],'file')==0
    mkdir(fullfile([handles.full_Mdir,'\ice']));
save(fullfile([handles.full_Mdir,'\ice'],['ice_matches',d_str,num2str(handles.h)]),'-struct','save_data');
else
    save(fullfile([handles.full_Mdir,'\ice'],['ice_matches',d_str,num2str(handles.h)]),'-struct','save_data');
end
% hObject    handle to all_ice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mixed.
function mixed_Callback(hObject, eventdata, handles)
save_data.ydata = handles.ydata;
save_data.ydepoldata = handles.ydepoldata;
save_data.d_num = handles.d_num;
save_data.range = handles.xdata;

d_str=datestr(handles.d_num,30);
if exist([handles.full_Mdir,'\mixed'],'file')==0
    mkdir(fullfile([handles.full_Mdir,'\mixed']));
save(fullfile([handles.full_Mdir,'\mixed'],['mixed_matches',d_str,num2str(handles.h)]),'-struct','save_data');
else
    save(fullfile([handles.full_Mdir,'\mixed'],['mixed_matches',d_str,num2str(handles.h)]),'-struct','save_data');
end

% hObject    handle to mixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
if handles.h<size(handles.MAML_data,2)
    handles.h=handles.h+1;
    % handles.ASD_data=handles.ASD_data;
    % handles.MAML_data=handles.MAML_data;
    % handles.full_Mdir=handles.full_Mdir;
    % handles.full_Adir=handles.full_Adir;
    % handles.output = hObject;
    Loop_Minutes(hObject,eventdata,handles)
else
    disp('all files in this day have been processed')
end
% Update handles structure
%guidata(hObject, handles);
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Loop_Minutes(hObject,eventdata,handles)
% MAML_dir='R:\MAML\Data';
% ASD_dir='R:\ASD\Data';
% start_files=dir(MAML_dir);
% handle.full_Mdir=[MAML_dir,'\',start_files(3).name];
% handle.full_Adir=[ASD_dir,'\',start_files(3).name,'\processed_data\'];
% load(fullfile(handle.full_Mdir,'matched_data'));
% load(fullfile(handle.full_Adir,'ASD_data'));

% clear handles.ydata handles.ydepoldata ...
%     handles.xdata handles.d_num
handles.ydata=handles.MAML_data(handles.h).copol;
handles.ydepoldata=handles.MAML_data(handles.h).depol;
handles.xdata=handles.MAML_data(handles.h).range;
handles.d_num=handles.MAML_data(handles.h).dnum;
handles.h=handles.h;

axes(handles.axes1)
plot(handles.xdata,handles.ydata);
title(datestr(handles.d_num))
xlabel('range (m)')
ylabel('intensity (arb.)')
axes(handles.axes2)
plot(handles.xdata,handles.ydepoldata);
ylim([-1 1])
title(num2str(handles.h))
xlabel('range (m)')
ylabel('intensity (arb.)')

% Choose default command line output for user_cc_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in Date_Selector.
function Date_Selector_Callback(hObject, eventdata, handles)
% hObject    handle to Date_Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Date_Selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Date_Selector


% --- Executes during object creation, after setting all properties.
function Date_Selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Date_Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mostly_liquid.
function mostly_liquid_Callback(hObject, eventdata, handles)
% hObject    handle to mostly_liquid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_data.ydata = handles.ydata;
save_data.ydepoldata = handles.ydepoldata;
save_data.d_num = handles.d_num;
save_data.range = handles.xdata;

d_str=datestr(handles.d_num,30);
if exist([handles.full_Mdir,'\mostly_liquid'],'file')==0
    mkdir(fullfile([handles.full_Mdir,'\mostly_liquid']));
save(fullfile([handles.full_Mdir,'\mostly_liquid'],['mostly_liquid_matches',d_str,num2str(handles.h)]),'-struct','save_data');
else
    save(fullfile([handles.full_Mdir,'\\mostly_liquid'],['mostly_liquid_matches',d_str,num2str(handles.h)]),'-struct','save_data');
end

% --- Executes on button press in mostly_ice.
function mostly_ice_Callback(hObject, eventdata, handles)
% hObject    handle to mostly_ice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_data.ydata = handles.ydata;
save_data.ydepoldata = handles.ydepoldata;
save_data.d_num = handles.d_num;
save_data.range = handles.xdata;

d_str=datestr(handles.d_num,30);
if exist([handles.full_Mdir,'\mostly_ice'],'file')==0
    mkdir(fullfile([handles.full_Mdir,'\mostly_ice']));
save(fullfile([handles.full_Mdir,'\mostly_ice'],['mostly_ice_matches',d_str,num2str(handles.h)]),'-struct','save_data');
else
    save(fullfile([handles.full_Mdir,'\mostly_ice'],['mostly_ice_matches',d_str,num2str(handles.h)]),'-struct','save_data');
end