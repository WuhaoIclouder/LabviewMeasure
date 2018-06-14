% 2012/09/20
% Alpha Version 1.0
% 输入组织参数

%组织密度，单位：kg/m^3
Rou = 1000;

%超声频率，单位：Hz
Freq = 1.360;
USFreq = Freq * 1e6;

%组织声速，单位：m/s
c = 1500;

%衰减系数，单位：Np/m
Atten = 0;
Alpha = Atten * Freq;

%波数
K = 2 * pi * USFreq / c;