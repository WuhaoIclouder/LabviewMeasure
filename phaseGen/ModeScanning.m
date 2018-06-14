% 2012/09/20
% Alpha Version 1.0
% ��������Ŀ��������ģʽɨ�跨����۽������������λU�����汾������������ģʽ��
% �����㡢˫������Ľ��㣬���У��������Ϊ����λ�ã�˫����Ϊ����ԭ��ԳƵĽ���
% ģʽ���Ľ���Ϊ����X���Y��ԳƵĽ���ģʽ��

function AngU = ModeScanning(H,XFocus,YFocus,ZFocus);

TissueInfo;
load FocusInfo;
% ����ģʽɨ�跽������������λU
switch NumFocus
	%������
	case 1
	AngU = angle(H') + angle(P);
	AmpU = P / (H * (H./abs(H))');
	%U = AmpU * exp(j*AngU);
	%˫����
	case 2
	H11 = H(1:10);
    H12 = H(21:32);
    H13 = H(45:60);
    H14 = H(77:94);
    H1 = [H11 H12 H13 H14];
            
    H21 = H(11:20);
    H22 = H(33:44);
    H23 = H(61:76);
    H24 = H(95:112);
    H2 = [H21 H22 H23 H24];
            
    H_plane = H1 - H2;
    AngU1 = angle(H_plane') + angle(P);
    AmpU1 = P / (H_plane * (H_plane./abs(H_plane))');
    U1 = AmpU1 * exp(j*AngU1);
    U2 = -U1;
    U11 = U1(1:10); U12 = U1(11:22); U13 = U1(23:38); U14 = U1(39:56);
    U21 = U2(1:10); U22 = U2(11:22); U23 = U2(23:38); U24 = U2(39:56);
            
    U = [U11;U21;U12;U22;U13;U23;U14;U24];
    %�Ľ���  
    case 4
    H11 = H(:,1:5);
    H12 = H(:,21:26);
    H13 = H(:,45:52);
    H14 = H(:,77:85);
    H1 = [H11 H12 H13 H14];
  
    H21 = fliplr(H(:,6:10));
    H22 = fliplr(H(:,27:32));
    H23 = fliplr(H(:,53:60));
    H24 = fliplr(H(:,86:94));
    H2 = [H21 H22 H23 H24];
  
    H31 = H(:,11:15);
    H32 = H(:,33:38);
    H33 = H(:,61:68);
    H34 = H(:,95:103);
    H3 = [H31 H32 H33 H34];
  
    H41 = fliplr(H(:,16:20));
    H42 = fliplr(H(:,39:44));
    H43 = fliplr(H(:,69:76));
    H44 = fliplr(H(:,104:112));
    H4 = [H41 H42 H43 H44];
  
    H_plane = H1 - H2 + H3 - H4;
    AngU1 = angle(H_plane') + angle(P);
    AmpU1 = P / (H_plane * (H_plane./abs(H_plane))');
    U1 = AmpU1 * exp(j*AngU1);
    U2 = -U1;
    U11 = U1(1:5); U12 = U1(6:11); U13 = U1(12:19); U14 = U1(20:28);
    U21 = flipud(U2(1:5)); U22 = flipud(U2(6:11)); U23 = flipud(U2(12:19)); U24 = flipud(U2(20:28));
    U31 = U11; U32 = U12; U33 = U13; U34 = U14;
    U41 = U21; U42 = U22; U43 = U23; U44 = U24;
    U = [U11;U21;U31;U41;U12;U22;U32;U42;U13;U23;U33;U43;U14;U24;U34;U44];
 
end
save AmpU AmpU;
    
% AmpU = abs(U);
% AngU = angle(U);
% 
% %���������G
% G = P' * P / ( U' * U );
% save gain G;

%xlswrite('amp.xls',AmpU);
%xlswrite('angle.xls',AngU);
%AngleD = AngU * 180 / pi;
%AngleT = ceil((AngleD + 180) / 1.40625);
%xlswrite('AngleD.xls',AngleD);
%dlmwrite('AngleT.txt','precision','%.0f','newline', 'pc');