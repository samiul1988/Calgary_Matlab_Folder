function varargout = guiPractice2(varargin)
% GUIPRACTICE2 MATLAB code for guiPractice2.fig
%      GUIPRACTICE2, by itself, creates a new GUIPRACTICE2 or raises the existing
%      singleton*.
%
%      H = GUIPRACTICE2 returns the handle to a new GUIPRACTICE2 or the handle to
%      the existing singleton*.
%
%      GUIPRACTICE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIPRACTICE2.M with the given input arguments.
%
%      GUIPRACTICE2('Property','Value',...) creates a new GUIPRACTICE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiPractice2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiPractice2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiPractice2

% Last Modified by GUIDE v2.5 09-Feb-2013 21:54:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiPractice2_OpeningFcn, ...
                   'gui_OutputFcn',  @guiPractice2_OutputFcn, ...
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


% --- Executes just before guiPractice2 is made visible.
function guiPractice2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiPractice2 (see VARARGIN)

% Choose default command line output for guiPractice2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles
% UIWAIT makes guiPractice2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiPractice2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbEnable.
function pbEnable_Callback(hObject, eventdata, handles)
% hObject    handle to pbEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu1,'Enable','on')
set(handles.checkbox1,'Enable','on')
% --- Executes on button press in pbDisable.
function pbDisable_Callback(hObject, eventdata, handles)
% hObject    handle to pbDisable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu1,'Enable','off')
set(handles.checkbox1,'Enable','off')

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes when selected object is changed in pButton.
function pButton_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pButton 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
val=get(handles.rbEnable, 'Value');
if val
    set(handles.popupmenu1,'Enable','on');
    set(handles.checkbox1,'Enable','on');
else 
    set(handles.popupmenu1,'Enable','off')
    set(handles.checkbox1,'Enable','off')
end



