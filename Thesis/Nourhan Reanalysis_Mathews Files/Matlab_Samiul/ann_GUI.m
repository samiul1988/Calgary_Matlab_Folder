function [varargout] = ann_GUI(varargin)
% function varargout = ann_GUI(varargin)
% ANN_GUI MATLAB code for ann_GUI.fig
%      ANN_GUI, by itself, creates a new ANN_GUI or raises the existing
%      singleton*.
%
%      H = ANN_GUI returns the handle to a new ANN_GUI or the handle to
%      the existing singleton*.
%
%      ANN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANN_GUI.M with the given input arguments.
%
%      ANN_GUI('Property','Value',...) creates a new ANN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ann_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ann_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ann_GUI

% Last Modified by GUIDE v2.5 10-Feb-2013 00:10:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ann_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ann_GUI_OutputFcn, ...
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


% --- Executes just before ann_GUI is made visible.
function ann_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ann_GUI (see VARARGIN)

% Choose default command line output for ann_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ann_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% handles
global propertyObj
propertyObj.flag = 0;


function initialize_propertyObj()

global propertyObj

propertyObj.inputProcessFcn.inputProcFcn1 = 0;
propertyObj.inputProcessFcn.inputProcFcn2 = 0;
propertyObj.inputProcessFcn.inputProcFcn3 = 1;
propertyObj.inputProcessFcn.inputProcFcn4 = 0;
propertyObj.inputProcessFcn.inputProcFcn5 = 0;
propertyObj.inputProcessFcn.inputProcFcn6 = 1;
propertyObj.inputProcessFcn.inputProcFcn7 = 0;

propertyObj.outputProcessFcn.outputProcFcn1 = 0; 
propertyObj.outputProcessFcn.outputProcFcn2 = 0; 
propertyObj.outputProcessFcn.outputProcFcn3 = 1; 
propertyObj.outputProcessFcn.outputProcFcn4 = 0; 
propertyObj.outputProcessFcn.outputProcFcn5 = 0; 
propertyObj.outputProcessFcn.outputProcFcn6 = 1; 
propertyObj.outputProcessFcn.outputProcFcn7 = 0; 

propertyObj.layerInitFcn = 'initnw';
propertyObj.layerNetInpFcn = 'netprod';
propertyObj.layerTransferFcn = 'tansig';

propertyObj.biasInitFcn = 'none';
propertyObj.biasLearnFcn = 'learngdm';

propertyObj.inpWeightInitFcn = 'none';
propertyObj.inpWeightLearnFcn = 'learngdm';
propertyObj.inpWeightWeightFcn = 'dotprod';

propertyObj.layerWeightInitFcn = 'none';
propertyObj.layerWeightLearnFcn = 'learngdm';
propertyObj.layerWeightWeightFcn = 'dotprod';

propertyObj.divideFcn = 'dividerand';
propertyObj.divideParam.trainRatio = 70;
propertyObj.divideParam.valRatio = 30;
propertyObj.divideParam.testRatio = 0;

propertyObj.epochs = 300;
propertyObj.goal = 0;
propertyObj.max_fail = 300;

% --- Outputs from this function are returned to the command line.
function varargout = ann_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pButtonCancel.
function pButtonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pButtonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global propertyObj
clear 'propertyObj';

propertyObj.flag = 1;
delete(handles.figure1);


% --- Executes on button press in pButtonGetProp.
function pButtonGetProp_Callback(hObject, eventdata, handles)
% hObject    handle to pButtonGetProp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global propertyObj
% Update handles structure
guidata(hObject, handles);
propertyObj.flag = 1;
delete(handles.figure1);



% --- Executes on button press in inputProcFcn1.
function inputProcFcn1_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn1
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn1 = state; 


% --- Executes on button press in inputProcFcn2.
function inputProcFcn2_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn2
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn2 = state; 


% --- Executes on button press in inputProcFcn3.
function inputProcFcn3_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn3
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn3 = state; 

% --- Executes on button press in inputProcFcn4.
function inputProcFcn4_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn4
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn4 = state; 

% --- Executes on button press in inputProcFcn5.
function inputProcFcn5_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn5
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn5 = state; 

% --- Executes on button press in inputProcFcn6.
function inputProcFcn6_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn6
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn6 = state; 

% --- Executes on button press in inputProcFcn7.
function inputProcFcn7_Callback(hObject, eventdata, handles)
% hObject    handle to inputProcFcn7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inputProcFcn7
global propertyObj 
state = get(hObject,'Value');
propertyObj.inputProcessFcn.inputProcFcn7 = state; 


% --- Executes on selection change in pMenuLayerNetInpFcn.
function pMenuLayerNetInpFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuLayerNetInpFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuLayerNetInpFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuLayerNetInpFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerNetInpFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuLayerNetInpFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuLayerNetInpFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerNetInpFcn = contents{get(hObject,'Value')};


% --- Executes on selection change in pMenuLayerInitFcn.
function pMenuLayerInitFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuLayerInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuLayerInitFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuLayerInitFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerInitFcn = contents{get(hObject,'Value')}; 


% --- Executes during object creation, after setting all properties.
function pMenuLayerInitFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuLayerInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerInitFcn = contents{get(hObject,'Value')};


% --- Executes on selection change in pMenuLayerTransferFcn.
function pMenuLayerTransferFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuLayerTransferFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuLayerTransferFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuLayerTransferFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerTransferFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuLayerTransferFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuLayerTransferFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerTransferFcn = contents{get(hObject,'Value')};


% --- Executes on button press in outputProcFcn1.
function outputProcFcn1_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn1
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn1 = state; 

% --- Executes on button press in outputProcFcn2.
function outputProcFcn2_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn2
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn2 = state; 

% --- Executes on button press in outputProcFcn3.
function outputProcFcn3_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn3
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn3 = state; 

% --- Executes on button press in outputProcFcn4.
function outputProcFcn4_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn4
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn4 = state; 

% --- Executes on button press in outputProcFcn5.
function outputProcFcn5_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn5
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn5 = state; 

% --- Executes on button press in outputProcFcn6.
function outputProcFcn6_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn6
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn6 = state; 

% --- Executes on button press in outputProcFcn7.
function outputProcFcn7_Callback(hObject, eventdata, handles)
% hObject    handle to outputProcFcn7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputProcFcn7
global propertyObj 
state = get(hObject,'Value');
propertyObj.outputProcessFcn.outputProcFcn7 = state; 


% --- Executes on selection change in pMenuBiasLearnFcn.
function pMenuBiasLearnFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuBiasLearnFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuBiasLearnFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuBiasLearnFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.biasLearnFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuBiasLearnFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuBiasLearnFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.biasLearnFcn = contents{get(hObject,'Value')};

% % --- Executes on selection change in pMenuBiasTransferFcn.
% function pMenuBiasTransferFcn_Callback(hObject, eventdata, handles)
% % hObject    handle to pMenuBiasTransferFcn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns pMenuBiasTransferFcn contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from pMenuBiasTransferFcn
% global propertyObj
% contents = cellstr(get(hObject,'String')); 
% propertyObj.biasTransferFcn = contents{get(hObject,'Value')};

% % --- Executes during object creation, after setting all properties.
% function pMenuBiasTransferFcn_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to pMenuBiasTransferFcn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% global propertyObj
% contents = cellstr(get(hObject,'String')); 
% propertyObj.biasTransferFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuBiasInitFcn.
function pMenuBiasInitFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuBiasInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuBiasInitFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuBiasInitFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.biasInitFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuBiasInitFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuBiasInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.biasInitFcn = contents{get(hObject,'Value')};


% --- Executes on selection change in pMenuInpWeightInitFcn.
function pMenuInpWeightInitFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuInpWeightInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuInpWeightInitFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuInpWeightInitFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.inpWeightInitFcn = contents{get(hObject,'Value')};


% --- Executes during object creation, after setting all properties.
function pMenuInpWeightInitFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuInpWeightInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.inpWeightInitFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuInpWeightLearnFcn.
function pMenuInpWeightLearnFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuInpWeightLearnFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuInpWeightLearnFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuInpWeightLearnFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.inpWeightLearnFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuInpWeightLearnFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuInpWeightLearnFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.inpWeightLearnFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuInpWeightWeightFcn.
function pMenuInpWeightWeightFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuInpWeightWeightFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuInpWeightWeightFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuInpWeightWeightFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.inpWeightWeightFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuInpWeightWeightFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuInpWeightWeightFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.inpWeightWeightFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuLayerWeightInitFcn.
function pMenuLayerWeightInitFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuLayerWeightInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuLayerWeightInitFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuLayerWeightInitFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerWeightInitFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuLayerWeightInitFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuLayerWeightInitFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerWeightInitFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuLayerWeightLearnFcn.
function pMenuLayerWeightLearnFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuLayerWeightLearnFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuLayerWeightLearnFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuLayerWeightLearnFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerWeightLearnFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuLayerWeightLearnFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuLayerWeightLearnFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerWeightLearnFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuLayerWeightWeightFcn.
function pMenuLayerWeightWeightFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuLayerWeightWeightFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuLayerWeightWeightFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuLayerWeightWeightFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerWeightWeightFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuLayerWeightWeightFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuLayerWeightWeightFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.layerWeightWeightFcn = contents{get(hObject,'Value')};


% --- Executes on selection change in pMenuDivideFcn.
function pMenuDivideFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuDivideFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuDivideFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuDivideFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.divideFcn = contents{get(hObject,'Value')};


% --- Executes during object creation, after setting all properties.
function pMenuDivideFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuDivideFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.divideFcn = contents{get(hObject,'Value')};


% --- Executes on selection change in pMenuNetPerformFcn.
function pMenuNetPerformFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuNetPerformFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuNetPerformFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuNetPerformFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.netPerformFcn = contents{get(hObject,'Value')};


% --- Executes during object creation, after setting all properties.
function pMenuNetPerformFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuNetPerformFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.netPerformFcn = contents{get(hObject,'Value')};

% --- Executes on selection change in pMenuNetTrainFcn.
function pMenuNetTrainFcn_Callback(hObject, eventdata, handles)
% hObject    handle to pMenuNetTrainFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMenuNetTrainFcn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMenuNetTrainFcn
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.netTrainFcn = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function pMenuNetTrainFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMenuNetTrainFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
contents = cellstr(get(hObject,'String')); 
propertyObj.netTrainFcn = contents{get(hObject,'Value')};


function editTextTrainRatio_Callback(hObject, eventdata, handles)
% hObject    handle to editTextTrainRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextTrainRatio as text
%        str2double(get(hObject,'String')) returns contents of editTextTrainRatio as a double
global propertyObj
get(hObject,'String');
propertyObj.divideParam.trainRatio = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editTextTrainRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextTrainRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.divideParam.trainRatio = str2double(get(hObject,'String'));


function editTextValRatio_Callback(hObject, eventdata, handles)
% hObject    handle to editTextValRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextValRatio as text
%        str2double(get(hObject,'String')) returns contents of editTextValRatio as a double
global propertyObj
get(hObject,'String');
propertyObj.divideParam.valRatio = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editTextValRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextValRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.divideParam.valRatio = str2double(get(hObject,'String'));


function editTextTestRatio_Callback(hObject, eventdata, handles)
% hObject    handle to editTextTestRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextTestRatio as text
%        str2double(get(hObject,'String')) returns contents of editTextTestRatio as a double
global propertyObj
get(hObject,'String');
propertyObj.divideParam.testRatio = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editTextTestRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextTestRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.divideParam.testRatio = str2double(get(hObject,'String'));


function editTextTrainInd_Callback(hObject, eventdata, handles)
% hObject    handle to editTextTrainInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextTrainInd as text
%        str2double(get(hObject,'String')) returns contents of editTextTrainInd as a double
global propertyObj
get(hObject,'String');
propertyObj.divideParam.trainInd = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editTextTrainInd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextTrainInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.divideParam.trainInd = str2double(get(hObject,'String'));


function editTextValInd_Callback(hObject, eventdata, handles)
% hObject    handle to editTextValInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextValInd as text
%        str2double(get(hObject,'String')) returns contents of editTextValInd as a double
global propertyObj
get(hObject,'String');
propertyObj.divideParam.valInd = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function editTextValInd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextValInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.divideParam.valInd = str2double(get(hObject,'String'));



function editTextTestInd_Callback(hObject, eventdata, handles)
% hObject    handle to editTextTestInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextTestInd as text
%        str2double(get(hObject,'String')) returns contents of editTextTestInd as a double
global propertyObj
get(hObject,'String');
propertyObj.divideParam.testInd = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function editTextTestInd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextTestInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.divideParam.testInd = str2double(get(hObject,'String'));



function Epochs_Callback(hObject, eventdata, handles)
% hObject    handle to Epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Epochs as text
%        str2double(get(hObject,'String')) returns contents of Epochs as a double
global propertyObj
get(hObject,'String');
propertyObj.epochs = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Epochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.epochs = str2double(get(hObject,'String'));


function Goal_Callback(hObject, eventdata, handles)
% hObject    handle to Goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Goal as text
%        str2double(get(hObject,'String')) returns contents of Goal as a double
global propertyObj
get(hObject,'String');
propertyObj.goal = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global propertyObj
get(hObject,'String');
propertyObj.goal = str2double(get(hObject,'String'));


% --- Executes when selected object is changed in rbPanel.
function rbPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rbPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

val=get(handles.rbDefault, 'Value');
if val
    disable_other_objects(handles);
    initialize_propertyObj();
else 
    enable_objects(handles);
    partial_initialize_propertyObj();
end

function disable_other_objects(handles)

set(handles.inputProcFcn1,'Enable','off');
set(handles.inputProcFcn2,'Enable','off');
set(handles.inputProcFcn3,'Enable','off');
set(handles.inputProcFcn4,'Enable','off');
set(handles.inputProcFcn5,'Enable','off');
set(handles.inputProcFcn6,'Enable','off');
set(handles.inputProcFcn7,'Enable','off');

set(handles.outputProcFcn1,'Enable','off');
set(handles.outputProcFcn2,'Enable','off');
set(handles.outputProcFcn3,'Enable','off');
set(handles.outputProcFcn4,'Enable','off');
set(handles.outputProcFcn5,'Enable','off');
set(handles.outputProcFcn6,'Enable','off');
set(handles.outputProcFcn7,'Enable','off');

set(handles. pMenuLayerInitFcn,'Enable','off');
set(handles. pMenuLayerNetInpFcn,'Enable','off');
set(handles. pMenuLayerTransferFcn,'Enable','off');

set(handles. pMenuBiasInitFcn,'Enable','off');
set(handles. pMenuBiasLearnFcn,'Enable','off');

set(handles. pMenuInpWeightInitFcn,'Enable','off');
set(handles. pMenuInpWeightLearnFcn,'Enable','off');
set(handles. pMenuInpWeightWeightFcn,'Enable','off');

set(handles. pMenuLayerWeightInitFcn,'Enable','off');
set(handles. pMenuLayerWeightLearnFcn,'Enable','off');
set(handles. pMenuLayerWeightWeightFcn,'Enable','off');

set(handles. pMenuDivideFcn,'Enable','off');
set(handles. pMenuNetTrainFcn,'Enable','off');
set(handles. pMenuNetPerformFcn,'Enable','off');

set(handles. editTextTrainRatio,'Enable','off');
set(handles. editTextValRatio,'Enable','off');
set(handles. editTextTestRatio,'Enable','off');

set(handles. editTextTrainInd,'Enable','off');
set(handles. editTextValInd,'Enable','off');
set(handles. editTextTestInd,'Enable','off');

set(handles. Epochs,'Enable','off');
set(handles. Goal,'Enable','off');

function enable_objects(handles)

set(handles.inputProcFcn1,'Enable','on');
set(handles.inputProcFcn2,'Enable','on');
set(handles.inputProcFcn3,'Enable','on');
set(handles.inputProcFcn4,'Enable','on');
set(handles.inputProcFcn5,'Enable','on');
set(handles.inputProcFcn6,'Enable','on');
set(handles.inputProcFcn7,'Enable','on');

set(handles.outputProcFcn1,'Enable','on');
set(handles.outputProcFcn2,'Enable','on');
set(handles.outputProcFcn3,'Enable','on');
set(handles.outputProcFcn4,'Enable','on');
set(handles.outputProcFcn5,'Enable','on');
set(handles.outputProcFcn6,'Enable','on');
set(handles.outputProcFcn7,'Enable','on');

set(handles. pMenuLayerInitFcn,'Enable','on');
set(handles. pMenuLayerNetInpFcn,'Enable','on');
set(handles. pMenuLayerTransferFcn,'Enable','on');

set(handles. pMenuBiasInitFcn,'Enable','on');
set(handles. pMenuBiasLearnFcn,'Enable','on');

set(handles. pMenuInpWeightInitFcn,'Enable','on');
set(handles. pMenuInpWeightLearnFcn,'Enable','on');
set(handles. pMenuInpWeightWeightFcn,'Enable','on');

set(handles. pMenuLayerWeightInitFcn,'Enable','on');
set(handles. pMenuLayerWeightLearnFcn,'Enable','on');
set(handles. pMenuLayerWeightWeightFcn,'Enable','on');

set(handles. pMenuDivideFcn,'Enable','on');
set(handles. pMenuNetTrainFcn,'Enable','on');
set(handles. pMenuNetPerformFcn,'Enable','on');

set(handles. editTextTrainRatio,'Enable','on');
set(handles. editTextValRatio,'Enable','on');
set(handles. editTextTestRatio,'Enable','on');

set(handles. editTextTrainInd,'Enable','on');
set(handles. editTextValInd,'Enable','on');
set(handles. editTextTestInd,'Enable','on');

set(handles. Epochs,'Enable','on');
set(handles. Goal,'Enable','on');

function partial_initialize_propertyObj()

global propertyObj

propertyObj.inputProcessFcn.inputProcFcn1 = 0;
propertyObj.inputProcessFcn.inputProcFcn2 = 0;
propertyObj.inputProcessFcn.inputProcFcn3 = 0;
propertyObj.inputProcessFcn.inputProcFcn4 = 0;
propertyObj.inputProcessFcn.inputProcFcn5 = 0;
propertyObj.inputProcessFcn.inputProcFcn6 = 0;
propertyObj.inputProcessFcn.inputProcFcn7 = 0;

propertyObj.outputProcessFcn.outputProcFcn1 = 0; 
propertyObj.outputProcessFcn.outputProcFcn2 = 0; 
propertyObj.outputProcessFcn.outputProcFcn3 = 0; 
propertyObj.outputProcessFcn.outputProcFcn4 = 0; 
propertyObj.outputProcessFcn.outputProcFcn5 = 0; 
propertyObj.outputProcessFcn.outputProcFcn6 = 0; 
propertyObj.outputProcessFcn.outputProcFcn7 = 0; 
