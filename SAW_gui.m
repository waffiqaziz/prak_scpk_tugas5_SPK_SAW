function varargout = SAW_gui(varargin)
% SAW_GUI MATLAB code for SAW_gui.fig
%      SAW_GUI, by itself, creates a new SAW_GUI or raises the existing
%      singleton*.
%
%      H = SAW_GUI returns the handle to a new SAW_GUI or the handle to
%      the existing singleton*.
%
%      SAW_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAW_GUI.M with the given input arguments.
%
%      SAW_GUI('Property','Value',...) creates a new SAW_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SAW_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SAW_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SAW_gui

% Last Modified by GUIDE v2.5 20-Jun-2021 21:13:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAW_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @SAW_gui_OutputFcn, ...
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


% --- Executes just before SAW_gui is made visible.
function SAW_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAW_gui (see VARARGIN)

% Choose default command line output for SAW_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SAW_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAW_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in img1.
function img1_Callback(hObject, eventdata, handles)
% hObject    handle to img1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gambar1 = imread ('masa_kerja.jpg');
axes(handles.axes1);
imshow(gambar1);

% --- Executes on button press in img2.
function img2_Callback(hObject, eventdata, handles)
% hObject    handle to img2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gambar2 = imread ('penilaian_perilaku.jpg');
axes(handles.axes2);
imshow(gambar2);

% --- Executes on button press in img3.
function img3_Callback(hObject, eventdata, handles)
% hObject    handle to img3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gambar3 = imread ('penilaian_kinerja.jpg');
axes(handles.axes3);
imshow(gambar3);


% --- Executes on button press in buka.
function buka_Callback(hObject, eventdata, handles)
% hObject    handle to buka (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ReadData = readmatrix('nilai.csv');
set(handles.uitable1, 'Data', ReadData);

% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MK = str2double(get(handles.MK, 'String'));
PK = str2double(get(handles.PK, 'String'));
PP = str2double(get(handles.PP, 'String'));
dataX = readmatrix('nilai.csv');

k = [1, 1, 1];
bobot = [MK, PK, PP];

[m, n] = size(dataX); %matriks m x n dengan ukuran sebanyak variabel x(input)
R = zeros(m,n); %membuat matriks R, yang merupakan matriks kosong

for j=1:n
    if k(j)==1 %statement untuk kriteria dengan atribut keuntungan
        R(:,j)=dataX(:,j)./max(dataX(:,j));
    else
        R(:,j)=min(dataX(:,j))./dataX(:,j);
    end
end
for i=1 : m
    V(i)= sum(bobot.*R(i,:));
end
perangkingan = V;
xlswrite('hasil.xlsx', perangkingan);

ReadData = xlsread('hasil.xlsx');
set(handles.uitable3,'Data',ReadData);

perangkingan = sort(V,'descend');
xlswrite('nilai_rangking.xlsx', perangkingan);

ReadData = xlsread('nilai_rangking.xlsx');
set(handles.uitable6,'Data',ReadData);


function MK_Callback(hObject, eventdata, handles)
% hObject    handle to MK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MK as text
%        str2double(get(hObject,'String')) returns contents of MK as a double


% --- Executes during object creation, after setting all properties.
function MK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PK_Callback(hObject, eventdata, handles)
% hObject    handle to PK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PK as text
%        str2double(get(hObject,'String')) returns contents of PK as a double


% --- Executes during object creation, after setting all properties.
function PK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PP_Callback(hObject, eventdata, handles)
% hObject    handle to PP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PP as text
%        str2double(get(hObject,'String')) returns contents of PP as a double


% --- Executes during object creation, after setting all properties.
function PP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in simpan.
function simpan_Callback(hObject, eventdata, handles)
% hObject    handle to simpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MK = str2double(get(handles.MK,'String'));
PK = str2double(get(handles.PK,'String'));
PP = str2double(get(handles.PP,'String'));
bobot = [MK, PK, PP];
