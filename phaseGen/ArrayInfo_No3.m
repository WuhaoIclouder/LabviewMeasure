% 2012/09/20
% Alpha Version 1.0
% 输入相控阵参数

%圆形阵元半径，单位：m
ElementR = 0.005;

%半径划分份数
NumRadius = 20;

%角度划分份数
NumAngle = 20;

%凹球面曲率半径，单位：m
SphericalR = 0.115;

%阵元环数
NumRing = 5;

%每环阵元数量
NumRingElement = [1,6,13,19,25];

%每环与Z轴夹角，单位：rad
AngleZ = [0,5.5520,11.1041,16.3868,21.6696] /180*pi;

%每环首阵元与X轴夹角，单位：rad
AngleFirstX = [0, 8.9153, 22.0359, 15.2772, 42.8234] /180*pi;

%相控阵阵元数量
NumElement = sum(NumRingElement);

%每个阵元与X轴、Z轴夹角，单位：rad    
AngleXElement = [];
AngleZElement = [];
R = [];
for i = 1:NumRing
    AngleXElement = [AngleXElement AngleFirstX(i):2*pi/NumRingElement(i):2*pi/NumRingElement(i)*(NumRingElement(i) - 1) + AngleFirstX(i)];
    AngleZElement = [AngleZElement AngleZ(i)*ones(1,NumRingElement(i))];%[第一环角度，第二环角度。。。]
    R = [R, ones(1,NumRingElement(i))*SphericalR*sin(AngleZ(i))];
end
Z = -cos(AngleZElement)*SphericalR;
X = R.*cos(AngleXElement);
Y = R.*sin(AngleXElement);
Coord = [X.',Y.',Z.'];
Norm = -Coord;
tdata = [Coord,Norm];
save('ANo3.txt','tdata','-ascii')
% save ArrayInfo SphericalR AngleZElement AngleXElement NumElement;