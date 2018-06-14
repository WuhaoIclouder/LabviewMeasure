fid = fopen('A652.PHASE','r');
[a n] = fread(fid);
x = 2;
y = 0;
z = 0;
index = (x+5)/0.25*41*65+(y+5)/0.25*65+(z+10)/0.5;
index = index*64+1025;
% U=floor((U+pi)/2/pi*256);%将相位化为整数使用
U = a(index:index+63);
U = U/256*2*pi-pi;
fclose(fid);
save U U;