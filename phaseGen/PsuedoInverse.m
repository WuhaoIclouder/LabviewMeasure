function [U PControl G] = PsuedoInverse(H,P,Rou,c);
%**************************************************************************
%**************************************************************************
%*  时间：2006年6月14日                                                    *
%*  函数目的：通过特征向量法求出控制点声压向量PControl                       *
%*  续上，算出H矩阵的伪逆HPlus，通过伪逆算法求出激励向量U                    *
%*  函数输入：H矩阵，控制点未处理声压向量                                   *
%*  函数输出：阵元激励向量U，控制点声压向量PControl                         *
%*           以及近场增益G                                                *
%**************************************************************************
%**************************************************************************

%HTran表示H矩阵的转置共轭
HTran = H';
%HPlus表示H矩阵的广义逆
HPlus = HTran * inv( H * HTran );
%通过特征向量法求控制点声压的相位
PhaseP = EigenVector(H);
%不采用特征向量法
%N = [0 1 2 3 4 5]';
%PhaseP = pi / 3 + N * 2 * pi / 6;
%采用特征向量法反而会得到不好的结果
PControl = P .* exp( j * PhaseP' );
% PControl = P .* [1 j -1 -j];
%伪逆算法求出U
U = HPlus * PControl.';
%求近场增益GC
PNow = PControl.';
[M,N] = size(H);
ConMulti = N / ( (Rou^2) * (c^2) );
VarMulti = PNow' * PNow / ( PNow' * inv( H * HTran ) * PNow );
G = ConMulti * VarMulti;
save gain G;