function varargout = pjimage(varargin)
% PJIMAGE MATLAB code for pjimage.fig
%      PJIMAGE, by itself, creates a new PJIMAGE or raises the existing
%      singleton*.
%
%      H = PJIMAGE returns the handle to a new PJIMAGE or the handle to
%      the existing singleton*.
%
%      PJIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PJIMAGE.M with the given input arguments.
%
%      PJIMAGE('Property','Value',...) creates a new PJIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pjimage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pjimage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pjimage

% Last Modified by GUIDE v2.5 15-Aug-2017 19:21:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pjimage_OpeningFcn, ...
                   'gui_OutputFcn',  @pjimage_OutputFcn, ...
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


% --- Executes just before pjimage is made visible.
function pjimage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pjimage (see VARARGIN)
% Choose default command line output for pjimage
handles.output = hObject;
setappdata(handles.figure_pjimage,'img_src',0);
% Update handles structure
guidata(hObject, handles);
set(handles.m_image,'Enable','off');
% UIWAIT makes pjimage wait for user response (see UIRESUME)
% uiwait(handles.figure_pjimage);
setappdata(handles.figure_pjimage,'bSave',false);
setappdata(handles.figure_pjimage,'bChanged',false);
setappdata(handles.figure_pjimage,'fstSave',true);
setappdata(handles.figure_pjimage,'fstPath',0);
% --- Outputs from this function are returned to the command line.
function varargout = pjimage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)
% hObject    handle to m_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_file_open_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile(...
    {'*.bmp; *.jpg;*.jpeg','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick an Image');
axes(handles.axes_src);%用axes命令设定当前操作的坐标轴是axes_src
if isequal(filename,0) || isequal(pathname,0)
    return
else
fpath = [pathname filename];%将文件名和目录名组合成一个完整的路径
end
img_src = imread(fpath);
imshow(img_src);%用imread读入图片，并用imshow在axes_src上显示
setappdata(handles.figure_pjimage,'img_src',img_src);
set(handles.m_image,'Enable','on');
% --------------------------------------------------------------------
function m_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img_src = getappdata(handles.figure_pjimage,'img_src');
[filename,pathname] = uiputfile({'*.bmp','BMP files';'*.jpg','JPG files'},'Pick an Image');
if isequal(filename,0) || isequal(pathname,0)
    return;%如果点了取消
else
    fpath = fullfile(pathname,filename);%获得全路径的另一种方法
end
img_src = getappdata(handles.figure_pjimage,'img_src');%取得打开图片的数据
imwrite(img_src,fpath);%保存图片
% --------------------------------------------------------------------
function m_file_exit_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bChanged = getappdata(handles.figure_pjimage,'bChanged');
bSave = getappdata(handles.figure_pjimage,'bSave');
if bChanged==true && bSave==false
    btnName=questdlg('您已经更改了图片，但没有保存。是否保存？','提示','保存','不保存','保存');%用提问对话框
    switch btnName
        case '保存'   %执行axes_dst_menu_save_Callback的功能
            feval(@axes_dst_menu_save_Callback,handles.axes_dst_menu_save,eventdata,handles);
        case'不保存' %什么也不做
    end
end
h = findobj('Tag','figure_im2bw'); %查找是否打开二值化参数窗口
if ~isempty(h) %找到的话，则关闭
    close(h);
end
close(findobject('Tag','figure_pjimage'));%关闭主窗口
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes when figure_pjimage is resized.
function figure_pjimage_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure_pjimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_image_Callback(hObject, eventdata, handles)
% hObject    handle to m_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_image_2bw_Callback(hObject, eventdata, handles)
% hObject    handle to m_image_2bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = im2bw_args;


% --------------------------------------------------------------------
function axes_dst_menu_save_Callback(hObject, eventdata, handles)
% hObject    handle to axes_dst_menu_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile({'*.bmp','BMP files';'*.jpg','JPG files'},'Pick an Image');
if isequal(filename,0) || isequal(pathname,0)
    return
else
    fpath = fullfile(pathname,filename);
end
img_dst = getimage(handles.axes_dst);
imwrite(img_dst,fpath);
setappdata(handles.figure_pjimage,'bSave',true);
% --------------------------------------------------------------------
function axes_dst_menu_Callback(hObject, eventdata, handles)
% hObject    handle to axes_dst_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tbl_open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbl_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
feval(@m_file_open_Callback,handles.m_file_open,eventdata,handles)


% --------------------------------------------------------------------
function tbl_save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbl_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fstSave = getappdata(handles.figure_pjimage,'fstSave');
if(fstSave==true)
    [filename,pathname] = uiputfile({'*.bmp','BMP files';'*.jpg','JPG files'},'Pick an Image'); 
    if isequal(filename,0) || isequal(pathname,0)
        return;
    else
        fpath = fullfile(pathname,filename);
    end
    img_dst = getimage(handles.axes_dst);
    imwrite(img_dst,fpath);
    setappdata(handles.figure_pjimage,'fstPath',fpath);
    setappdata(handles.figure_pjimage,'bSave',true);
    setappdata(handles.figure_pjimage,'fstSave',false);
else
    img_dst = getimage(handles.axes_dst);
    fpath = getappdata(handles.figure_pjimage,'fstPath');
    imwrite(img_dst,fpath);
end
