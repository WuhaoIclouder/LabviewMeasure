% 2012/09/20
% Alpha Version 1.0
% ��������Ŀ�ģ����������ÿ����Ԫ��ɢ��Ϊ����Դ������NumRadiusΪ�ذ뾶���򻮷�
% �ķ�����NumAngleΪ��Բ�ܻ��ֵĽǶȣ�DeltaSΪÿ������Դ�������

function [XDiv YDiv ZDiv DeltaS XYZVectorArrayCor] = ArrayDiv(ElementR,NumRadius,NumAngle);
   
% XDiv,YDiv,ZDivΪNumRadius*NumAngleά
RadiusDiv = ElementR / NumRadius - ElementR / NumRadius / 2 : ElementR / NumRadius : ElementR - ElementR / NumRadius / 2;
AngleDiv = 2 * pi / NumAngle : 2 * pi / NumAngle : 2 * pi;
XDiv = RadiusDiv' * cos(AngleDiv);
YDiv = RadiusDiv' * sin(AngleDiv);
ZDiv = zeros(NumRadius,NumAngle);

% �������Դ�����
RadiusDiv_plus = ElementR / NumRadius : ElementR / NumRadius : ElementR;
RadiusDiv_minus = 0 : ElementR / NumRadius : ElementR - ElementR / NumRadius;
DeltaS = 1 / NumAngle * pi * (RadiusDiv_plus.^2 - RadiusDiv_minus.^2);
DeltaS = repmat(DeltaS',1,NumAngle);

% ��XDiv,YDiv,ZDiv���������,�����ں���������任����������
XShape = reshape(XDiv,1,NumRadius*NumAngle);
YShape = reshape(YDiv,1,NumRadius*NumAngle);
ZShape = reshape(ZDiv,1,NumRadius*NumAngle);
XYZVectorArrayCor = [XShape;YShape;ZShape];