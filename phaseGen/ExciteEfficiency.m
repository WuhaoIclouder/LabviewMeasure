function U = ExciteEfficiency(U,H,PControl);
%**************************************************************************
%**************************************************************************
%*  ʱ�䣺2006��6��14��                                                    *
%*  ����Ŀ�ģ�ͨ������Ч���㷨�������ļ�������U                            *
%*  �������룺α���㷨����ļ�������U                                       * 
%*  ���ϣ�H���󣬿��Ƶ���ѹ����PControl                                     *
%*  �����������Ԫ��������U                                                 *
%**************************************************************************
%**************************************************************************

%��Ҫ��ΪЧ�ʲ��ܴﵽ0.99�������󾡿�������Ч��
TempEfficiency = 0;
N = length(U);
HTran = H';
TempNum = 1;
Efficiency = ( sum( ( abs(U) ).^2 ) ) / ( N * ( max( abs(U) ) )^2 );
TempEfficiency(TempNum) = Efficiency;
while Efficiency <= 0.99
    TempNum = TempNum + 1;
	Uw = 1 ./ abs(U);
	W = sparse(1:N,1:N,Uw);
	HTran = W * HTran;
	HPlus = HTran * inv( H * HTran );
	U = HPlus * PControl.';
	Efficiency = ( sum( (abs(U) ).^2 ) ) / ( N * ( max( abs(U) ) )^2 );
    TempEfficiency(TempNum) = Efficiency;
end

%�����������ķ�ֵ����λд��excel�ļ�
 AmpU = abs(U);
 AngU = angle(U);
%  xlswrite('amp.xls',AmpU);
%  xlswrite('angle.xls',AngU);
% AngleD = AngU * 180 / pi;
% AngleT = (AngleD + 180) / 1.40625;
% xlswrite('AngleD.xls',AngleD);
% xlswrite('AngleT.xls',AngleT);