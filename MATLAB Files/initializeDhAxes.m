function initializeDhAxes

% Begin: Setup for this stand alone version that will not go into the GUI.
close all
handles.axes_arm = axes;
handles.user.jointAngles = [0 90 0 -90 90]; % Home position.
handles.user.jointAngles = [0 0 0 0 0];
handles.user.jointAngles = [-5 135 20 -45 90];

%  End : Setup for this stand alone version that will not go into the GUI.



% Begin: Code that can go into the GUI's opening function.
clc

% Prepare the arm axes_arm
view(handles.axes_arm, [-50 -50 50]);
axis(handles.axes_arm, [-13 10 -8 8 -3 14.5]);
grid on
xlabel('x')
ylabel('y')
zlabel('z')

% Create vertices for all the patches
makeLink0(handles.axes_arm, [.5 .5 .5]);  % Doesn't move. No handles needed.
% Save handles to the patch objects.
% Save references to the vertices of each patch, make points 4x1 not 3x1.
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
% End: Code that can go into your GUI's opening function.

updateArm('unused', handles);

end

function updateArm(hObject, handles)

% TODO: Make sure the handles.user.jointAngles values are set.


% Create the five homogeneous transformation matrices.
[A1,A2,A3,A4,A5] = makeHomogeneousTransformations(handles.user.jointAngles(1),...
    handles.user.jointAngles(2),handles.user.jointAngles(3),handles.user.jointAngles(4),...
    handles.user.jointAngles(5));

% Use the A matricies to form the T0_n matricies.
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

% Update the patches with the new vertices
set(handles.user.link1Patch,'Vertices', link1verticesWRTground(1:3,:)');
set(handles.user.link2Patch,'Vertices', link2verticesWRTground(1:3,:)');
set(handles.user.link3Patch,'Vertices', link3verticesWRTground(1:3,:)');
set(handles.user.link4Patch,'Vertices', link4verticesWRTground(1:3,:)');
set(handles.user.link5Patch,'Vertices', link5verticesWRTground(1:3,:)');

% Optional code (if you want to display the XYZ of the gripper).
% Update x, y, and z using the gripper (end effector) origin.
dhOrigin = [0 0 0 1]';
gripperWRTground = T0_5 * dhOrigin;
fprintf('(%.3f, %.3f, %.3f)\n', gripperWRTground(1), gripperWRTground(2), gripperWRTground(3));

end
