% ����Բ����Ԫ�ʻ��ηֲ��ĸ�����������������������ά��ѹ�ֲ�������۽����������
% ��λʱʹ����ģʽɨ�跽������˶��������Ԫ�ļ��ηֲ��;۽�ģʽ�������ƣ����ڵ�����
% ģʽ�����зֲ������������ã�����ż������ģʽ���ԣ�������Ԫ�ԳƷֲ��������
% z=0 Ϊ��ƽ�棬z����ʾԶ�뻻������z����ʾ����������

% clear all;
% clc;
tic;

%���徫�ȣ�12λС��
format long;

%% ��Ҫ�޸ĵĵط�

focusX = focusX*1e-3;
focusY = focusY*1e-3;
focusZ = focusZ*1e-3;
% width = 10e-3;% xy����Χ
% xRes = 1e-3;% xy����ֱ���
% zMin = -25e-3;
% zMax = 25e-3;% z����Χ
% zRes = 1e-3;
%% ����Ĳ��øľͺ�
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
A110txtname=fullfile(pathname,filename);%�����ļ���·��
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
 % ͨ��ģʽɨ�跽������۽������������λ�ֲ�U
[U PControl G] = PsuedoInverse(H,P,Rou,c);
U = ExciteEfficiency(U,H,PControl);
U = angle(U);
% Intensity3D
U=floor((U+pi)/2/pi*256);%����λ��Ϊ����ʹ��
U=255-U;
phaseChange = [25,53,56:64];
U(phaseChange) = 255-U(phaseChange);


phasemat = [phasemat;U'];
% phasemat(:,65)=[];
save phasemat phasemat;%���浽.mat�ļ��Ա�����ʹ��

% phasemat = BitReverse(phasemat);
if PHSE
    [phsfilename,phsfilepath] = uigetfile('*.txt','ѡ����λ����ļ�');
    phsedata = load(fullfile(phsfilepath,phsfilename));
    phasemat = phasemat+phsedata';
    phasemat = mod(phasemat,255);
end

if BIGF
    [phsfilename,phsfilepath] = uigetfile('*.txt','ѡ��bigfocus�ļ�');
    phsedata = load(fullfile(phsfilepath,phsfilename));
    phasemat = phasemat+phsedata';
    phasemat = mod(phasemat,255);
end

fid=fopen(A110txtname,'w') ;  %���ļ�
% for i = 1:numel(phasemat)
fprintf(fid,'%d\r\n',phasemat);
% end

fclose(fid);
toc