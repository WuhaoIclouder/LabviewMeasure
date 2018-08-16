% 用于圆形阵元呈环形分布的各类球面相控阵计算声场的三维声压分布。计算聚焦所需的理论
% 相位时使用了模式扫描方法，因此对相控阵阵元的几何分布和聚焦模式有所限制，对于单焦点
% 模式，所有分布的相控阵均适用；对于偶数焦点模式而言，仅限阵元对称分布的相控阵
% z=0 为焦平面，z负表示远离换能器，z正表示靠近换能器

% clear all;
% clc;
tic;

%定义精度，12位小数
format long;

%% 需要修改的地方

focusX = focusX*1e-3;
focusY = focusY*1e-3;
focusZ = focusZ*1e-3;
% width = 10e-3;% xy方向范围
% xRes = 1e-3;% xy方向分辨率
% zMin = -25e-3;
% zMax = 25e-3;% z方向范围
% zRes = 1e-3;
%% 下面的不用改就好
TissueInfo;
switch transducer
    case 1
        trans_name = 'ANo1';
        ElementR = 0.005;
        NumRadius = 20;
        NumAngle = 20;
        freq = 1.37e6;
    case 2
        trans_name = 'ANo3';
        ElementR = 0.005;
        NumRadius = 20;
        NumAngle = 20;  
        freq = 1.37e6;        
    case 3
        trans_name = 'BNo1';
        ElementR = 0.005;
        NumRadius = 20;
        NumAngle = 20;
        freq = 1.37e6;        
end
filename = [trans_name,filename];
TDATA = load([trans_name,'.txt']);
A110txtname=fullfile(pathname,filename);%生成文件的路径
mkdir(pathname);
delete(A110txtname);

FocusInfo;
point_num=0;


% fid=fopen(A110txtname,'wt');
% str = '<sequences>';
% fprintf(fid, '%s\n', str); 
phasemat = [];
[XDiv YDiv ZDiv DeltaS XYZVectorArrayCor] = ArrayDiv(ElementR,NumRadius,NumAngle);
[H,XArray,YArray,ZArray] = accumu(XYZVectorArrayCor,DeltaS,TDATA,NumRadius,NumAngle,...
            focusX, focusY, focusZ,freq,Rou,Alpha,c);
 % 通过模式扫描方法求出聚焦所需的理论相位分布U
[U PControl G] = PsuedoInverse(H,P,Rou,c);
U = ExciteEfficiency(U,H,PControl);
U = angle(U);
% Intensity3D
U=floor((U+pi)/2/pi*256);%将相位化为整数使用
U=255-U;
phaseChange = [25,53,56:64];
U(phaseChange) = 255-U(phaseChange);


phasemat = [phasemat;U'];
% phasemat(:,65)=[];
save phasemat phasemat;%保存到.mat文件以便其他使用

% phasemat = BitReverse(phasemat);
if PHSE
    [phsfilename,phsfilepath] = uigetfile('*.txt','选择相位误差文件');
    phsedata = load(fullfile(phsfilepath,phsfilename));
    phasemat = phasemat+phsedata';
    phasemat = mod(phasemat,255);
end

if BIGF
    [phsfilename,phsfilepath] = uigetfile('*.txt','选择bigfocus文件');
    phsedata = load(fullfile(phsfilepath,phsfilename));
    phasemat = phasemat+phsedata';
    phasemat = mod(phasemat,255);
end

fid=fopen(A110txtname,'w') ;  %打开文件
% for i = 1:numel(phasemat)
fprintf(fid,'%d\r\n',phasemat);
% end

fclose(fid);
toc