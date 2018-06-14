% 2012/09/20
% Alpha Version 1.0
% 计算三维声压和声强分布

% 每次计算的声场点数，可任意设置
SectorPoint = 101;
Utemp = U;
U = exp(j*U);
[XSound,YSound,ZSound] = meshgrid(-XMax:XStep:XMax,-YMax:YStep:YMax,ZMax);
XGrid = XSound;
YGrid = YSound;
[d1,d2] = size(XSound);

SoundPoint = d1*d2;
NumSector = ceil(SoundPoint/SectorPoint);
ResPoint = mod(NumSector*SectorPoint,SoundPoint);

XSound = reshape(XSound,SoundPoint,1);
XSound = [XSound;zeros(ResPoint,1)];
YSound = reshape(YSound,SoundPoint,1);
YSound = [YSound;zeros(ResPoint,1)];
ZSound = reshape(ZSound,SoundPoint,1);
ZSound = [ZSound;zeros(ResPoint,1)];
DeltaS = repmat(reshape(DeltaS,1,size(DeltaS,1)*size(DeltaS,2)),NumElement*SectorPoint,1);
PResult = [];

for i = 1:NumSector
    % 用于测试计算速度
    i
    
    XSound_i = XSound((i-1)*SectorPoint+1:i*SectorPoint);
    YSound_i = YSound((i-1)*SectorPoint+1:i*SectorPoint);
    ZSound_i = ZSound((i-1)*SectorPoint+1:i*SectorPoint);    
    
    XArray_Field = repmat(XArray,SectorPoint,1);
    YArray_Field = repmat(YArray,SectorPoint,1);
    ZArray_Field = repmat(ZArray,SectorPoint,1);

    XSound_Field = repmat(XSound_i',size(XArray,1)*size(XArray,2),1);
    XSound_Field = reshape(XSound_Field,size(XArray,2),size(XArray,1)*SectorPoint)';

    YSound_Field = repmat(YSound_i',size(YArray,1)*size(YArray,2),1);
    YSound_Field = reshape(YSound_Field,size(YArray,2),size(YArray,1)*SectorPoint)';

    ZSound_Field = repmat(ZSound_i',size(ZArray,1)*size(ZArray,2),1);
    ZSound_Field = reshape(ZSound_Field,size(ZArray,2),size(ZArray,1)*SectorPoint)';

% 求出计算声场声压分布的前向传递矩阵H，表示为HResult
    r = sqrt( (XArray_Field - XSound_Field).^2 + (YArray_Field - YSound_Field).^2 + (ZArray_Field - ZSound_Field).^2 );
    clear XSound_i YSound_i ZSound_i XArray_Field YArray_Field ZArray_Field;
    clear XSound_Field YSound_Field ZSound_Field;
    Heds = exp( -(j * K + Alpha ) .* r) .* DeltaS ./ r;
    clear r;
    HResult = ( j * Rou * USFreq ) .* reshape(sum(Heds,2),size(XArray,1),SectorPoint).';
    clear Heds;
    
% 求出声场中三维声压分布PResult
    P_Temp = HResult * U;
    clear HResult;
    PResult = [PResult;P_Temp];
    clear P_Temp;
end

% 将声压分布从向量形式转换为矩阵形式
P3Dim = PResult(1:SoundPoint);
P3Dim = reshape(P3Dim,d1,d2);

% 将声压化成声强和热量，写入文件
P3DimAbs = abs(P3Dim);
I3Dim = P3DimAbs.^2 / ( 2 * Rou * c * 1e+4 );
figure;mesh(XGrid,YGrid,I3Dim);
save I3Dim I3Dim;
Q3Dim = I3Dim .* 2 * Alpha / 100 * 1e+6;
save Q3Dim Q3Dim;
U = Utemp;