function [H,XGlobal,YGlobal,ZGlobal] = accumu(XYZVectorArrayCor,DeltaS,TDATA,RadiusNum,AngleNum,...
                    PosXFocus, PosYFocus, PosZFocus,freq,Rou,Alpha,c);
%**************************************************************************
%**************************************************************************
%*  时间：2006/6/16                                                        *
%*  函数目的：求阵元的H矩阵H                                                *
%*  函数输入：XYZVectorArrayCor表示阵元坐标系上每个阵元各微元的三维坐标矩阵    *
%*  续上，DeltaS表示每份微元的面积                                           *
%*  函数输出：H表示阵元的H矩阵                                               *
%**************************************************************************
%**************************************************************************

%重新初始化常量参数，主要是函数中要使用
FocusNum = length(PosXFocus);% CCC
K = 2*pi*freq/c;
%AngleRingR表示每圈阵元与全局坐标系中Z轴的夹角

EleNum = size(TDATA,1);
XGlobal = ones(EleNum,RadiusNum*AngleNum);
YGlobal = ones(EleNum,RadiusNum*AngleNum);
ZGlobal = ones(EleNum,RadiusNum*AngleNum);
for Eleind = 1 : EleNum
    XYZ = TDATA(Eleind,1:3).';
    NORM = TDATA(Eleind,4:6).';
    XYZVectorGlobal = TranferCord(XYZ,NORM,XYZVectorArrayCor);
    %分别提取X/Y/Z向量
    XInstead = XYZVectorGlobal(1,:);
    YInstead = XYZVectorGlobal(2,:);
    ZInstead = XYZVectorGlobal(3,:);
    XGlobal(Eleind,:) = XInstead;
    YGlobal(Eleind,:) = YInstead;
    ZGlobal(Eleind,:) = ZInstead;
    %将向量转变为RadiusNum*AngleNum维的矩阵
    X = reshape(XInstead,RadiusNum,AngleNum);
    Y = reshape(YInstead,RadiusNum,AngleNum);
    Z = reshape(ZInstead,RadiusNum,AngleNum);
    for ControlPoint = 1 : FocusNum;
        r = sqrt( ( X - PosXFocus(ControlPoint) ).^2 + ( Y - PosYFocus(ControlPoint) ).^2 + ( Z - PosZFocus(ControlPoint)).^2 );
        d=0;
        k1 = K;
        k2 = -j * Alpha;
        k = k1 .* r + k2 .* d;
        %He = exp( j * K * r - Alpha1 * d);
        He = exp( -j * k );
        Heds = He .* DeltaS ./ r;
        Hes(ControlPoint,Eleind) = sum(sum(Heds));
    end
end
%算出H矩阵
H = j * Rou * freq .* Hes;
%将每圈阵元第一个阵元角度复位