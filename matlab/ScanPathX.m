clear all
%% input
XStep = 0.4;
XMin = -6;
XMax = 6;
shiftpoint = [0,0,0];
MidPoint = [107.3 17.6 238.4];
xaxis = [0 4 4];
zaxis = [1,0,0];

%% creat Mat
% MidPoint = [MidPoint.';1];
SPx = XMin:XStep:XMax;
SPmat = repmat([0,0,0,1].',1,length(SPx));
SPmat(1,:) = SPx;
% SPmat = SPmat+MidPoint;
%% rotate 
yaxis = cross(zaxis,xaxis);
xaxisu = xaxis/norm(xaxis);
yaxisu = yaxis/norm(yaxis);
zaxisu = zaxis/norm(zaxis);
xaxisu = cross(yaxis,zaxis)/norm(cross(yaxis,zaxis));
figure;plot3([0,xaxisu(1)],[0,xaxisu(2)],[0,xaxisu(3)],'r');
hold on;
plot3([0,yaxisu(1)],[0,yaxisu(2)],[0,yaxisu(3)],'g');
hold on;
plot3([0,zaxisu(1)],[0,zaxisu(2)],[0,zaxisu(3)],'b');
R = [xaxisu,0;yaxisu,0;zaxisu,0;0,0,0,1];%Ðý×ª¾ØÕó
T = [1,0,0,shiftpoint(1);0,1,0,shiftpoint(2);0,0,1,shiftpoint(3);0,0,0,1];
%%
TSPmat = inv(R)*inv(T)*SPmat;
TSPmat = TSPmat.';
TSPmat = TSPmat(:,1:3);
MidPoint = repmat(MidPoint,size(TSPmat,1),1);
TSPmat = TSPmat+MidPoint;
