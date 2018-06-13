[filename,pathname] = uigetfile('Data.txt')
data = load(fullfile(pathname,filename));
[~,locs1] = findpeaks(data(:,1));
[~,locs2] = findpeaks(data(:,2));
[~,locs3] = findpeaks(data(:,3));
datanum = size(data,1);
if ~isempty(locs1)
    dim1num = locs1(2)-locs1(1);
    dim2num = datanum/dim1num;
    dim1step = norm(data(2,1:3)-data(1,1:3));
    dim2step = norm(data(locs1(2),1:3)-data(locs1(1),1:3));
else
    dim1num = locs2(2)-locs2(1);
    dim2num = datanum/dim1num;
    dim1step = norm(data(2,1:3)-data(1,1:3));
    dim2step = norm(data(locs2(2),1:3)-data(locs2(1),1:3));
end
p = reshape(data(:,4),dim1num,dim2num);
dimvec1 = 0:dim1step:dim1step*(dim1num-1);
dimvec2 = 0:dim2step:dim2step*(dim2num-1);
figure;imagesc(dimvec1,dimvec2,fliplr(flipud(p.'))/max(p(:)))
axis equal
axis([0,dim1step*(dim1num-1),0,dim2step*(dim2num-1)])
