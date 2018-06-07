function varargout = RobotArm(varargin)
% ROBOTARM MATLAB code for RobotArm.fig
%      ROBOTARM, by itself, creates a new ROBOTARM or raises the existing
%      singleton*.
%
%      H = ROBOTARM returns the handle to a new ROBOTARM or the handle to
%      the existing singleton*.
%
%      ROBOTARM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTARM.M with the given input arguments.
%
%      ROBOTARM('Property','Value',...) creates a new ROBOTARM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotArm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotArm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above statictextx to modify the response to help RobotArm

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RobotArm_OpeningFcn, ...
    'gui_OutputFcn',  @RobotArm_OutputFcn, ...
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


% --- Executes just before RobotArm is made visible.
function RobotArm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RobotArm (see VARARGIN)

% Choose default command line output for RobotArm
handles.output = hObject;

% This is the spot where you put code that you want to run initially.
clc
% jointSliderChange(hObject, handles);
handles.user.jointAngles = [0 90 0 -90 90]; % Home position.
handles.user.position1Angles = handles.user.jointAngles;
handles.user.position2Angles = handles.user.jointAngles;
handles.user.position3Angles = handles.user.jointAngles;
handles.user.gripperAngle=round(get(handles.slider_gripper,'Value'));
handles.user.port=0;

% Prepare the arm axes_arm
view(handles.axes_arm, [-50 -50 50]);
%axis(handles.axes_arm, [-10 10 -6 6 -6 8]);
axis(handles.axes_arm, [-15 15 -15 15 -11 15]);
set(handles.axes_arm, 'Visible', 'off');

% Add the image of the Wild Thumper to the background axes_arm
addImageToAxes('wildThumper.png', handles.axes_thumper, 400);

% Create vertices for all the patches
makeLink0(handles.axes_arm, [.5 .5 .5]);  % Doesn't move so save no references.
% Save handles to the patch objects and create a vertices matrix for each.
handles.user.link1Patch = makeLink1(handles.axes_arm, [.9 .9 .9]);
handles.user.link1Vertices = get(handles.user.link1Patch, 'Vertices')';
handles.user.link1Vertices(4,:) = ones(1, size(handles.user.link1Vertices,2));
handles.user.link2Patch = makeLink2(handles.axes_arm, [.9 .9 .9]);
handles.user.link2Vertices = get(handles.user.link2Patch, 'Vertices')';
handles.user.link2Vertices(4,:) = ones(1, size(handles.user.link2Vertices,2));
handles.user.link3Patch = makeLink3(handles.axes_arm, [.9 .9 .9]);
handles.user.link3Vertices = get(handles.user.link3Patch, 'Vertices')';
handles.user.link3Vertices(4,:) = ones(1, size(handles.user.link3Vertices,2));
handles.user.link4Patch = makeLink4(handles.axes_arm, [.9 .9 .9]);
handles.user.link4Vertices = get(handles.user.link4Patch, 'Vertices')';
handles.user.link4Vertices(4,:) = ones(1, size(handles.user.link4Vertices,2));
handles.user.link5Patch = makeLink5(handles.axes_arm, [.95 .95 0]);
handles.user.link5Vertices = get(handles.user.link5Patch, 'Vertices')';
handles.user.link5Vertices(4,:) = ones(1, size(handles.user.link5Vertices,2));

% Move the arm into the HOME position.
updateArm(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotArm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RobotArm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_joint1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jointSliderChange(hObject, handles)


% --- Executes during object creation, after setting all properties.
function slider_joint1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jointSliderChange(hObject, handles)


% --- Executes during object creation, after setting all properties.
function slider_joint2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jointSliderChange(hObject, handles)


% --- Executes during object creation, after setting all properties.
function slider_joint3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint4_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jointSliderChange(hObject, handles)


% --- Executes during object creation, after setting all properties.
function slider_joint4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint5_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jointSliderChange(hObject, handles)


% --- Executes during object creation, after setting all properties.
function slider_joint5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_COM_Callback(hObject, eventdata, handles)
% hObject    handle to edit_COM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_COM as statictextx
%        str2double(get(hObject,'String')) returns contents of edit_COM as a double


% --- Executes during object creation, after setting all properties.
function edit_COM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_COM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Edit controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Close any open connections first
open_ports = instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
    fclose(open_ports);
end

% Open a serial connection to the robot arm.
handles.user.port=serial('COM9','Baudrate',9600);
fopen(handles.user.port);

% Remember, anytime you modify the handles structure update it!
% Anything you add should go into the handles.user area, for example
% handles.user.serialRobotArm might be a name you could use :)
guidata(hObject, handles);


% --- Executes on button press in pushbutton_close.
function pushbutton_close_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('DONE: Closed serial connect.\n');

open_ports = instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
    fclose(open_ports);
end


% --- Executes on slider movement.
function slider_gripper_Callback(hObject, eventdata, handles)
% hObject    handle to slider_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Send a gripper command to the serial robot arm if open.
open_ports = instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
    fprintf(handles.user.port,'GRIPPER %d',handles.user.gripperAngle);
end


% --- Executes during object creation, after setting all properties.
function slider_gripper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function jointSliderChange(hObject, handles)
handles.user.jointAngles(1) = round(get(handles.slider_joint1,'Value'));
handles.user.jointAngles(2) = round(get(handles.slider_joint2,'Value'));
handles.user.jointAngles(3) = round(get(handles.slider_joint3,'Value'));
handles.user.jointAngles(4) = round(get(handles.slider_joint4,'Value'));
handles.user.jointAngles(5) = round(get(handles.slider_joint5,'Value'));

jointAnglesStr = sprintf('%d %d %d %d %d', handles.user.jointAngles);
set(handles.text_current_joint_angles, 'String', jointAnglesStr);

updateArm(hObject, handles)
guidata(hObject, handles);


function updateArm(hObject, handles)
% Create the five homogeneous transformation matrices
[A1,A2,A3,A4,A5] = makeHomogeneousTransformations(...
    handles.user.jointAngles(1),...
    handles.user.jointAngles(2),...
    handles.user.jointAngles(3),...
    handles.user.jointAngles(4),...
    handles.user.jointAngles(5));

% Use the A matricies to form the T0_n matricies
T0_1 = A1;
T0_2 = A1 * A2;
T0_3 = A1 * A2 * A3;
T0_4 = A1 * A2 * A3 * A4;
T0_5 = A1 * A2 * A3 * A4 * A5;

% Use the T matricies to transform the patch vertices
link1verticesWRTground = T0_1 * handles.user.link1Vertices;
link2verticesWRTground = T0_2 * handles.user.link2Vertices;
link3verticesWRTground = T0_3 * handles.user.link3Vertices;
link4verticesWRTground = T0_4 * handles.user.link4Vertices;
link5verticesWRTground = T0_5 * handles.user.link5Vertices;

% Update the patches with the new vertices.
set(handles.user.link1Patch,'Vertices', link1verticesWRTground(1:3,:)');
set(handles.user.link2Patch,'Vertices', link2verticesWRTground(1:3,:)');
set(handles.user.link3Patch,'Vertices', link3verticesWRTground(1:3,:)');
set(handles.user.link4Patch,'Vertices', link4verticesWRTground(1:3,:)');
set(handles.user.link5Patch,'Vertices', link5verticesWRTground(1:3,:)');

% Update x, y, and z using the gripper (end effector) origin.
dhOrigin = [0 0 0 1]';
eeWRTground = T0_5 * dhOrigin;
set(handles.textx, 'String', sprintf('%.3f"', eeWRTground(1)));
set(handles.texty, 'String', sprintf('%.3f"', eeWRTground(2)));
set(handles.textz, 'String', sprintf('%.3f"', eeWRTground(3)));

% Making sure the joint angles are integers before sending to robot (should already be ints).
handles.user.jointAngles(1) = round(handles.user.jointAngles(1));
handles.user.jointAngles(2) = round(handles.user.jointAngles(2));
handles.user.jointAngles(3) = round(handles.user.jointAngles(3));
handles.user.jointAngles(4) = round(handles.user.jointAngles(4));
handles.user.jointAngles(5) = round(handles.user.jointAngles(5));

% Send a position command to the serial robot if open.
open_ports = instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
    fprintf(handles.user.port,'POSITION %d %d %d %d %d',handles.user.jointAngles);
end

guidata(hObject, handles);
