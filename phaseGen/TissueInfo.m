% 2012/09/20
% Alpha Version 1.0
% ������֯����

%��֯�ܶȣ���λ��kg/m^3
Rou = 1000;

%����Ƶ�ʣ���λ��Hz
Freq = 1.360;
USFreq = Freq * 1e6;

%��֯���٣���λ��m/s
c = 1500;

%˥��ϵ������λ��Np/m
Atten = 0;
Alpha = Atten * Freq;

%����
K = 2 * pi * USFreq / c;