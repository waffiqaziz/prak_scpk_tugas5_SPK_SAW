% 123190070 / Waffiq Aziz

% SISTEM PENDUKUNG KEPUTUSAN UNTUK PEMILIHAN HOTEL 
% DENGAN SIMPLE ADDITIVE WEIGHTING (SAW)

% Program Berdasarkan Jurnal Online
% Link Jurnal : https://ojs.amikom.ac.id/index.php/semnasteknomedia/article/view/1245/1181

%%
function varargout = SPK_SAW_GUI(varargin)
% SPK_SAW_GUI MATLAB code for SPK_SAW_GUI.fig
%      SPK_SAW_GUI, by itself, creates a new SPK_SAW_GUI or raises the existing
%      singleton*.
%
%      H = SPK_SAW_GUI returns the handle to a new SPK_SAW_GUI or the handle to
%      the existing singleton*.
%
%      SPK_SAW_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPK_SAW_GUI.M with the given input arguments.
%
%      SPK_SAW_GUI('Property','Value',...) creates a new SPK_SAW_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SPK_SAW_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SPK_SAW_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SPK_SAW_GUI

% Last Modified by GUIDE v2.5 21-Jun-2021 16:37:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SPK_SAW_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SPK_SAW_GUI_OutputFcn, ...
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


%  --- Executes just before SPK_SAW_GUI is made visible.
function SPK_SAW_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SPK_SAW_GUI (see VARARGIN)

% Choose default command line output for SPK_SAW_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SPK_SAW_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

clc
clear

% --- Outputs from this function are returned to the command line.
function varargout = SPK_SAW_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% TAMPILKAN SEMUA KRITERIA (.PNG)
    % Harga sewa
    gambar1 = imread ('C1.png'); 
    axes(handles.axesC1);
    imshow(gambar1);
    
    % Fasilitas
    gambar2 = imread ('C2.png');
    axes(handles.axesC2);
    imshow(gambar2);
    
    % Kelas hotel
    gambar3 = imread ('C3.png');
    axes(handles.axesC3);
    imshow(gambar3);

%% MENAMPILKAN NILAI DARI MASING MASING KRITERIA
    disp('Nilai Input x =')
    ReadData = readmatrix('rating.csv');
    disp(ReadData);
    set(handles.uitable1, 'Data', ReadData); 


% -- TOMBOL PROSES
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% GET USER INPUT
    harga = str2double(get(handles.tfHargaSewa, 'String'));
    fasilitas = str2double(get(handles.tfFasilitas, 'String'));
    kelasHotel = str2double(get(handles.tfKelasHotel, 'String'));

   % Cek user input sudah diisi / belum
   if (isempty(get(handles.tfHargaSewa, 'String'))) || isempty(get(handles.tfFasilitas, 'String')) || isempty(get(handles.tfKelasHotel, 'String'))
       f = msgbox({'Kolom Bobot Kriteria';'Belum Diisi Semua'},'Error');
       beep % add sound
   end
   if (isnan(harga)) || (isnan(fasilitas)) || (isnan(kelasHotel))
       beep % add sound
       f = msgbox({'Format Input Tidak Sesuai'},'Error');
       
   else
       % READ DATA
       dataX = readmatrix('rating.csv');
       
       % BOBOT untuk masing-masing kriteria
       bobot = [harga, fasilitas, kelasHotel];
       disp('Bobot yang Diberikan w = ');
       disp(bobot);
       
       % NILAI ATRIBUT, dimana 0= atribut biaya &1= atribut keuntungan
       k = [1, 1, 1];
       disp('Atribut Tiap Kriteria k =');
       disp(k);
       
       % NORMALISASI MATRIX
       % matriks m x n dengan ukuran sebanyak variabel x(input)
       [m, n] = size(dataX);
       
       % membuat matriks R, yang merupakan matriks kosong
       R = zeros(m,n);
       
       for j=1:n
           if k(j) == 1 % statement untuk kriteria dengan atribut keuntungan
               R(:,j)=dataX(:,j)./max(dataX(:,j));
           else
               R(:,j)=min(dataX(:,j))./dataX(:,j);
           end
       end
       
       disp('Matriks yang Sudah Ter-nomalisasi R =');
       disp(R);
       
       for i=1 : m
           V(i)= sum(bobot.*R(i,:));
       end
       
       %% TULIS HASIL PERHITUNGAN DAN RANKING KEDALAM FILE (.XLSX)
       perangkingan = V;
       xlswrite('hasil_perhitungan.xlsx', perangkingan);
       
       perangkingan = sort(V,'descend');
       xlswrite('nilai_rangking.xlsx', perangkingan);
       
       %% TAMPILKAN DALAM UITABLE (GUI)
       ReadData = xlsread('hasil_perhitungan.xlsx');
       set(handles.uitable3,'Data',ReadData); % hasil perhitungan
       
       ReadData = xlsread('nilai_rangking.xlsx');
       set(handles.uitable6,'Data',ReadData); % ranking
   end
       

function tfHargaSewa_Callback(hObject, eventdata, handles)
% hObject    handle to tfHargaSewa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tfHargaSewa as text
%        str2double(get(hObject,'String')) returns contents of tfHargaSewa as a double


% --- Executes during object creation, after setting all properties.
function tfHargaSewa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfHargaSewa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tfFasilitas_Callback(hObject, eventdata, handles)
% hObject    handle to tfFasilitas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tfFasilitas as text
%        str2double(get(hObject,'String')) returns contents of tfFasilitas as a double


% --- Executes during object creation, after setting all properties.
function tfFasilitas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfFasilitas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tfKelasHotel_Callback(hObject, eventdata, handles)
% hObject    handle to tfKelasHotel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tfKelasHotel as text
%        str2double(get(hObject,'String')) returns contents of tfKelasHotel as a double


% --- Executes during object creation, after setting all properties.
function tfKelasHotel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfKelasHotel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tfHargaSewa, 'String', '');
set(handles.tfFasilitas, 'String', '');
set(handles.tfKelasHotel, 'String', '');
