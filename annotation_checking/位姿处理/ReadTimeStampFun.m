function [ STime, ETime ] = ReadTimeStampFun( DataRoot)
if nargin==0
    DataRoot = 'G:\calibration\2017-03-14-16-52-11(Normal1)laser';
end
DataDir = [DataRoot,'\TimeStamp.txt'];
fid = fopen(DataDir, 'r' );
STime = [];   %StartTime
ETime = [];   %EndTime
while 1
    for i = 1 : 1 : 3
        tLine = fgetl(fid);
       tLine
        if tLine == -1
            break;
        end
        if i == 2 || i == 3
            [wh wm ws wms] = strread(tLine, '%d:%d:%d:%d');
            if i == 2
                STime(end+1, :) = [wh wm ws wms];
            end
            if i == 3
                ETime(end+1, :) = [wh wm ws wms];
            end
        end
    end
    if tLine == -1
        break;
    end
end
fclose(fid);
if nargin == 0
    Gap = ETime - STime;
    tmp = ( ( Gap(:, 1)*60 + Gap(:, 2) ) * 60 + Gap(:, 3) ) * 1000 + Gap(:, 4);
    figure;
    plot(tmp, 'b.--' );
    title('Capture time');
    Gap = STime(2:end, :) - ETime(1:end-1, :);
    tmp = ( ( Gap(:, 1)*60 + Gap(:, 2) ) * 60 + Gap(:, 3) ) * 1000 + Gap(:, 4);
    figure;
    plot(tmp, 'b.--' );
    title('Gap between frames');
    
    DataDir = fullfile(DataRoot, 'LidarRecvThread.txt' );
    A = importdata(DataDir);
    Gap = A(:, end-3:end) - A(:, 1:4);
    tmp = ( ( Gap(:, 1)*60 + Gap(:, 2) ) * 60 + Gap(:, 3) ) * 1000 + Gap(:, 4);
    figure;
    plot(tmp, 'b.--' );
    title('Whole capture time');
    
    Gap = A(2:end, 1:4) - A(1:end-1, end-3:end);
    tmp = ( ( Gap(:, 1)*60 + Gap(:, 2) ) * 60 + Gap(:, 3) ) * 1000 + Gap(:, 4);
    figure;
    plot(tmp, 'b.--' );
    title('Whole gap between');
end
end

