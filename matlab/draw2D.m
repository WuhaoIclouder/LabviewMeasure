clear all
data=load('Data2.txt');
Ticks = [-15,1,15,31;-8,0.5,8,33];
ScanMode = 3;
%% begin
global data Ticks ScanMode
fig = figure;
resizefactor = 4;
xvec = data(:,1);
yvec = data(:,2);
zvec = data(:,3);
Pvec = data(:,4);
HIFUxvec = Ticks(1,1):Ticks(1,2):Ticks(1,3);
HIFUyvec = Ticks(2,1):Ticks(2,2):Ticks(2,3);
HIFUxnum = Ticks(1,4);
HIFUynum = Ticks(2,4);
Pmap = reshape(Pvec,HIFUxnum,HIFUynum);%反过来
h1 = imagesc(HIFUyvec,HIFUxvec,Pmap);%反过来
dcm_obj = datacursormode(fig);
set(dcm_obj,'UpdateFcn',@cursorfunc); 
switch ScanMode
    case 3
        labely = 'Y in HIFU Coord (mm)';
        labelx = 'Z in HIFU Coord (mm)';
    case 4
        labely = 'X in HIFU Coord (mm)';
        labelx = 'Z in HIFU Coord (mm)';
    case 5
        labely = 'X in HIFU Coord (mm)';
        labelx = 'Y in HIFU Coord (mm)';
end
xlabel(labelx);
ylabel(labely);
colormap('jet');
hcb = colorbar;
ylabel(hcb,'Acousctic pressure (MPa)')

