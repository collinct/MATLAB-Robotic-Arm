function [ imageObject ] = addImageToAxes( imageFilename, axesHandle, axesWidth )
%ADDIMAGETOAXIS Adds an image to an axes
%   Opens the image filename and adds it to the axes
%   Return the image object
%   If axesWidth = 0 then use images default pixel size

% Open the file to get the imageData
[imageData, map, alphaChannel] = imread(imageFilename);

% Create an image object and make the parent the axes
%imageObject = image(imageData, 'Parent', axesHandle);
imageObject = image(imageData, 'Parent', axesHandle, 'AlphaData', alphaChannel);

% Make unit of the axes 'pixels'
% Visible off
set(axesHandle,'Units','Pixels','Visible','Off');

% Get the current 'Position' of the Axes so that we can use the x and y
currentPosition = get(axesHandle,'Position');

% Get the number of rows and columns of the image
[rows_height, cols_width, depth] = size(imageData);

if axesWidth == 0
    axesWidth = cols_width;
   axesHeight = rows_height;
else
   % Use the axesWidth and aspect ratio to calculate the height
   axesHeight = axesWidth * rows_height/cols_width;
end

% Set the new 'Position' on the axes
set(axesHandle,'Position',[currentPosition(1) currentPosition(2) axesWidth axesHeight]);
end