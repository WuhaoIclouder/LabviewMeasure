[Filephse,Pathphse] = uigetfile('*.txt','ѡ����λУ���ļ�');
[Filephs,Pathphs] = uigetfile('*.txt','ѡ����λ�ļ�');
phsefile = fullfile(Pathphse,Filephse);
phsfile = fullfile(Pathphs,Filephs);
phse = load(phsefile);
phs = load(phsfile);
phsp = phse+phs;
phsp = mod(phsp,256);
dlmwrite('big22.txt',phsp,'precision','%u') 

