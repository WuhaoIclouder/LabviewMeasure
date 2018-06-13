function dataprocessKYCT()

    [FileName,PathName] = uigetfile('Data.txt','Select the pressure profile data');
    PData = load(fullfile(PathName,FileName));
    scanmode = [0,0,0];
    for i = 1:3
        scanmode(i) = numel(unique(PData(:,i)));
    end
    switch numel(find(scanmode~=1))
        case 1
            plot1D(PData,scanmode);
        case 2
            plot2D(PData,scanmode);
        otherwise
            error('Wrong data!')
    end       
end

function plot1D(PData,scanmode)
   
    switch find(scanmode~=1)
        case 1
            XLable = 'x (mm)';
            xvec = PData(:,1);
            titlestr = sprintf('y = %.2f (mm), z = %.2f (mm)'...
                ,PData(1,2),PData(1,3));
        case 2
            XLable = 'y (mm)';
            xvec = PData(:,2);
            titlestr = sprintf('x = %.2f (mm), z = %.2f (mm)'...
            ,PData(1,1),PData(1,3));
        case 3
            XLable = 'z (mm)';
            xvec = PData(:,3);
            titlestr = sprintf('x = %.2f (mm), y = %.2f (mm)'...
                ,PData(1,1),PData(1,2));
    end
    xmid = mean(xvec);
    xvec = xvec;
    P = PData(:,4);
%     Pn = P/max(P);
    Pn = P;
    Pnp = findpeaks(Pn);
    Pnps = sort(Pnp);
%     mslp = find(Pn == Pnps(end-1));%max side lobe position;
    figure;
    plot(xvec,Pn);
    xlabel(XLable);
    ylabel('Normalized acoustic pressure');
    hold on;
    db8 = 10^(-6/20)*max(P);
    plot(xvec,xvec*0+db8,'r')
    title(titlestr)
%     plot(xvec(mslp),Pnps(end-1),'k*');
%     text(xvec(mslp),Pn(mslp),sprintf(' %.1f,%.2f',xvec(mslp),Pnps(end-1)),...
%         'fontsize',12,'color','k');
%     text(xvec(end)*0.8,db8*1.06,'-8dB','color','r');
end

function plot2D(PData,scanmode)
    
    switch find(scanmode==1)
        case 1
            XLabel = 'y (mm)';
            YLabel = 'z (mm)';
            xvec = PData(:,2);
            yvec = PData(:,3);            
        case 2
            XLabel = 'x (mm)';
            YLabel = 'z (mm)';
            xvec = PData(:,1);
            yvec = PData(:,3);
        case 3
            XLabel = 'x (mm)';
            YLabel = 'y (mm)';
            xvec = PData(:,1);
            yvec = PData(:,2);
    end
    xnum = numel(unique(xvec));
    ynum = numel(unique(yvec));
    xgridvec = sort(unique(xvec));
    ygridvec = sort(unique(yvec));
    [xgrid,ygrid] = meshgrid(xgridvec,ygridvec);
%     xgridvec = reshape(xgrid,xnum*ynum,1);
%     ygridvec = reshape(ygrid,xnum*ynum,1);
    orgData = PData(:,4);
    intData = griddata(xvec,yvec,orgData,xgrid,ygrid);

    

    pmapn = intData;

    
    figure;

    h1 = imagesc(ygridvec,xgridvec,pmapn.');
        hold on;
    axis equal;
    pmapnp = imresize(pmapn,2);
    xgridp = imresize(xgrid,2);
    ygridp = imresize(ygrid,2);
    h2 = contour(ygridp,xgridp,pmapnp,[0.5,0.5]*max(pmapnp(:)),'color','k');
    set(gca,'clim',[min(pmapn(:)),max(pmapn(:))]);
%     colormap('jet');
    xlabel(XLabel);
    ylabel(YLabel);
    hc = colorbar;
    ylabel(hc,'Acousctic pressure (MPa)')
end