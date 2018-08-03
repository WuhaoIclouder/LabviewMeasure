[Filephse,Pathphse] = uigetfile('*.txt','选择相位校正文件');
[Filephs,Pathphs] = uigetfile('*.txt','选择相位文件');
phsefile = fullfile(Pathphse,Filephse);
phsfile = fullfile(Pathphs,Filephs);
phse = load(phsefile);
phs = load(phsfile);
phsp = phse+phs;
phsp = mod(phsp,256);
dlmwrite('big22.txt',phsp,'precision','%u') 

