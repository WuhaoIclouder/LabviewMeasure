%% 110阵元
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

%% 144阵元
% %凹球面曲率半径，单位：m
% SphericalR = 0.180;
% 
% %阵元环数
% NumRing = 8;
% 
% %每环阵元数量
% NumRingElement = [18 18 18 18 18 18 18 18];
% 
% %每环与Z轴夹角，单位：rad
% AngleZ = [11.40 14.30 16.80 18.60 20.70 22.50 24.60 26.40]./180*pi;
% 
% %每环首阵元与X轴夹角，单位：rad
% for i = 1: NumRing
%     if (rem(i,2)==0) 
%        AngleFirstX(i) = pi/NumRingElement(i);
%     else
%        AngleFirstX(i) = 0;
%     end        
% end
 


