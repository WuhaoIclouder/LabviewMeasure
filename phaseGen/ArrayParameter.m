%% 110��Ԫ
%���������ʰ뾶����λ��m
SphericalR = 0.115;

%��Ԫ����
NumRing = 5;

%ÿ����Ԫ����
NumRingElement = [1,6,13,19,25];

%ÿ����Z��нǣ���λ��rad
AngleZ = [0,5.5520,11.1041,16.3868,21.6696] /180*pi;

%ÿ������Ԫ��X��нǣ���λ��rad
AngleFirstX = [0, 8.9153, 22.0359, 15.2772, 42.8234] /180*pi;

%% 144��Ԫ
% %���������ʰ뾶����λ��m
% SphericalR = 0.180;
% 
% %��Ԫ����
% NumRing = 8;
% 
% %ÿ����Ԫ����
% NumRingElement = [18 18 18 18 18 18 18 18];
% 
% %ÿ����Z��нǣ���λ��rad
% AngleZ = [11.40 14.30 16.80 18.60 20.70 22.50 24.60 26.40]./180*pi;
% 
% %ÿ������Ԫ��X��нǣ���λ��rad
% for i = 1: NumRing
%     if (rem(i,2)==0) 
%        AngleFirstX(i) = pi/NumRingElement(i);
%     else
%        AngleFirstX(i) = 0;
%     end        
% end
 


