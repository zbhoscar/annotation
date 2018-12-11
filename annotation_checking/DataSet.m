function varargout = DataSet(varargin)
% DATASET MATLAB code for DataSet.fig
%      DATASET, by itself, creates a new DATASET or raises the existing
%      singleton*.
%
%      H = DATASET returns the handle to a new DATASET or the handle to
%      the existing singleton*.
%
%      DATASET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATASET.M with the given input arguments.
%
%      DATASET('Property','Value',...) creates a new DATASET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataSet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataSet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataSet

% Last Modified by GUIDE v2.5 06-Aug-2018 15:06:50

% Begin initialization code - DO NOT EDIT
addpath ./位姿处理
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DataSet_OpeningFcn, ...
    'gui_OutputFcn',  @DataSet_OutputFcn, ...
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
global  line_table;
line_table = [2,4,1;1,3,2;2,4,2;1,3,1];

% --- Executes just before DataSet is made visible.
function DataSet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataSet (see VARARGIN)

% Choose default command line output for DataSet
handles.output = hObject;
setappdata(handles.DS_Figure,'Cflag',0);%Classification flag
setappdata(handles.DS_Figure,'Hflag',0);%Height flag
setappdata(handles.DS_Figure,'SVflag',0);%Save flag
setappdata(handles.DS_Figure,'NEXflag',0);%Next flag
set(handles.PRE,'Enable','off');
set(handles.NEX,'Enable','off');
set(handles.FRM,'Enable','off');
set(handles.H_D,'Enable','off');
set(handles.H_T,'Enable','off');
set(handles.DEL,'Enable','off');
set(handles.SV,'Enable','off');
set(handles.ActionBox,'Enable','off');
set(handles.ClassBox,'Enable','off');
set(handles.DriveTask,'Enable','off');
set(handles.AutoBehavior,'Enable','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataSet wait for user response (see UIRESUME)
% uiwait(handles.DS_Figure);


% --- Outputs from this function are returned to the command line.
function varargout = DataSet_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in DriveTask.
function DriveTask_Callback(hObject, eventdata, handles)
% hObject    handle to DriveTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag = get(hObject,'Value');
setappdata(handles.DS_Figure,'TFlag',flag);
set(handles.AutoBehavior,'Enable','on');

% Hints: contents = cellstr(get(hObject,'String')) returns DriveTask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DriveTask


% --- Executes during object creation, after setting all properties.
function DriveTask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DriveTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AutoBehavior.
function AutoBehavior_Callback(hObject, eventdata, handles)
% hObject    handle to AutoBehavior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag = get(hObject,'Value');
setappdata(handles.DS_Figure,'BFlag',flag);
set(handles.ClassBox,'Enable','on');
% Hints: contents = cellstr(get(hObject,'String')) returns AutoBehavior contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AutoBehavior


% --- Executes during object creation, after setting all properties.
function AutoBehavior_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AutoBehavior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ActionBox_Callback(hObject, eventdata, handles)
% hObject    handle to ActionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
tmp = get(hObject,'Value');
setappdata(handles.DS_Figure,'AFlag',tmp);
setappdata(handles.DS_Figure,'AStr',contents{tmp});
CHF = getappdata(handles.DS_Figure,'CHF');
if CHF == 1
    A = getappdata(handles.DS_Figure,'ActionObject');
    TFlag = get(handles.DriveTask,'Value'); TaskFlag = getappdata(handles.axes_laser,'TaskFlag'); TaskFlag(A(1)) = TFlag; setappdata(handles.axes_laser,'TaskFlag',TaskFlag);
    BFlag = get(handles.AutoBehavior,'Value'); BeFlag = getappdata(handles.axes_laser,'BehaviorFlag'); BeFlag(A(1)) = BFlag; setappdata(handles.axes_laser,'BehaviorFlag',BeFlag);
    AFlag = get(handles.ClassBox,'Value'); AcFlag = getappdata(handles.axes_laser,'ActionFlag'); AcFlag(A(1)) = AFlag; setappdata(handles.axes_laser,'ActionFlag',AcFlag);
    IFlag = get(handles.idBox,'Value'); IDFlag = getappdata(handles.axes_laser,'IDFlag');IDFlag(A(1)) = IFlag; setappdata(handles.axes_laser,'IDFlag',IDFlag);
    ActionStrPlot = getappdata(handles.axes_laser,'ActionStrPlot');
    delete(ActionStrPlot(A(1)));
    AdjLine = getappdata(handles.axes_laser,'AdjLine');
    L = AdjLine(A(1),:);
    contents = cellstr(get(handles.idBox,'String')); tmp = get(handles.idBox,'Value'); IStr = contents{tmp};
    contents = cellstr(get(handles.ActionBox,'String')); tmp = get(handles.ActionBox,'Value'); AStr = contents{tmp};
    AStrPlot = text(L(1).XData(2),L(1).YData(2),L(1).ZData(2),['\leftarrow',IStr,AStr]);
    ActionStrPlot(A(1)) = AStrPlot;
    setappdata(handles.axes_laser,'ActionStrPlot',ActionStrPlot);
%     
end


% --- Executes during object creation, after setting all properties.
function ActionBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ActionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ClassBox.
function ClassBox_Callback(hObject, eventdata, handles)
% hObject    handle to ClassBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'Value');

switch tmp
    case 1
        setappdata(handles.DS_Figure,'color','r');
        str = {'1背沿边直行靠近','2面沿边直行靠近','3向左跑步横穿','4向左慢步横穿','5向右跑步横穿','6向右慢步横穿','7驻停','8其他','9','10','11','12','13'};
        handles.ActionBox.String = str;
        set(handles.ActionBox,'Enable','on');
    case 2
        setappdata(handles.DS_Figure,'color','g');
        str = {'1左超车','2右超车','3正前方车辆减速','4向左驶离车道','5向右驶离车道','6向左驶入车道','7向右驶入车道','8加速直行','9匀速直行','10左平行','11右平行','12驻停','13其他'};        
        handles.ActionBox.String = str;
        set(handles.ActionBox,'Enable','on');
    case 3
        setappdata(handles.DS_Figure,'color','m');
        str = {'1背直行沿道路边缘靠近','2背直行沿道路边缘远离','3面直行沿道路边缘靠近','4向左骑行横穿道路','5向右骑行横穿道路','6驻停','7其他','8','9','10','11','12','13'};
        handles.ActionBox.String = str;
        set(handles.ActionBox,'Enable','on');
end
setappdata(handles.DS_Figure,'Cflag',tmp);
% set(handles.ActionBox,'Enable','on');
% --- Executes on selection change in idBox.
function idBox_Callback(hObject, eventdata, handles)
% hObject    handle to idBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag = get(hObject,'Value');
setappdata(handles.DS_Figure,'IFlag',flag);
set(handles.ClassBox,'Enable','on');
%%
% contents = cellstr(get(hObject,'String'));
% tmp = get(hObject,'Value');
% if tmp == 1
%     NVal = str2double(contents(end))+1;
%     if isnan(NVal)
%         NVal = 1;
%     end
%     contents(end+1) = {num2str(NVal)};
%     hObject.String = contents;
% else
%     VAL = str2double(contents(tmp));
%     setappdata(handles.DS_Figure,'IFlag',VAL);
%     setappdata(handles.DS_Figure,'IStr',contents{tmp});
% end
% Hints: contents = cellstr(get(hObject,'String')) returns idBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from idBox


% --- Executes during object creation, after setting all properties.
function idBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ClassBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClassBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DEL_Callback(hObject, eventdata, handles)
% hObject    handle to DEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
NEXflag = getappdata(handles.DS_Figure,'NEXflag');
if NEXflag == 0
    btnName = questdlg('是否删除所有标注结果','警告','确定删除','取消','取消');
else
    btnName = '确定删除';
end
if strcmp(btnName,'确定删除')
    CFtemp = getappdata(handles.axes_laser,'ClassFlag');
    Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
    HDtemp = getappdata(handles.axes_laser,'H_D');
    HTtemp = getappdata(handles.axes_laser,'H_T');
    Otemp = getappdata(handles.axes_laser,'Direct');
    SPttemp = getappdata(handles.axes_laser,'SlcPoint');
    CBtemp = getappdata(handles.axes_laser,'Cube');
    CB2dtemp = getappdata(handles.axes_laser,'Cube2d');
    AdLinetemp = getappdata(handles.axes_laser,'AdjLine');
    AFtemp = getappdata(handles.axes_laser,'ActionFlag');
    ASPtemp = getappdata(handles.axes_laser,'ActionStrPlot');
    TFtemp = getappdata(handles.axes_laser,'TaskFlag');
    BFtemp = getappdata(handles.axes_laser,'BehaviorFlag');
    IFtemp = getappdata(handles.axes_laser,'IDFlag');
    if ~isempty(CFtemp)
        CFtemp = [];
        setappdata(handles.axes_laser,'ClassFlag',CFtemp);
    end
    if ~isempty(Vt2dtemp)
        Vt2dtemp = [];
        setappdata(handles.axes_laser,'Vertex2d',Vt2dtemp);
    end
    if ~isempty(HDtemp)
        HDtemp = [];
        setappdata(handles.axes_laser,'H_D',HDtemp);
        if ~isempty(HDtemp)
            set(handles.H_D,'String',num2str(HDtemp(end)));
        else
            set(handles.H_D,'String','');
        end;
    end
    if ~isempty(HTtemp)
        HTtemp = [];
        setappdata(handles.axes_laser,'H_T',HTtemp);
        if ~isempty(HTtemp)
            set(handles.H_T,'String',num2str(HTtemp(end)));
        else
            set(handles.H_T,'String','');
        end
    end
    if ~isempty(Otemp)
        Otemp = [];
        setappdata(handles.axes_laser,'Direct',Otemp);
    end
    if ~isempty(SPttemp)
        delete(SPttemp);
        SPttemp = [];
        setappdata(handles.axes_laser,'SlcPoint',SPttemp);
    end
    if ~isempty(CBtemp)
        delete(CBtemp);
        CBtemp = [];
        if isempty(CBtemp)
            set(handles.H_D,'Enable','off');
            set(handles.H_T,'Enable','off');
            set(handles.DEL,'Enable','off');
            set(handles.SV,'Enable','off');
        end
        setappdata(handles.axes_laser,'Cube',CBtemp);
    end
    if ~isempty(CB2dtemp)
        delete(CB2dtemp);
        CB2dtemp = [];
        setappdata(handles.axes_laser,'Cube2d',CB2dtemp);
    end
    if ~isempty(AdLinetemp)
        delete(AdLinetemp);
        AdLinetemp = [];
        setappdata(handles.axes_laser,'AdjLine',AdLinetemp);
    end
    if ~isempty(AFtemp)
        AFtemp = [];
        setappdata(handles.axes_laser,'ActionFlag',AFtemp);
    end
    if ~isempty(ASPtemp)
        delete(ASPtemp);
        ASPtemp = [];
        setappdata(handles.axes_laser,'ActionStrPlot',ASPtemp);
    end
    if ~isempty(TFtemp)
        TFtemp = [];
        setappdata(handles.axes_laser,'TaskFlag',TFtemp);
    end
    if ~isempty(BFtemp)
        BFtemp = [];
        setappdata(handles.axes_laser,'BehaviorFlag',BFtemp);
    end
    if ~isempty(IFtemp)
        IFtemp = [];
        setappdata(handles.axes_laser,'IDFlag',IFtemp);
    end
    setappdata(handles.DS_Figure,'ActionObject',[]);
    setappdata(handles.DS_Figure,'SVflag',0);
end
% --- Executes on button press in PRE.
function PRE_Callback(hObject, eventdata, handles)
% hObject    handle to PRE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ind = getappdata(handles.DS_Figure,'Index');
setappdata(handles.DS_Figure,'Index',Ind-1);
Ind = num2str(Ind-1);
set(handles.FRM,'String',Ind);
FRM_Callback(handles.FRM, eventdata, handles);
% --- Executes on button press in NEX.
function NEX_Callback(hObject, eventdata, handles)
% hObject    handle to NEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SVflag = getappdata(handles.DS_Figure,'SVflag');
% if SVflag == 0
%     btnName = questdlg('是否保存标注结果','提示','保存','不保存','取消','保存');
%     switch btnName
%         case '保存'
%             SV_Callback(handles.axes_laser, eventdata, handles);
%         case '取消'
%             returns
%         case ' '
%             return
%         case '不保存'
%     end
% end
setappdata(handles.DS_Figure,'NEXflag',1);
Ind = getappdata(handles.DS_Figure,'Index');
setappdata(handles.DS_Figure,'Index',Ind+1);
Ind = num2str(Ind+1);
set(handles.FRM,'String',Ind);
FRM_Callback(handles.FRM, eventdata, handles);
% DEL_Callback(handles.DEL, eventdata, handles);
% setappdata(handles.DS_Figure,'SVflag',0);
setappdata(handles.DS_Figure,'NEXflag',0);

function axes_laser_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_laser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pFlag = getappdata(handles.DS_Figure,'PressFlag');
if pFlag == 0
    return
end
num = length(getappdata(handles.axes_laser,'ClassFlag'));
if strcmp(get(handles.DS_Figure,'SelectionType'),'normal')
    CFlag = getappdata(handles.DS_Figure,'Cflag');
    IFlag = getappdata(handles.DS_Figure,'IFlag');
    AFlag = getappdata(handles.DS_Figure,'AFlag');
    BFlag = getappdata(handles.DS_Figure,'BFlag');
    if isempty([IFlag,AFlag,BFlag])
        return
    end
    if CFlag == 0
        return
    end
    clr = getappdata(handles.DS_Figure,'color');
    for i = 1:4
        % pt = get(gca,'CurrentPoint');
        % axes(handles.axes_laser);
        pt = ginput(1);
        X(i,1) = pt(1,1);
        X(i,2) = pt(1,2);
        if i<3
            Pt(i) = plot(X(i,1),X(i,2),['o',clr]);
            Y(i,:) = X(i,:);
        end
        if i == 2
            L(1) = line(Y(1:2,1),Y(1:2,2),'color',clr,'tag',[num2str(num+1),'.1'],'ButtondownFcn',{@Recfun,handles});
        end
        if i == 3
            Y(3,:) = X(3,:)+(X(1,:)-X(2,:))*((X(3,:)-X(2,:))*(X(2,:)-X(1,:))')/((X(2,:)-X(1,:))*(X(2,:)-X(1,:))');
            Pt(3) = plot(Y(3,1),Y(3,2),['o',clr]);
            Y(4,:) = Y(3,:)+(X(1,:)-X(2,:));
            Pt(4) = plot(Y(4,1),Y(4,2),['o',clr]);
            L(2) = line(Y(2:3,1),Y(2:3,2),'color',clr,'tag',[num2str(num+1),'.2'],'ButtondownFcn',{@Recfun,handles});
            L(3) = line(Y([4,3],1),Y([4,3],2),'color',clr,'tag',[num2str(num+1),'.3'],'ButtondownFcn',{@Recfun,handles});
            L(4) = line(Y([1,4],1),Y([1,4],2),'color',clr,'tag',[num2str(num+1),'.4'],'ButtondownFcn',{@Recfun,handles});
        end
        if i==4
            O(1,:) = (Y(2,:)+Y(3,:))/2+(Y(1,:)-Y(2,:))/2;
            flag1 = (Y(2,:)-O(1,:))*(X(4,:)-O(1,:))';
            flag2 = (Y(3,:)-O(1,:))*(X(4,:)-O(1,:))';
            if flag1>0
                if flag2>0
                    O(2,:) = O(1,:)+3/4*(Y(2,:)-Y(1,:));
                else
                    O(2,:) = O(1,:)+3/4*(Y(2,:)-Y(3,:));
                end
            else
                if flag2>0
                    O(2,:) = O(1,:)-3/4*(Y(2,:)-Y(3,:));
                else
                    O(2,:) = O(1,:)-3/4*(Y(2,:)-Y(1,:));
                end
            end
            L(5) = line(O(:,1),O(:,2),'color',clr);
            L(6) = plot(O(1,1),O(1,2),['.',clr],'MarkerSize',50,'tag',[num2str(num+1),'.6'],'ButtondownFcn',{@Recfun,handles});
            L(7) = plot(O(2,1),O(2,2),['.',clr],'MarkerSize',50,'tag',[num2str(num+1),'.7'],'ButtondownFcn',{@Recfun,handles});
        end
    end
    %% 标记在矩形框中的点并存储
    pcData = getappdata(handles.DS_Figure,'pcData');
    in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
    if isempty(pcData(in,:))
        %         ClassFlag(end) = [];
        %         setappdata(hObject,'ClassFlag',ClassFlag);
        %         Direct(end-1:end,:) = [];
        %         setappdata(hObject,'Direct',Direct);
        %         Vertex2d(end-3:end,:) = [];
        %         setappdata(hObject,'Vertex2d',Vertex2d);
        delete(L);
        delete(Pt);
        return
    end
    axes(handles.axes_laser);
    SPt = plot3(pcData(in,1),pcData(in,2),pcData(in,3),['d',clr]);
    SlcPoint = getappdata(hObject,'SlcPoint');
    SlcPoint = [SlcPoint,SPt];
    setappdata(hObject,'SlcPoint',SlcPoint);
    %% 存储物体类别标签
    ClassFlag = getappdata(hObject,'ClassFlag');
    ClassFlag = [ClassFlag,CFlag];
    setappdata(hObject,'ClassFlag',ClassFlag);
    %% 存储物体ID标签
    IDFlag = getappdata(hObject,'IDFlag');
    IDFlag = [IDFlag,IFlag];
    setappdata(hObject,'IDFlag',IDFlag);
    %% 存储物体行为标签
    ActionFlag = getappdata(hObject,'ActionFlag');
    ActionFlag = [ActionFlag,AFlag];
    setappdata(hObject,'ActionFlag',ActionFlag);
    %% 存储驾驶任务标签
    TFlag = getappdata(handles.DS_Figure,'TFlag');
    TaskFlag = getappdata(hObject,'TaskFlag');
    TaskFlag = [TaskFlag,TFlag];
    setappdata(hObject,'TaskFlag',TaskFlag);
    %% 存储自主行为标签
    BehaviorFlag = getappdata(hObject,'BehaviorFlag');
    BehaviorFlag = [BehaviorFlag,BFlag];
    setappdata(hObject,'BehaviorFlag',BehaviorFlag);
    %% 存储选择的方向
    Direct = getappdata(hObject,'Direct');
    Direct = [Direct;O];
    setappdata(hObject,'Direct',Direct);
    %% 存储选择的四个点
    Vertex2d = getappdata(hObject,'Vertex2d');
    Vertex2d = [Vertex2d;Y];
    setappdata(hObject,'Vertex2d',Vertex2d);
    %% 计算立方体的最小最大高度并存储,并且显示在底部高度和顶部高度的文字框中
    H_D = min(pcData(in,3));
    H_T = max(pcData(in,3));
    for ii = 1:7
        if ii<6
            L(ii).ZData = [H_T+0.5,H_T+0.5];
        else
            L(ii).ZData = H_T+0.5;
        end
    end
    H_Dtemp = getappdata(hObject,'H_D');
    H_Dtemp = [H_Dtemp,H_D];
    setappdata(hObject,'H_D',H_Dtemp);
    H_Ttemp = getappdata(hObject,'H_T');
    H_Ttemp = [H_Ttemp,H_T];
    setappdata(hObject,'H_T',H_Ttemp);
    set(handles.H_D,'String',num2str(H_D));
    set(handles.H_T,'String',num2str(H_T));
    %% 在方框附近标注行为和ID并存储
    AStr = getappdata(handles.DS_Figure,'AStr');
    IStr = getappdata(handles.DS_Figure,'IStr');
    AStrPlot = text(L(1).XData(2),L(1).YData(2),L(1).ZData(2),['\leftarrow',IStr,AStr]);
    ActionStrPlot = getappdata(hObject,'ActionStrPlot');
    ActionStrPlot = [ActionStrPlot,AStrPlot];
    setappdata(hObject,'ActionStrPlot',ActionStrPlot);
    %% 利用最小最大高度来生成立方体并存储
    Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
    Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
    Cb(1) = line(Pt3_Draw(:,1),Pt3_Draw(:,2),Pt3_Draw(:,3),'color',clr);
    Cb(2) = plot3(Pt3(:,1),Pt3(:,2),Pt3(:,3),['o',clr]);
    Cb(3) = line(O(:,1),O(:,2),repmat(H_D,2,1),'color',clr);
    %     delete(L);
    delete(Pt);
    Cube = getappdata(hObject,'Cube');
    Cube = [Cube;Cb];
    setappdata(hObject,'Cube',Cube);
    %% 将立方体投影在二维图像中并存储
    RT = getappdata(handles.DS_Figure,'RT');
    calib = getappdata(handles.DS_Figure,'Calib_Results');
    I = getappdata(handles.DS_Figure,'Image');
    Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
    Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
    axes(handles.axes_pic);
    Cb2d(1) = line(Pt2_Draw(:,1),Pt2_Draw(:,2),'color',clr);
    Cb2d(2) = line(Pt2_Direct(:,1),Pt2_Direct(:,2),'color',clr);
    Cube2d = getappdata(hObject,'Cube2d');
    Cube2d = [Cube2d;Cb2d];
    setappdata(hObject,'Cube2d',Cube2d);
    %% 将画出的直线L(1:7)存储起来留待调整使用
    AdjLine = getappdata(handles.axes_laser,'AdjLine');
    AdjLine = [AdjLine;L];
    setappdata(handles.axes_laser,'AdjLine',AdjLine);
    %% 激活H_D, H_T, DEL和SV
    set(handles.H_D,'Enable','on');
    set(handles.H_T,'Enable','on');
    set(handles.DEL,'Enable','on');
    set(handles.SV,'Enable','on');
    %% 设置H_D和H_T的作用对象
    A = [num+1,1];
    setappdata(handles.DS_Figure,'ActionObject',A);
    %% 重置存储标志
    setappdata(handles.DS_Figure,'SVflag',0);
end
if strcmp(get(handles.DS_Figure,'SelectionType'),'alt')
    %% 删除ClassFlag,Vertex2d,H_D,H_T,Direct,SlcPoint,Cube,Cube2d,AdjLine,ActionFlag,ActionStrPlot,TaskFlag,BehaviorFlag,IDFlag
    CFtemp = getappdata(hObject,'ClassFlag');
    Vt2dtemp = getappdata(hObject,'Vertex2d');
    HDtemp = getappdata(hObject,'H_D');
    HTtemp = getappdata(hObject,'H_T');
    Otemp = getappdata(hObject,'Direct');
    SPttemp = getappdata(hObject,'SlcPoint');
    CBtemp = getappdata(hObject,'Cube');
    CB2dtemp = getappdata(hObject,'Cube2d');
    ALtemp = getappdata(hObject,'AdjLine');
    AFtemp = getappdata(hObject,'ActionFlag');
    ASPtemp = getappdata(hObject,'ActionStrPlot');
    TFtemp = getappdata(hObject,'TaskFlag');
    BFtemp = getappdata(hObject,'BehaviorFlag');
    IFtemp = getappdata(hObject,'IDFlag');
    A = getappdata(handles.DS_Figure,'ActionObject');
    if ~isempty(CFtemp)
        CFtemp(A(1)) = [];
        setappdata(hObject,'ClassFlag',CFtemp);
    end
    if ~isempty(Vt2dtemp)
        Vt2dtemp(4*A(1)-3:4*A(1),:) = [];
        setappdata(hObject,'Vertex2d',Vt2dtemp);
    end
    if ~isempty(HDtemp)
        HDtemp(A(1)) = [];
        setappdata(hObject,'H_D',HDtemp);
        if ~isempty(HDtemp)
            set(handles.H_D,'String',num2str(HDtemp(end)));
        else
            set(handles.H_D,'String','');
        end;
    end
    if ~isempty(HTtemp)
        HTtemp(A(1)) = [];
        setappdata(hObject,'H_T',HTtemp);
        if ~isempty(HTtemp)
            set(handles.H_T,'String',num2str(HTtemp(end)));
        else
            set(handles.H_T,'String','');
        end
    end
    if ~isempty(Otemp)
        Otemp(2*A(1)-1:2*A(1),:) = [];
        setappdata(hObject,'Direct',Otemp);
    end
    if ~isempty(SPttemp)
         delete(SPttemp(A(1)));
         SPttemp(A(1)) = [];
        setappdata(hObject,'SlcPoint',SPttemp);
    end
    if ~isempty(CBtemp)
        delete(CBtemp(A(1),:));
        CBtemp(A(1),:) = [];
        if isempty(CBtemp)
            set(handles.H_D,'Enable','off');
            set(handles.H_T,'Enable','off');
            set(handles.DEL,'Enable','off');
            set(handles.SV,'Enable','off');
        end
        setappdata(hObject,'Cube',CBtemp);
    end
    if ~isempty(CB2dtemp)
        delete(CB2dtemp(A(1),:));
        CB2dtemp(A(1),:) = [];
        setappdata(hObject,'Cube2d',CB2dtemp);
    end
    if ~isempty(ALtemp)
        delete(ALtemp(A(1),:));
        ALtemp(A(1),:) = [];
        for i = 1:length(ALtemp(:,1))
         for ii = 1:7
             ALtemp(i,ii).Tag = num2str(i+0.1*ii);
         end
        end
        setappdata(hObject,'AdjLine',ALtemp);
    end
    if ~isempty(AFtemp)
        AFtemp(A(1)) = [];
        setappdata(hObject,'ActionFlag',AFtemp);
    end
    if ~isempty(ASPtemp)
        delete(ASPtemp(A(1)));
        ASPtemp(A(1)) = [];
        setappdata(hObject,'ActionStrPlot',ASPtemp);
    end
    if ~isempty(TFtemp)
        TFtemp(A(1)) = [];
        setappdata(hObject,'TaskFlag',TFtemp);
    end
    if ~isempty(BFtemp)
        BFtemp(A(1)) = [];
        setappdata(hObject,'BehaviorFlag',BFtemp);
    end
    if ~isempty(IFtemp)
        IFtemp(A(1)) = [];
        setappdata(hObject,'IDFlag',IFtemp);
    end
    %% 调整变量ActionObject（改变H_D和H_T的作用对象）
    A = getappdata(handles.DS_Figure,'ActionObject');
    A(1) = length(CFtemp);
    setappdata(handles.DS_Figure,'ActionObject',A);
    if ~isempty(HTtemp)
        set(handles.H_T,'String',num2str(HTtemp(end)));
        set(handles.H_D,'String',num2str(HDtemp(end)));
    else
        set(handles.H_T,'String','');
        set(handles.H_D,'String','');
    end
    %% 重置存储标志
    setappdata(handles.DS_Figure,'SVflag',0);
end
% --- Executes on button press in DIR.
function DIR_Callback(hObject, eventdata, handles)
% hObject    handle to DIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~exist('folder.txt','file')
    folder_laser = uigetdir('','选择激光图像数据文件夹');
    if  isequal(folder_laser,0)
        return
    end
    fid = fopen('folder.txt','w');
    fprintf(fid,'%s\n',folder_laser);
else
    btnName = questdlg('使用 上次 or 上次的下一个 图像激光数据文件夹？','提示（默认为下一个)','使用','下一个','其他','下一个');
    switch btnName
        case '使用'
            fid = fopen('folder.txt');
            folder_laser = fgetl(fid);
        case '其他'
            folder_laser = uigetdir('','选择激光图像数据文件夹');
            if  isequal(folder_laser,0)
                return
            end
            fid = fopen('folder.txt','w');
            fprintf(fid,'%s\n',folder_laser);
        case '下一个'
            fid = fopen('folder.txt');
            folder_old = fgetl(fid);
            [father_path,self_name,~]=fileparts(folder_old);
            abc = struct2cell(dir(father_path));
            list_in_num = sort_nat(abc(1,:));
            index = find(ismember(list_in_num, self_name));
            next_name = char(list_in_num(index+1));
            folder_laser = fullfile(father_path, next_name);
            if ~exist(folder_laser,'dir')
                error('%s 已遍历完！', father_path);
            end
            fid = fopen('folder.txt','w');
            fprintf(fid,'%s\n',folder_laser);
        otherwise
            return
    end
    disp(folder_laser)
    set(handles.text15,'String',folder_laser);
end
setappdata(handles.DS_Figure,'LaserRoot',[folder_laser,'\']);
labelRoot = [folder_laser,'\Label'];
if ~exist(labelRoot,'dir')
    mkdir(labelRoot);
end
setappdata(handles.DS_Figure,'labelRoot',[labelRoot,'\']);
RT = load([folder_laser,'\..\Rt.mat']);
setappdata(handles.DS_Figure,'RT',RT);
Calib = load([folder_laser,'\..\Calib_Results.mat']);
setappdata(handles.DS_Figure,'Calib_Results',Calib);
set(handles.FRM,'Enable','on');
function FRM_Callback(hObject, eventdata, handles)
% hObject    handle to FRM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FRM as text
%        str2double(get(hObject,'String')) returns contents of FRM as a double
setappdata(handles.DS_Figure,'NEXflag',1);
DEL_Callback(handles.DEL, eventdata, handles);
setappdata(handles.DS_Figure,'NEXflag',0);
Ind = str2double(get(hObject,'String'));
setappdata(handles.DS_Figure,'Index',Ind);
setappdata(handles.DS_Figure,'SVflag',0);
LaserRoot = getappdata(handles.DS_Figure,'LaserRoot');
PicRoot = LaserRoot;
if ~exist([PicRoot,num2str(Ind),'.jpg'],'file')
    Ind = nan;
end
if ~isnan(Ind)
    axes(handles.axes_laser);
    hold on;
    cla;
    pcData = show3d(LaserRoot,Ind);
    axis([-5 55 -20 25])
    setappdata(handles.DS_Figure,'pcData',pcData);
    view(2);
    axes(handles.axes_pic);
    cla;
    I = imread([PicRoot,num2str(Ind),'.jpg']);
    setappdata(handles.DS_Figure,'Image',I);
    imshow(I);
end
labelRoot = getappdata(handles.DS_Figure,'labelRoot');
PRF = getappdata(handles.DS_Figure,'PRF');
if PRF == 1
    Ind = Ind-1;
end
Ind1 = sprintf('%06d',Ind);
txtRoot = [labelRoot,Ind1,'.txt'];
if exist(txtRoot,'file')
    fid = fopen(txtRoot,'r');
    IDFlag = [];
    TaskFlag = [];
    BehaviorFlag = [];
    ClassFlag = [];
    ActionFlag = [];
    Vertex2d = [];
    Direct = [];
    SlcPoint = [];
    H_Dtemp = [];
    H_Ttemp = [];
    ActionStrPlot = [];
    Cube = [];
    Cube2d = [];
    AdjLine = [];
    num = -1;
    while ~feof(fid)
        num = num+1;
        tline = fgetl(fid);
        if tline == -1
            return
        end
        A = strsplit(tline);
        IFlag = str2double(A{1});
        TFlag = str2double(A{2});
        BFlag = str2double(A{3});
        CFlag = str2double(A{4});
        switch CFlag
            case 1
                clr = 'r';
            case 2
                clr = 'g';
            case 3
                clr = 'm';
        end
        AFlag = str2double(A{5});
        O(1,:) = [str2double(A{6}),str2double(A{7})];
        O(2,:) = [str2double(A{10}),str2double(A{11})] + O(1,:);
        L1 = str2double(A{8});
        L2 = str2double(A{9});
        D1 = (O(2,:)-O(1,:))/sqrt((O(2,:)-O(1,:))*(O(2,:)-O(1,:))');
        D2 = [D1(2),-D1(1)];
        Y(1,:) = O(1,:)+L1*D1+L2*D2;
        Y(2,:) = O(1,:)+L1*D1-L2*D2;
        Y(3,:) = O(1,:)-L1*D1-L2*D2;
        Y(4,:) = O(1,:)-L1*D1+L2*D2;
        axes(handles.axes_laser);
        L(1) = line(Y(1:2,1),Y(1:2,2),'color',clr,'tag',[num2str(num+1),'.1'],'ButtondownFcn',{@Recfun,handles});
        L(2) = line(Y(2:3,1),Y(2:3,2),'color',clr,'tag',[num2str(num+1),'.2'],'ButtondownFcn',{@Recfun,handles});
        L(3) = line(Y([4,3],1),Y([4,3],2),'color',clr,'tag',[num2str(num+1),'.3'],'ButtondownFcn',{@Recfun,handles});
        L(4) = line(Y([1,4],1),Y([1,4],2),'color',clr,'tag',[num2str(num+1),'.4'],'ButtondownFcn',{@Recfun,handles});
        L(5) = line(O(:,1),O(:,2),'color',clr);
        L(6) = plot(O(1,1),O(1,2),['.',clr],'MarkerSize',50,'tag',[num2str(num+1),'.6'],'ButtondownFcn',{@Recfun,handles});
        L(7) = plot(O(2,1),O(2,2),['.',clr],'MarkerSize',50,'tag',[num2str(num+1),'.7'],'ButtondownFcn',{@Recfun,handles});
        %     H_D = str2double(A{11});
        %     H_T = str2double(A{12});
        H_D = str2double(A{12});
        H_T = str2double(A{13});
        %% 恢复物体类别标签
        ClassFlag = [ClassFlag,CFlag];
        %% 恢复物体行为标签
        ActionFlag = [ActionFlag,AFlag];
        %% 恢复驾驶任务标签
        TaskFlag = [TaskFlag,TFlag];
        handles.DriveTask.Value = TFlag;
        %% 恢复自主行为标签
        BehaviorFlag = [BehaviorFlag,BFlag];
        handles.AutoBehavior.Value = BFlag;
        %% 恢复选择的方向
        Direct = [Direct;O];
        %% 恢复选择的四个点
        Vertex2d = [Vertex2d;Y];
        %% 恢复ID标签
        IDFlag = [IDFlag,IFlag];
        %% 恢复标记在矩形框中的点
        pcData = getappdata(handles.DS_Figure,'pcData');
        in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
        pcData = pcData(in,:);
        in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
        SPt = plot3(pcData(in,1),pcData(in,2),pcData(in,3),['d',clr]);
        if isempty(SPt)
            SPt = plot3(Y(1,:),Y(2,:),Y(3,:),['d',clr]);
        end
        SlcPoint = [SlcPoint,SPt];
        %% 恢复最小最大高度
        H_TT = max(H_T,H_D);
        for ii = 1:7
            if ii<6
                L(ii).ZData = [H_TT+0.5,H_TT+0.5];
            else
                L(ii).ZData = H_TT+0.5;
            end
        end
        H_Dtemp = [H_Dtemp,H_D];
        H_Ttemp = [H_Ttemp,H_T];
        set(handles.H_D,'String',num2str(H_D));
        set(handles.H_T,'String',num2str(H_T));
        %% 恢复方框附近标注的行为
        if AFlag == 0
            AStr = ['待修改'];
        else
            handles.DriveTask.Value = TFlag;
            DriveTask_Callback(handles.DriveTask,eventdata,handles);
            handles.ClassBox.Value = CFlag;
            ClassBox_Callback(handles.ClassBox,eventdata,handles);
            contents = cellstr(get(handles.ActionBox,'String'));
            AStr = contents(AFlag);
        end
        IStr = num2str(IFlag);
        AStrPlot = text(L(1).XData(2),L(1).YData(2),L(1).ZData(2),['\leftarrow',IStr,AStr]);
        ActionStrPlot = [ActionStrPlot,AStrPlot];
        %% 恢复立方体并存储
        Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
        Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
        Cb(1) = line(Pt3_Draw(:,1),Pt3_Draw(:,2),Pt3_Draw(:,3),'color',clr);
        Cb(2) = plot3(Pt3(:,1),Pt3(:,2),Pt3(:,3),['o',clr]);
        Cb(3) = line(O(:,1),O(:,2),repmat(H_D,2,1),'color',clr);
        Cube = [Cube;Cb];
        %% 恢复二维图像中的立方体
        RT = getappdata(handles.DS_Figure,'RT');
        calib = getappdata(handles.DS_Figure,'Calib_Results');
        I = getappdata(handles.DS_Figure,'Image');
        Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
        Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
        axes(handles.axes_pic);
        Cb2d(1) = line(Pt2_Draw(:,1),Pt2_Draw(:,2),'color',clr);
        Cb2d(2) = line(Pt2_Direct(:,1),Pt2_Direct(:,2),'color',clr);
        Cube2d = [Cube2d;Cb2d];
        %% 存储画出的直线L(1:7)
        AdjLine = [AdjLine;L];
    end
    setappdata(handles.axes_laser,'ClassFlag',ClassFlag);
    setappdata(handles.axes_laser,'ActionFlag',ActionFlag);
    setappdata(handles.axes_laser,'TaskFlag',TaskFlag);
    setappdata(handles.axes_laser,'BehaviorFlag',BehaviorFlag);
    setappdata(handles.axes_laser,'Direct',Direct);
    setappdata(handles.axes_laser,'Vertex2d',Vertex2d);
    setappdata(handles.axes_laser,'SlcPoint',SlcPoint);
    setappdata(handles.axes_laser,'H_D',H_Dtemp);
    setappdata(handles.axes_laser,'H_T',H_Ttemp);
    setappdata(handles.axes_laser,'ActionStrPlot',ActionStrPlot);
    setappdata(handles.axes_laser,'Cube',Cube);
    setappdata(handles.axes_laser,'Cube2d',Cube2d);
    setappdata(handles.axes_laser,'AdjLine',AdjLine);
    setappdata(handles.axes_laser,'IDFlag',IDFlag);
    setappdata(handles.DS_Figure,'SVflag',1);
    A = [num+1,1];
    setappdata(handles.DS_Figure,'ActionObject',A);
    set(handles.SV,'Enable','on');
    set(handles.DEL,'Enable','on');
    set(handles.H_D,'Enable','on');
    set(handles.H_T,'Enable','on');
    fclose(fid);
end
ClueStr = getappdata(handles.DS_Figure,'ClueStr');
if ~isempty(ClueStr)
    delete(ClueStr);
    ClueStr = [];
end
Ind1 = sprintf('%06d',Ind-1);
txtRoot = [labelRoot,Ind1,'.txt'];
if exist(txtRoot,'file')
    ClueStr = [];
    fid = fopen(txtRoot,'r');
    ID = [];
    axes(handles.axes_laser);
    while ~feof(fid)
        tline = fgetl(fid);
        A = strsplit(tline);
        IFlag = str2double(A{1});
        ID = IFlag;
        H_T = str2double(A{13});
        O = [str2double(A{6}),str2double(A{7})];
        CStr = text(O(1),O(2),H_T+0.5,num2str(IFlag),'Color','red','FontSize',10);
        ClueStr = [ClueStr,CStr];
    end
%     ID = sort(ID);
%     IDStr = {'添加ID'};
%     for i =1:length(ID)
%         IDStr = [IDStr,num2str(ID(i))];
%     end
%     handles.idBox.String = [];
%     handles.idBox.String = IDStr;
    setappdata(handles.DS_Figure,'ClueStr',ClueStr);
    fclose(fid);
end
set(handles.PRE,'Enable','on');
set(handles.NEX,'Enable','on');
set(handles.DriveTask,'Enable','on');
% --- Executes during object creation, after setting all properties.
function FRM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FRM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VIEW.
function VIEW_Callback(hObject, eventdata, handles)
% hObject    handle to VIEW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_laser);
view(2);


% --- Executes on button press in SV.
function SV_Callback(hObject, eventdata, handles)
% hObject    handle to SV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
labelRoot = getappdata(handles.DS_Figure,'labelRoot');
ind = str2double(get(handles.FRM,'String'));
ind = sprintf('%06d',ind);
txtRoot = [labelRoot,ind,'.txt'];
fid = fopen(txtRoot,'w');
TF = getappdata(handles.axes_laser,'TaskFlag');
BF = getappdata(handles.axes_laser,'BehaviorFlag');
CF = getappdata(handles.axes_laser,'ClassFlag');
AF = getappdata(handles.axes_laser,'ActionFlag');
Vt2d = getappdata(handles.axes_laser,'Vertex2d');
O = getappdata(handles.axes_laser,'Direct');
HD = getappdata(handles.axes_laser,'H_D');
HT = getappdata(handles.axes_laser,'H_T');
IF = getappdata(handles.axes_laser,'IDFlag');
%order number(1),TaskFlag(1),BehaviorFlag(1),ClassFlag(1),ActionFlag(1),Center(2),L1(parallel to direct 1),L2(vertical to direct 1),direct(2),H_D(1),H_T(1)
if isempty(CF)
    return
end
for i = 1:length(CF)
    fprintf(fid,'%d ',IF(i));
    fprintf(fid,'%d ',TF(i));
    fprintf(fid,'%d ',BF(i));
    fprintf(fid,'%d ',CF(i));
    fprintf(fid,'%d ',AF(i));
    Lflag = (Vt2d(4*i-3,:)-Vt2d(4*i-2,:))*(O(2*i-1,:)-O(2*i,:))';
    if abs(Lflag)<1e-10
        L1 = norm(Vt2d(4*i-1,:)-Vt2d(4*i-2,:))/2;
        L2 = norm(Vt2d(4*i-3,:)-Vt2d(4*i-2,:))/2;
    else
        L2 = norm(Vt2d(4*i-1,:)-Vt2d(4*i-2,:))/2;
        L1 = norm(Vt2d(4*i-3,:)-Vt2d(4*i-2,:))/2;
    end
    fprintf(fid,'%f %f %f %f ',O(2*i-1,:),L1,L2);
    fprintf(fid,'%f %f ',O(2*i,:)-O(2*i-1,:));
    fprintf(fid,'%f %f\n',HD(i),HT(i));
end
setappdata(handles.DS_Figure,'SVflag',1);



function H_D_Callback(hObject, eventdata, handles)
% hObject    handle to H_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 重新获取相关画图数据
A = getappdata(handles.DS_Figure,'ActionObject');
HTtemp = getappdata(handles.axes_laser,'H_T');
Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
Otemp= getappdata(handles.axes_laser,'Direct');
Y = Vt2dtemp(4*A(1)-3:4*A(1),:);
O = Otemp(2*A(1)-1:2*A(1),:);
calib = getappdata(handles.DS_Figure,'Calib_Results');
%% 判断输入是否正确
H_T = HTtemp(A(1));
H_D = str2double(get(hObject,'String'));
if H_T<H_D
    HDtemp = getappdata(handles.axes_laser,'H_D');
    set(handles.H_D,'String',num2str(HDtemp(A(1))));
    return
end
%% 重新绘制三维矩形框并存储
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube = getappdata(handles.axes_laser,'Cube');
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);
%% 重新绘制立方体投影并存储
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);
%% 重新标记矩形框中的点并存储
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
pcData = pcData(in,:);
in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);
%% 重新存储底部高度H_D
HDtemp = getappdata(handles.axes_laser,'H_D');
HDtemp(A(1)) = H_D;
setappdata(handles.axes_laser,'H_D',HDtemp);
%% 重置存储标志
setappdata(handles.DS_Figure,'SVflag',0);
% --- Executes during object creation, after setting all properties.
function H_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function H_T_Callback(hObject, eventdata, handles)
% hObject    handle to H_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 重新获取相关画图数据
A = getappdata(handles.DS_Figure,'ActionObject');
HDtemp = getappdata(handles.axes_laser,'H_D');
Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
Otemp= getappdata(handles.axes_laser,'Direct');
Y = Vt2dtemp(4*A(1)-3:4*A(1),:);
O = Otemp(2*A(1)-1:2*A(1),:);
calib = getappdata(handles.DS_Figure,'Calib_Results');
%% 判断输入是否正确
H_T = str2double(get(hObject,'String'));
H_D = HDtemp(A(1));
if H_T<H_D
    H_Ttemp = getappdata(handles.axes_laser,'H_T');
    set(handles.H_T,'String',num2str(H_Ttemp(A(1))));
    return
end
%% 改变调整线的高度
L = getappdata(handles.axes_laser,'AdjLine');
for ii = 1:7
    if ii<6
        L(A(1),ii).ZData = [H_T+0.5,H_T+0.5];
    else
        L(A(1),ii).ZData = H_T+0.5;
    end
end
%% 重新设置文字位置
ActionStrPlot = getappdata(handles.axes_laser,'ActionStrPlot');
ActionStrPlot(A(1)).Position = [L(A(1),1).XData(2),L(A(1),1).YData(2),L(A(1),1).ZData(2)];
%% 重新绘制三维矩形框
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube = getappdata(handles.axes_laser,'Cube');
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);
%% 重新绘制立方体投影并存储
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);
%% 重新标记矩形框中的点并存储
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
pcData = pcData(in,:);
in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);
%% 重新存储底部高度H_T
HTtemp = getappdata(handles.axes_laser,'H_T');
HTtemp(A(1)) = H_T;
setappdata(handles.axes_laser,'H_T',HTtemp);
%% 重置存储标志
setappdata(handles.DS_Figure,'SVflag',0);

% --- Executes during object creation, after setting all properties.
function H_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Recfun(hObject,eventdata,handles)
hObject.Selected = 'on';
tmp = strsplit(hObject.Tag,'.');
A(1) = str2double(tmp{1});
A(2) = str2double(tmp{2});
%% 删除之前画出的SlcPoint,Cube,Cube2d
Slctmp = getappdata(handles.axes_laser,'SlcPoint');
Slctmp(A(1)).XData= []; Slctmp(A(1)).YData= [];Slctmp(A(1)).ZData= []; %删除之前选中的点
Cbtmp = getappdata(handles.axes_laser,'Cube');
for i = 1:3
    Cbtmp(A(1),i).XData=[];Cbtmp(A(1),i).YData=[];Cbtmp(A(1),i).ZData=[];  %删除六面体Cube
end
Cb2dtmp = getappdata(handles.axes_laser,'Cube2d');
for i = 1:2
    Cb2dtmp(A(1),i).XData=[];Cb2dtmp(A(1),i).YData=[];Cb2dtmp(A(1),i).ZData=[]; %删除图像中的六面体Cube2d
end
%% 根据Tag重置H_D，H_T的窗口中的值，并改变H_D，H_T的作用对象
setappdata(handles.DS_Figure,'ActionObject',A);
H_D = getappdata(handles.axes_laser,'H_D');
H_T = getappdata(handles.axes_laser,'H_T');
set(handles.H_D,'String',H_D(A(1)));
set(handles.H_T,'String',H_T(A(1)));
%% 设置回调函数
L = getappdata(handles.axes_laser,'AdjLine');
if A(2)<5
    set(handles.DS_Figure,'WindowButtonMotionFcn',{@AdjRectangleFun,hObject,handles,A,L})
end
if A(2)==6
    set(handles.DS_Figure,'windowbuttonmotionfcn',{@MovRectanglefun,hObject,handles,A,L});
end
if A(2)==7
    flag1 = ([L(A(1),1).XData(1),L(A(1),1).YData(1)]-[L(A(1),1).XData(2),L(A(1),1).YData(2)])*([L(A(1),5).XData(1),L(A(1),5).YData(1)]-[L(A(1),5).XData(2),L(A(1),5).YData(2)])';
    if abs(flag1)<1e-5
        norm = [cal_norm(L(A(1),1)), cal_norm(L(A(1),2))];  % [平行，垂直]
    else
        norm = [cal_norm(L(A(1),2)),cal_norm(L(A(1),1))];   % [平行，垂直]
    end
    set(handles.DS_Figure,'windowbuttonmotionfcn',{@RotRectanglefun,hObject,handles,A,L,norm/2});
end
% --- Executes on key press with focus on DS_Figure or any of its controls.

function  AdjRectangleFun(hObject,eventdata,lineobject,handles,A,L)
h_axes = handles.axes_laser;
global line_table;
L_ind = line_table(A(2),:);
offset = cal_vert([lineobject.XData(1),lineobject.YData(1)],[lineobject.XData(2),lineobject.YData(2)],h_axes.CurrentPoint(1,1:2));
lineobject.XData = lineobject.XData+offset(1);
lineobject.YData = lineobject.YData+offset(2);
L(A(1),L_ind(1)).XData(L_ind(3)) = L(A(1),L_ind(1)).XData(L_ind(3))+offset(1);
L(A(1),L_ind(1)).YData(L_ind(3)) = L(A(1),L_ind(1)).YData(L_ind(3))+offset(2);
L(A(1),L_ind(2)).XData(L_ind(3)) = L(A(1),L_ind(2)).XData(L_ind(3))+offset(1);
L(A(1),L_ind(2)).YData(L_ind(3)) = L(A(1),L_ind(2)).YData(L_ind(3))+offset(2);
for i=5:7
    L(A(1),i).XData = L(A(1),i).XData+offset(1)/2;
    L(A(1),i).YData = L(A(1),i).YData+offset(2)/2;
end
offset2 =  cal_off(offset,[L(A(1),5).XData(1),L(A(1),5).YData(1)],[L(A(1),5).XData(2),L(A(1),5).YData(2)],h_axes.CurrentPoint(1,1:2));
L(A(1),5).XData(2) = L(A(1),5).XData(2)+offset2(1)/2;
L(A(1),5).YData(2) = L(A(1),5).YData(2)+offset2(2)/2;
L(A(1),7).XData = L(A(1),7).XData+offset2(1)/2;
L(A(1),7).YData = L(A(1),7).YData+offset2(2)/2;
set(hObject,'WindowButtonUpFcn',{@wbufcn,lineobject,A,handles})

function MovRectanglefun(hObject,event,lineobject,handles,A,L)
h_axes = handles.axes_laser;
offset = h_axes.CurrentPoint(1,1:2)-[lineobject.XData,lineobject.YData];
% lineobject.XData = lineobject.XData+offset(1);
% lineobject.YData = lineobject.YData+offset(2);
for i = 1:7
    L(A(1),i).XData = L(A(1),i).XData+offset(1);
    L(A(1),i).YData = L(A(1),i).YData+offset(2);
end
set(hObject,'WindowButtonUpFcn',{@wbufcn,lineobject,A,handles})

function RotRectanglefun(hObject,event,lineobject,handles,A,L,norm)
h_axes = handles.axes_laser;
normL5 = cal_norm(L(A(1),5));
% ([L(A(1),1).XData(1),L(A(1),1).YData(1)]-[L(A(1),1).XData(2),L(A(1),1).YData(2)])
% ([L(A(1),5).XData(2),L(A(1),5).YData(2)]-[L(A(1),5).XData(1),L(A(1),5).YData(1)])
flag = ([L(A(1),1).XData(1),L(A(1),1).YData(1)]-[L(A(1),1).XData(2),L(A(1),1).YData(2)])*([L(A(1),5).XData(2),L(A(1),5).YData(2)]-[L(A(1),5).XData(1),L(A(1),5).YData(1)])';
B = h_axes.CurrentPoint(1,1:2)-[L(A(1),5).XData(1),L(A(1),5).YData(1)];
B = B*normL5/sqrt(B*B');
L(A(1),5).XData(2) = B(1)+L(A(1),5).XData(1);
L(A(1),5).YData(2) = B(2)+L(A(1),5).YData(1);
lineobject.XData = L(A(1),5).XData(2);
lineobject.YData = L(A(1),5).YData(2);
off = cal_vert1([L(A(1),5).XData(1),L(A(1),5).YData(1)],[L(A(1),5).XData(2),L(A(1),5).YData(2)],[L(A(1),1).XData(1),L(A(1),1).YData(1)],norm(1));
if abs(flag)>1e-5
    if flag > 0
        off1 = B*norm(2)/sqrt(B*B')+off;
        off2 = -B*norm(2)/sqrt(B*B')+off;
        off3 = B*norm(2)/sqrt(B*B')-off;
        off4 = -B*norm(2)/sqrt(B*B')-off;
    else
        off1 = -B*norm(2)/sqrt(B*B')+off;
        off2 = B*norm(2)/sqrt(B*B')+off;
        off3 = -B*norm(2)/sqrt(B*B')-off;
        off4 = B*norm(2)/sqrt(B*B')-off;
    end
else
    off1 = -B*norm(2)/sqrt(B*B')+off;
    off2 = -B*norm(2)/sqrt(B*B')-off;
    off3 = B*norm(2)/sqrt(B*B')+off;
    off4 = B*norm(2)/sqrt(B*B')-off;
end
L(A(1),1).XData(1) = L(A(1),6).XData+off1(1);
L(A(1),1).YData(1) = L(A(1),6).YData+off1(2);
L(A(1),1).XData(2) = L(A(1),6).XData+off2(1);
L(A(1),1).YData(2) = L(A(1),6).YData+off2(2);
L(A(1),3).XData(1) = L(A(1),6).XData+off3(1);
L(A(1),3).YData(1) = L(A(1),6).YData+off3(2);
L(A(1),3).XData(2) = L(A(1),6).XData+off4(1);
L(A(1),3).YData(2) = L(A(1),6).YData+off4(2);
L(A(1),2).XData(1) = L(A(1),1).XData(2);
L(A(1),2).YData(1) = L(A(1),1).YData(2);
L(A(1),2).XData(2) = L(A(1),3).XData(2);
L(A(1),2).YData(2) = L(A(1),3).YData(2);
L(A(1),4).XData(1) = L(A(1),1).XData(1);
L(A(1),4).YData(1) = L(A(1),1).YData(1);
L(A(1),4).XData(2) = L(A(1),3).XData(1);
L(A(1),4).YData(2) = L(A(1),3).YData(1);
set(hObject,'WindowButtonUpFcn',{@wbufcn,lineobject,A,handles})

function wbufcn(hObject,event,lineobject,A,handles)
L = getappdata(handles.axes_laser,'AdjLine');
H_Dtmp = getappdata(handles.axes_laser,'H_D');
H_Ttmp = getappdata(handles.axes_laser,'H_T');
calib = getappdata(handles.DS_Figure,'Calib_Results');
%% 恢复SlcPoint，Cube，Cube2d
Y(1,:) = [L(A(1),1).XData(1),L(A(1),1).YData(1)];
Y(2,:) = [L(A(1),1).XData(2),L(A(1),1).YData(2)];
Y(3,:) = [L(A(1),3).XData(2),L(A(1),3).YData(2)];
Y(4,:) = [L(A(1),3).XData(1),L(A(1),3).YData(1)];
O(1,:) = [L(A(1),5).XData(1),L(A(1),5).YData(1)];
O(2,:) = [L(A(1),5).XData(2),L(A(1),5).YData(2)];
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
axes(handles.axes_laser);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);  % 重绘被选中的点
H_D = min([pcData(in,3);H_Dtmp(A(1))]);
H_T = max([pcData(in,3);H_Ttmp(A(1))]);
for ii = 1:7
    if ii<6
        L(A(1),ii).ZData = [H_T+0.5,H_T+0.5];
    else
        L(A(1),ii).ZData = H_T+0.5;
    end
end                               % 重置调整线的高度
ActionStrPlot = getappdata(handles.axes_laser,'ActionStrPlot');
ActionStrPlot(A(1)).Position = [L(A(1),1).XData(2),L(A(1),1).YData(2),L(A(1),1).ZData(2)]; %重设文字位置
Cube = getappdata(handles.axes_laser,'Cube');
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);  %重绘六面体Cube中的线
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);       %重绘六面体Cube中的顶点
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);    %重绘六面体Cube中的方向线
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
axes(handles.axes_pic);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);       %重绘图像中的六面体Cube2d
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);     %重绘图像中六面体Cube2d的方向线
%% 重置Direct，Vertex2d，H_D，H_T，SVflag
Direct = getappdata(handles.axes_laser,'Direct');Direct(2*A(1)-1:2*A(1),:) = O;setappdata(handles.axes_laser,'Direct',Direct); %重置Direct
Vertex2d = getappdata(handles.axes_laser,'Vertex2d');Vertex2d(4*A(1)-3:4*A(1),:) = Y;setappdata(handles.axes_laser,'Vertex2d',Vertex2d); %重置Vertex2d
H_Dtmp(A(1)) = H_D;setappdata(handles.axes_laser,'H_D',H_Dtmp); %重置H_D
H_Ttmp(A(1)) = H_T;setappdata(handles.axes_laser,'H_T',H_Ttmp);  %重置H_T
setappdata(handles.DS_Figure,'SVflag',0); %重置存储标志
%% 完成调整
lineobject.Selected = 'off';
set(hObject,'WindowButtonMotionFcn','');
set(hObject,'WindowButtonUpFcn','');
function DS_Figure_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to DS_Figure (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.DS_Figure,'CurrentCharacter'),' ')
    pFlag = getappdata(handles.DS_Figure,'PressFlag');
    if isempty(pFlag) || pFlag==1
        setappdata(handles.DS_Figure,'PressFlag',0);
    elseif pFlag==0
        setappdata(handles.DS_Figure,'PressFlag',1);
    end
end

function [vertical] = cal_vert(A,B,C)
% A,B为线段上的点，C为线段外的点，vertical为垂直向量
vertical = (C-B)-(C-B)*(A-B)'*(A-B)/((A-B)*(A-B)');

function [vertical] = cal_vert1(A,B,C,norm)
% A,B为线段上的点，C为线段外的点，vertical为垂直向量,norm为计算出的垂直向量的模
vertical = (C-B)-(C-B)*(A-B)'*(A-B)/((A-B)*(A-B)');
vertical = vertical*norm/sqrt(vertical*vertical');

function [offset] = cal_off(off,O1,O2,C)
% 计算方向线端点的延伸距离，off为偏移向量，O1,O2为方向线端点，C为当前鼠标所在位置
offset = [0,0];
flag1 = (C-O1)*(O2-O1)';
flag2 = abs(off*(O2-O1)');
if flag1>0
    B = O2-O1;
    offset = (off*B')*B/(B*B');
end
if  flag2 >1e-5 && flag1<0
    offset = -off;
end

function [norm] = cal_norm(L)
norm = sqrt(([L.XData(1),L.YData(1)]-[L.XData(2), L.YData(2)])*([L.XData(1),L.YData(1)]-[L.XData(2),L.YData(2)])');


% --- Executes on button press in ChangeFlag.
function ChangeFlag_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of fMATLAB
% handles    structure with handles and user data (see GUIDATA)
CHF = getappdata(handles.DS_Figure,'CHF');
if CHF==1
    set(hObject,'BackgroundColor',[0.941,0.941,0.941]);
    setappdata(handles.DS_Figure,'CHF',0);
else
    set(hObject,'BackgroundColor',[0.5,0.5,0.5]);
    setappdata(handles.DS_Figure,'CHF',1);
end


% --- Executes on button press in AddB.
function AddB_Callback(hObject, eventdata, handles)
HDtemp = getappdata(handles.axes_laser,'H_D');
   if ~isempty(HDtemp)
      HDtemp=HDtemp+0.1;
%       setappdata(handles.axes_laser,'H_D',HDtemp);
       %% 重新获取相关画图数据
A = getappdata(handles.DS_Figure,'ActionObject');
HTtemp = getappdata(handles.axes_laser,'H_T');
Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
Otemp= getappdata(handles.axes_laser,'Direct');
Y = Vt2dtemp(4*A(1)-3:4*A(1),:);
O = Otemp(2*A(1)-1:2*A(1),:);
calib = getappdata(handles.DS_Figure,'Calib_Results');
% %% 判断输入是否正确
H_T = HTtemp(A(1));
H_D = str2double(get(hObject,'String'));
if H_T<H_D
    HDtemp = getappdata(handles.axes_laser,'H_D');
    set(handles.H_D,'String',num2str(HDtemp(A(1))));
    return
end
H_D=HDtemp(A(1));
%% 重新绘制三维矩形框并存储
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube = getappdata(handles.axes_laser,'Cube');
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);
%% 重新绘制立方体投影并存储
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);
%% 重新标记矩形框中的点并存储
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
pcData = pcData(in,:);
in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);
%% 重新存储底部高度H_D
HDtemp = getappdata(handles.axes_laser,'H_D');
HDtemp(A(1)) = H_D;
setappdata(handles.axes_laser,'H_D',HDtemp);
%% 重置存储标志
setappdata(handles.DS_Figure,'SVflag',0);
       if ~isempty(HDtemp)
            set(handles.H_D,'String',num2str(HDtemp(end)));
        else
            set(handles.H_D,'String','');
        end;

   end
    
  
% hObject    handle to AddB (see GCBO)
% eventdata  reserved - to be defined in a futuref version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SubB.
function SubB_Callback(hObject, eventdata, handles)
% hObject    handle to SubB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HDtemp = getappdata(handles.axes_laser,'H_D');
   if ~isempty(HDtemp)
      HDtemp=HDtemp-0.1;
%       setappdata(handles.axes_laser,'H_D',HDtemp);
       %% 重新获取相关画图数据
A = getappdata(handles.DS_Figure,'ActionObject');
HTtemp = getappdata(handles.axes_laser,'H_T');
Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
Otemp= getappdata(handles.axes_laser,'Direct');
Y = Vt2dtemp(4*A(1)-3:4*A(1),:);
O = Otemp(2*A(1)-1:2*A(1),:);
calib = getappdata(handles.DS_Figure,'Calib_Results');
% %% 判断输入是否正确
H_T = HTtemp(A(1));
% H_D = str2double(get(hObject,'String'));
% if H_T<H_D
%     HDtemp = getappdata(handles.axes_laser,'H_D');
%     set(handles.H_D,'String',num2str(HDtemp(A(1))));
%     return
% end
H_D=HDtemp(A(1));
%% 重新绘制三维矩形框并存储
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube = getappdata(handles.axes_laser,'Cube');
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);
%% 重新绘制立方体投影并存储
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);
%% 重新标记矩形框中的点并存储
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
pcData = pcData(in,:);
in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);
%% 重新存储底部高度H_D
HDtemp = getappdata(handles.axes_laser,'H_D');
HDtemp(A(1)) = H_D;
setappdata(handles.axes_laser,'H_D',HDtemp);
%% 重置存储标志
setappdata(handles.DS_Figure,'SVflag',0);
%  if ~isempty(HDtemp)
            set(handles.H_D,'String',num2str(HDtemp(end)));
%         else
%             set(handles.H_D,'String','');
%         end;

   end


% --- Executes on button press in AddT.
function AddT_Callback(hObject, eventdata, handles)

% hObject    handle to AddT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HTtemp = getappdata(handles.axes_laser,'H_T');
   if ~isempty(HTtemp)
      HTtemp=HTtemp+0.1;
%       setappdata(handles.axes_laser,'H_T',HTtemp);
       %% 重新获取相关画图数据
%% 重新获取相关画图数据
A = getappdata(handles.DS_Figure,'ActionObject');
HDtemp = getappdata(handles.axes_laser,'H_D');
Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
Otemp= getappdata(handles.axes_laser,'Direct');
Y = Vt2dtemp(4*A(1)-3:4*A(1),:);
O = Otemp(2*A(1)-1:2*A(1),:);
calib = getappdata(handles.DS_Figure,'Calib_Results');
%% 判断输入是否正确
H_T = HTtemp(A(1));
H_D = HDtemp(A(1));

%% 改变调整线的高度
L = getappdata(handles.axes_laser,'AdjLine');
for ii = 1:7
    if ii<6
        L(A(1),ii).ZData = [H_T+0.5,H_T+0.5];
    else
        L(A(1),ii).ZData = H_T+0.5;
    end
end
%% 重新设置文字位置
ActionStrPlot = getappdata(handles.axes_laser,'ActionStrPlot');
ActionStrPlot(A(1)).Position = [L(A(1),1).XData(2),L(A(1),1).YData(2),L(A(1),1).ZData(2)];
%% 重新绘制三维矩形框
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube = getappdata(handles.axes_laser,'Cube');
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);
%% 重新绘制立方体投影并存储
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);
%% 重新标记矩形框中的点并存储
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
pcData = pcData(in,:);
in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);
%% 重新存储底部高度H_T
HTtemp = getappdata(handles.axes_laser,'H_T');
HTtemp(A(1)) = H_T;
setappdata(handles.axes_laser,'H_T',HTtemp);
%% 重置存储标志
setappdata(handles.DS_Figure,'SVflag',0);
%  if ~isempty(HTtemp)
            set(handles.H_T,'String',num2str(HTtemp(end)));
%         else
%             set(handles.H_T,'String','');
%         end;

   end


% --- Executes on button press in SubT.
function SubT_Callback(hObject, eventdata, handles)
% hObject    handle to SubT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HTtemp = getappdata(handles.axes_laser,'H_T');
   if ~isempty(HTtemp)
      HTtemp=HTtemp-0.1;
%       setappdata(handles.axes_laser,'H_T',HTtemp);
       %% 重新获取相关画图数据
%% 重新获取相关画图数据
A = getappdata(handles.DS_Figure,'ActionObject');
HDtemp = getappdata(handles.axes_laser,'H_D');
Vt2dtemp = getappdata(handles.axes_laser,'Vertex2d');
Otemp= getappdata(handles.axes_laser,'Direct');
Y = Vt2dtemp(4*A(1)-3:4*A(1),:);
O = Otemp(2*A(1)-1:2*A(1),:);
calib = getappdata(handles.DS_Figure,'Calib_Results');
%% 判断输入是否正确
H_T = HTtemp(A(1));
H_D = HDtemp(A(1));

%% 改变调整线的高度
L = getappdata(handles.axes_laser,'AdjLine');
for ii = 1:7
    if ii<6
        L(A(1),ii).ZData = [H_T+0.5,H_T+0.5];
    else
        L(A(1),ii).ZData = H_T+0.5;
    end
end
%% 重新设置文字位置
ActionStrPlot = getappdata(handles.axes_laser,'ActionStrPlot');
ActionStrPlot(A(1)).Position = [L(A(1),1).XData(2),L(A(1),1).YData(2),L(A(1),1).ZData(2)];
%% 重新绘制三维矩形框
Pt3 = [Y,repmat(H_D,4,1);Y,repmat(H_T,4,1)];
Pt3_Draw = [Pt3(1:4,:);Pt3(1,:);Pt3(5:8,:);Pt3(5:6,:);Pt3(2:3,:);Pt3(7:8,:);Pt3(4,:)];
Cube = getappdata(handles.axes_laser,'Cube');
Cube(A(1),1).XData = Pt3_Draw(:,1);Cube(A(1),1).YData = Pt3_Draw(:,2);Cube(A(1),1).ZData = Pt3_Draw(:,3);
Cube(A(1),2).XData = Pt3(:,1);Cube(A(1),2).YData = Pt3(:,2);Cube(A(1),2).ZData = Pt3(:,3);
Cube(A(1),3).XData = O(:,1);Cube(A(1),3).YData = O(:,2);Cube(A(1),3).ZData = repmat(H_D,2,1);
%% 重新绘制立方体投影并存储
RT = getappdata(handles.DS_Figure,'RT');
I = getappdata(handles.DS_Figure,'Image');
Pt2_Draw = show_laser_to_image5(I,Pt3_Draw,RT.R,RT.t,calib);
Pt2_Direct = show_laser_to_image5(I,[O(:,1),O(:,2),repmat(H_D,2,1)],RT.R,RT.t,calib);
Cube2d = getappdata(handles.axes_laser,'Cube2d');
Cube2d(A(1),1).XData = Pt2_Draw(:,1);Cube2d(A(1),1).YData = Pt2_Draw(:,2);
Cube2d(A(1),2).XData = Pt2_Direct(:,1);Cube2d(A(1),2).YData = Pt2_Direct(:,2);
%% 重新标记矩形框中的点并存储
pcData = getappdata(handles.DS_Figure,'pcData');
in = inpolygon(pcData(:,1),pcData(:,2),Y(:,1),Y(:,2));
pcData = pcData(in,:);
in = find(pcData(:,3)>H_D&pcData(:,3)<H_T);
SlcPoint = getappdata(handles.axes_laser,'SlcPoint');
SlcPoint(A(1)).XData = pcData(in,1);SlcPoint(A(1)).YData = pcData(in,2);SlcPoint(A(1)).ZData = pcData(in,3);
%% 重新存储底部高度H_T
HTtemp = getappdata(handles.axes_laser,'H_T');
HTtemp(A(1)) = H_T;
setappdata(handles.axes_laser,'H_T',HTtemp);
%% 重置存储标志
setappdata(handles.DS_Figure,'SVflag',0);
%  if ~isempty(HTtemp)
            set(handles.H_T,'String',num2str(HTtemp(end)));
%         else
%             set(handles.H_T,'String','');
%         end;

   end


% --- Executes on button press in PREFLAG.
function PREFLAG_Callback(hObject, eventdata, handles)
% hObject    handle to PREFLAG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PRF = getappdata(handles.DS_Figure,'PRF');
if PRF==1
    set(hObject,'BackgroundColor',[0.941,0.941,0.941]);
    setappdata(handles.DS_Figure,'PRF',0);
else
    set(hObject,'BackgroundColor',[0.5,0.5,0.5]);
    setappdata(handles.DS_Figure,'PRF',1);
end


% --- Executes during object creation, after setting all properties.
function text15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
