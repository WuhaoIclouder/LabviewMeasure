%% input
XStep = 0.2;
XMin = -10;
XMax = 10;
YMin = -20;
YStep = 0.4;
YMax = 20;
shiftpoint = [0,0,0];
MidPoint = [100 200 300];
xaxis = [1 0 0];
zaxis = [0,0,1];

%% creat Mat
% MidPoint = [MidPoint.';1];
SPx = XMin:XStep:XMax;
SPy = YMin:YStep:YMax;
[SPxm,SPym] = ndgrid(SPx,SPy);
SPxm = reshape(SPxm,1,numel(SPxm));
SPym = reshape(SPym,1,numel(SPym));
SPmat = repmat([0,0,0,1].',1,length(SPxm));
SPmat(1,:) = SPxm;
SPmat(2,:) = SPym;
% SPmat = SPmat+MidPoint;
%% rotate 
yaxis = cross(zaxis,xaxis);
xaxisu = xaxis/norm(xaxis);
yaxisu = yaxis/norm(yaxis);
zaxisu = zaxis/norm(zaxis);
R = [xaxisu,0;yaxisu,0;zaxisu,0;0,0,0,1];%Ðý×ª¾ØÕó
T = [1,0,0,shiftpoint(1);0,1,0,shiftpoint(2);0,0,1,shiftpoint(3);0,0,0,1];
%%
TSPmat = R*T*SPmat;
TSPmat = TSPmat.';