function  testout = cursorfunc(~,event_obj)
%TESTFUNC 此处显示有关此函数的摘要
%   此处显示详细说明
global data Ticks ScanMode
if ScanMode >2 %2d scan
    HIFUxvec = Ticks(1,1):Ticks(1,2):Ticks(1,3);
    HIFUyvec = Ticks(2,1):Ticks(2,2):Ticks(2,3);
    y = event_obj.Position(1);%表示列
    x = event_obj.Position(2);
    xvec = data(:,1);
    yvec = data(:,2);
    zvec = data(:,3);
    Pvec = data(:,4);
    [~,indx] = min(abs(HIFUxvec - x));
    indx = indx(1);
    [~,indy] = min(abs(HIFUyvec - y));
    indy = indy(1);    
    ind = (indy-1)*length(HIFUxvec)+indx;
    switch ScanMode
        case 3
            row = 'y';
            col = 'z';
        case 4
            row = 'x';
            col = 'z';
        case 5
            row = 'x';
            col = 'y';
    end
    testout = {sprintf('HIFU: %s=%.1f, %s=%.1f',row,HIFUxvec(indx),col,HIFUyvec(indy)),...
        sprintf('KYCT: x=%.3f, y=%.3f, z=%.3f', xvec(ind),yvec(ind),zvec(ind)),...
        sprintf('P: %.2f MPa',Pvec(ind))};
else %1D scan
    HIFUxvec = Ticks(1,:);
    x = event_obj.Position(1);%表示列
    indx = find(HIFUxvec == x);
    xvec = data(:,1);
    yvec = data(:,2);
    zvec = data(:,3);
    Pvec = data(:,4);
    xname = char('x'+ScanMode);
    testout = {sprintf('HIFU: %s=%.1f',xname,HIFUxvec(indx)),...
        sprintf('KYCT: x=%.3f, y=%.3f, z=%.3f', xvec(indx),yvec(indx),zvec(indx)),...
        sprintf('P: %.2f MPa',Pvec(indx))};
end
end

