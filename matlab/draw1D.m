clear all
% data=load('Data1.txt');
% Ticks = [-20:0.5:20;-20:0.5:20];
% ScanMode = 0;
%% begin
global data Ticks ScanMode
fig = figure;
resizefactor = 4;
xvec = data(:,1);
yvec = data(:,2);
zvec = data(:,3);
Pvec = data(:,4);
HIFUxvec = Ticks(1,:);
h1 = plot(HIFUxvec,Pvec);
dcm_obj = datacursormode(fig);
set(dcm_obj,'UpdateFcn',@cursorfunc); 
switch ScanMode
    case 0
        labelx = 'X in HIFU Coord (mm)';
    case 1
        labelx = 'Y in HIFU Coord (mm)';
    case 2
        labelx = 'Z in HIFU Coord (mm)';
end
xlabel(labelx);
ylabel('Acousctic pressure (MPa)');


