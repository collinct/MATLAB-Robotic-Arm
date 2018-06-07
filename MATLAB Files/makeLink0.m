function p = makeLink0(parentAxes, faceColor)
if (nargin == 0)
    parentAxes = gca;
    faceColor = [.7 .7 .7];
elseif (nargin == 1)
    faceColor = [.7 .7 .7];
end
set(parentAxes, 'DataAspectRatio', [1 1 1]);
link0Verts = [-1.375	-0.375	-2.5;
    -1.375	0.375	-2.5;
    0.75	0.375	-2.5;
    0.75	-0.375	-2.5;
    -1.375	-0.375	-0.75;
    -1.375	0.375	-0.75;
    0.75	0.375	-0.75;
    0.75	-0.375	-0.75];
link0Faces = [1 2 3 4;
    1 2 6 5;
    2 3 7 6;
    3 4 8 7;
    4 1 5 8;
    5 6 7 8];
p = patch('Parent', parentAxes, 'Faces',link0Faces,'Vertices',link0Verts,'FaceColor',faceColor);

end