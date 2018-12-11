function [PoseData, InsPoseData] = ReadPoseFun(varargin)
if nargin == 0 
    DataRoot = 'F:\Data\Record-2016-08-23-12-40-46(GAC AntiCW, Pose 50Hz)\'; 
    PoseDir = fullfile(DataRoot, 'Pose.txt'); 
    InsPoseDir = fullfile(DataRoot, 'InsertedPose.txt'); 
end
if nargin == 1
    DataRoot = varargin{1};
    PoseDir = fullfile(DataRoot, 'Pose.txt');
    InsPoseDir = fullfile(DataRoot, 'InsertedPose.txt');
end
if nargin == 2
    PoseDir = varargin{1}; 
    InsPoseDir = varargin{2}; 
end
PoseData = [];
InsPoseData = [];
PoseFid = fopen( PoseDir, 'r' );
% Format
% ---------11:16:04:296----------
% 957.091  -70.2357  0  27.4098  0.801394  0  0  0  1489.1  96.4831  -16.8302  133.608  0  3  2
tLine = 0;
PoseData = [];
bOldFormat = 0; 
while true
    tLine = fgetl( PoseFid );
    if tLine == -1 
        break;
    end
    if isempty( tLine )
        continue;
    end
    [ wh wm ws wmm ] = strread( tLine, '---------%d:%d:%d:%d----------' );
    tLine = fgetl( PoseFid );
    % Format 
    % px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsSpeed gpsFlag ModelFlag
    tmp = str2num(tLine); 
    if length(tmp) == 15
        [ px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsSpeed gpsFlag ModelFlag ] = strread( tLine, '%f%f%f%f%f%f%f%f%f%f%f%f%f%d%d' );
        gpsPitch = 0; 
        gpsRoll = 0; 
        bOldFormat = 1;
    else
        [ px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsPitch gpsRoll gpsSpeed gpsFlag ModelFlag ] = strread( tLine, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%d%d' );
        bOldFormat = 0; 
    end
    tmp = []; 
    tmp.local = [px py pz head pitch roll]; 
    tmp.global = [gpsPx gpsPy gpsPz gpsHead gpsPitch gpsRoll]; 
    tmp.v = Speed; 
    tmp.flag = [gpsFlag ModelFlag]; 
    tmp.t = [wh wm ws wmm]; 
    PoseData = [PoseData tmp];
end
fclose( PoseFid );
% ----------0----------
% 27.4102  0  957.091  -70.2357  133.607  0  1489.1  96.4831  0.799385  3  11  16  4  500  
% 27.4099  0  957.091  -70.2357  133.608  0  1489.1  96.4831  0.80201  3  11  16  4  609  
% 27.4101  0  957.091  -70.2357  133.607  0  1489.1  96.4831  0  0  11  16  4  417 
tLine = 0;
InsPoseFid = fopen( InsPoseDir, 'r' );
InsPoseData = [];
while true
    tLine = fgetl( InsPoseFid );
    if tLine == -1 
        break;
    end
    if isempty( tLine )
        continue;
    end
    InsPoseCounter = strread( tLine, '----------%d----------' );
    tLine = fgetl( InsPoseFid );  % PrePose
    tLine = fgetl( InsPoseFid );  % CurPose
    tLine = fgetl( InsPoseFid ); 
   % 1 vh 2 vv 3 vx 4 vy 5 gh 6 gv 7 gx 8 gy 9 pitch 10 gpsFlag 11 hour 12 minute 13second  14milisecond
   [head Speed px py gpsHead gpsSpeed gpsPx gpsPy gpsPitch gpsFlag wh wm ws wmm ]= strread( tLine, '%f%f%f%f%f%f%f%f%f%d%d%d%d%d');
   tmp = []; 
   tmp.local = [px py head]; 
   tmp.global = [gpsPx gpsPy gpsPitch]; 
   tmp.v = Speed; 
   tmp.t = [wh wm ws wmm]; 
   tmp.flag = [gpsFlag]; 
   InsPoseData = [InsPoseData tmp];
end
fclose( InsPoseFid );
bTest = 1; 
if nargin == 0 
    time = cat(1, PoseData(:).t); 
    Gap = time(2:end, :) - time(1:end-1, :); 
    tmp = GetTimeFun(Gap); 
    figure; 
    plot(tmp, 'b.'); 
    title('Pose Capture'); 
    tmp = cat(1, PoseData(:).local);
    figure; 
    subplot(3, 1, 1); 
    plot(tmp(:, 4), 'b.--' ); 
    title('local head');
    subplot(3, 1, 2); 
    plot(tmp(:, 5), 'b.--' ); 
    title('local pitch');
    subplot(3, 1, 3); 
    plot(tmp(:, 6), 'b.--' ); 
    title('local roll'); 

    figure; 
    hold on; 
    axis equal; 
    grid on; 
    plot3(tmp(:, 1), tmp(:, 2), tmp(:, 3), 'k.' ); 
    plot3(tmp(1, 1), tmp(1, 2), tmp(1, 3), 'rh' ); 
    plot3(tmp(end, 1), tmp(end, 2), tmp(end, 3), 'bh' ); 
    title('Local trajectory'); 
    
    tmp = cat(1, PoseData(:).global); 
%     for i = 1 : 1 : 3 
%         tmp(:, 3+i) = wrapTo360Fun(tmp(:, 3+i)); 
%     end
    figure; 
    subplot(3, 1, 1); 
    plot(tmp(:, 4), 'b.--' ); 
    title('global head');
    subplot(3, 1, 2); 
    plot(tmp(:, 5), 'b.--' ); 
    title('global pitch');
    subplot(3, 1, 3); 
    plot(tmp(:, 6), 'b.--' ); 
    title('global roll'); 
    
    figure; 
    hold on; 
    axis equal; 
    grid on; 
    plot3(tmp(:, 1), tmp(:, 2), tmp(:, 3), 'k.' ); 
    plot3(tmp(1, 1), tmp(1, 2), tmp(1, 3), 'rh' ); 
    plot3(tmp(end, 1), tmp(end, 2), tmp(end, 3), 'bh' ); 
    title('Global trajectory'); 
end
bTest = 1; 
end

