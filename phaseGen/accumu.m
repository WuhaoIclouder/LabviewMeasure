function [H,XGlobal,YGlobal,ZGlobal] = accumu(XYZVectorArrayCor,DeltaS,TDATA,RadiusNum,AngleNum,...
                    PosXFocus, PosYFocus, PosZFocus,freq,Rou,Alpha,c);
%**************************************************************************
%**************************************************************************
%*  ʱ�䣺2006/6/16                                                        *
%*  ����Ŀ�ģ�����Ԫ��H����H                                                *
%*  �������룺XYZVectorArrayCor��ʾ��Ԫ����ϵ��ÿ����Ԫ��΢Ԫ����ά�������    *
%*  ���ϣ�DeltaS��ʾÿ��΢Ԫ�����                                           *
%*  ���������H��ʾ��Ԫ��H����                                               *
%**************************************************************************
%**************************************************************************

%���³�ʼ��������������Ҫ�Ǻ�����Ҫʹ��
FocusNum = length(PosXFocus);% CCC
K = 2*pi*freq/c;
%AngleRingR��ʾÿȦ��Ԫ��ȫ������ϵ��Z��ļн�

EleNum = size(TDATA,1);
XGlobal = ones(EleNum,RadiusNum*AngleNum);
YGlobal = ones(EleNum,RadiusNum*AngleNum);
ZGlobal = ones(EleNum,RadiusNum*AngleNum);
for Eleind = 1 : EleNum
    XYZ = TDATA(Eleind,1:3).';
    NORM = TDATA(Eleind,4:6).';
    XYZVectorGlobal = TranferCord(XYZ,NORM,XYZVectorArrayCor);
    %�ֱ���ȡX/Y/Z����
    XInstead = XYZVectorGlobal(1,:);
    YInstead = XYZVectorGlobal(2,:);
    ZInstead = XYZVectorGlobal(3,:);
    XGlobal(Eleind,:) = XInstead;
    YGlobal(Eleind,:) = YInstead;
    ZGlobal(Eleind,:) = ZInstead;
    %������ת��ΪRadiusNum*AngleNumά�ľ���
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
%���H����
H = j * Rou * freq .* Hes;
%��ÿȦ��Ԫ��һ����Ԫ�Ƕȸ�λ