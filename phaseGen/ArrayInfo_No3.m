% 2012/09/20
% Alpha Version 1.0
% ������������

%Բ����Ԫ�뾶����λ��m
ElementR = 0.005;

%�뾶���ַ���
NumRadius = 20;

%�ǶȻ��ַ���
NumAngle = 20;

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

%�������Ԫ����
NumElement = sum(NumRingElement);

%ÿ����Ԫ��X�ᡢZ��нǣ���λ��rad    
AngleXElement = [];
AngleZElement = [];
R = [];
for i = 1:NumRing
    AngleXElement = [AngleXElement AngleFirstX(i):2*pi/NumRingElement(i):2*pi/NumRingElement(i)*(NumRingElement(i) - 1) + AngleFirstX(i)];
    AngleZElement = [AngleZElement AngleZ(i)*ones(1,NumRingElement(i))];%[��һ���Ƕȣ��ڶ����Ƕȡ�����]
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