function [e1,e2] = WaveCompare( )
global chn wave1 wave2 time1 time2;
chn = 1;
pathname1 = '.\No3\';
pathname2 = '.\No3_2\';
for ind = 1:64
    data1 = load([pathname1,sprintf('%d.txt',ind)]);
    data2 = load([pathname2,sprintf('%d.txt',ind)]);
    wave1(ind,:) = data1(:,1)';
    time1(ind,:) = data1(:,2)';
    wave2(ind,:) = data2(:,1)';
    time2(ind,:) = data2(:,2)';
end
wave2 = wave2/10*4;
e1 = sum(sum(wave1.^2));
e2 = sum(sum(wave2.^2));
fig = figure();
plot(time1(chn,:),wave1(chn,:),time2(chn,:),wave2(chn,:))
legend('上次测量','本次测量');
title(num2str(chn));
set(fig,'windowkeyreleasefcn',@keyreleasefcn);

end
function keyreleasefcn(h,evt)
    global chn wave1 wave2 time1 time2
    switch evt.Key
        case 'leftarrow'
            chn = chn-1;
        case 'uparrow'
            chn = chn-1;
        case 'downarrow'
            chn = chn+1;
        case 'rightarrow'
            chn = chn+1;
    end
    if chn>64
        chn = 1;
    elseif chn<1
        chn =64;
    end
    figure(h);
    plot(time1(chn,:),wave1(chn,:),time2(chn,:),wave2(chn,:))
    legend('上次测量','本次测量');
    title(num2str(chn));
end    


