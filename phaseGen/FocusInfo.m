% 2012/09/20
% Alpha Version 1.0
% 输入焦点位置、声压信息和声场范围

% 焦点数量，本版本仅限单焦点、双焦点和四焦点
NumFocus = 1;

% 焦点三维坐标，单位：m
% 焦点Z轴坐标，以曲率半径所在平面为0，靠近换能器方向为正，远离换能器方向为负
% 焦点坐标仅需输入一组，若为双焦点，另一焦点为其关于原点对称的焦点；
% 若为四焦点，则为关于X轴和Y轴对称的焦点
%XFocus = 0.008*cos(pi/6);
%YFocus = 0.008*sin(pi/6);
%ZFocus = 0.000;

% 设定声强以及换算后的声压，其中，声压未包含相位信息
I = 3.33e5;
P = sqrt(2 * Rou * c * I);

%声场范围，单位：m
XMax = 0.01;
XStep = 0.0005;

YMax = 0.01;
YStep = 0.0005;

ZRange = 0.000;
ZMax = ZRange;
ZMin = ZRange;
ZStep = -0.0005;

save('FocusInfo','NumFocus','P');