function U = ExciteEfficiency(U,H,PControl);
%**************************************************************************
%**************************************************************************
%*  时间：2006年6月14日                                                    *
%*  函数目的：通过激励效率算法求出所需的激励向量U                            *
%*  函数输入：伪逆算法求出的激励向量U                                       * 
%*  续上，H矩阵，控制点声压向量PControl                                     *
%*  函数输出：阵元激励向量U                                                 *
%**************************************************************************
%**************************************************************************

%主要因为效率不能达到0.99，所以求尽可能最大的效率
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

%将激励向量的幅值和相位写入excel文件
 AmpU = abs(U);
 AngU = angle(U);
%  xlswrite('amp.xls',AmpU);
%  xlswrite('angle.xls',AngU);
% AngleD = AngU * 180 / pi;
% AngleT = (AngleD + 180) / 1.40625;
% xlswrite('AngleD.xls',AngleD);
% xlswrite('AngleT.xls',AngleT);