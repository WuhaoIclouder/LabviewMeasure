% 2012/09/20
% Alpha Version 1.0
% 本函数的目的：将相控阵内每个阵元离散化为点声源，其中NumRadius为沿半径方向划分
% 的份数，NumAngle为沿圆周划分的角度，DeltaS为每个点声源的面积。

function [XDiv YDiv ZDiv DeltaS XYZVectorArrayCor] = ArrayDiv(ElementR,NumRadius,NumAngle);
   
% XDiv,YDiv,ZDiv为NumRadius*NumAngle维
RadiusDiv = ElementR / NumRadius - ElementR / NumRadius / 2 : ElementR / NumRadius : ElementR - ElementR / NumRadius / 2;
AngleDiv = 2 * pi / NumAngle : 2 * pi / NumAngle : 2 * pi;
XDiv = RadiusDiv' * cos(AngleDiv);
YDiv = RadiusDiv' * sin(AngleDiv);
ZDiv = zeros(NumRadius,NumAngle);

% 计算点声源的面积
RadiusDiv_plus = ElementR / NumRadius : ElementR / NumRadius : ElementR;
RadiusDiv_minus = 0 : ElementR / NumRadius : ElementR - ElementR / NumRadius;
DeltaS = 1 / NumAngle * pi * (RadiusDiv_plus.^2 - RadiusDiv_minus.^2);
DeltaS = repmat(DeltaS',1,NumAngle);

% 将XDiv,YDiv,ZDiv变成行向量,有利于后续的坐标变换的批量处理
XShape = reshape(XDiv,1,NumRadius*NumAngle);
YShape = reshape(YDiv,1,NumRadius*NumAngle);
ZShape = reshape(ZDiv,1,NumRadius*NumAngle);
XYZVectorArrayCor = [XShape;YShape;ZShape];