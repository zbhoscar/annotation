function PoseData = ReadFullPoseDataOnlyPose(DataRoot)
if nargin == 0
    DataRoot = 'G:\DouJianCalibration\2017_04_16lidar\Record-2017-04-16-15-59-59';
    'F:\Data\Record-2016-08-23-12-40-46(GAC AntiCW, Pose 50Hz)\';
end
PoseData = [];
SimplePoseDir = fullfile(DataRoot, 'SimplePose.txt');
if ~exist(SimplePoseDir)
    CvtPoseFun(DataRoot);
end
A = load(SimplePoseDir);
PoseData = [A(:, 1:6) A(:, 8) A(:, 9:15) A(:, end-3:end)];
% for i = 1 : 1 : size(A, 1)
%     % [ px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsPitch gpsRoll gpsSpeed gpsFlag ModelFlag ] = strread( tLine, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%d%d' );
%     tmp = [];
%     tmp.local = A(i, 1:6);
%     tmp.global = A(i, 9:14); % [gpsPx gpsPy gpsPz gpsHead gpsPitch gpsRoll];
%     tmp.v = A(i, 8); % Speed;
%     tmp.flag = [A(i, end-5) A(i, end-4)];
%     tmp.t = A(i, end-3:end);
%     PoseData = [PoseData tmp];
%     if mod(i, 100) == 0
%         disp(i);
%     end
% end
% PoseDir = fullfile(DataRoot, 'Pose.txt');
% PoseFid = fopen( PoseDir, 'r' );
% % Format
% % ---------11:16:04:296----------
% % 957.091  -70.2357  0  27.4098  0.801394  0  0  0  1489.1  96.4831  -16.8302  133.608  0  3  2
% tLine = 0;
% PoseData = [];
% bOldFormat = 0;
% while true
%     tLine = fgetl( PoseFid );
%     if tLine == -1
%         break;
%     end
%     if isempty( tLine )
%         continue;
%     end
%     [ wh wm ws wmm ] = strread( tLine, '---------%d:%d:%d:%d----------' );
%     tLine = fgetl( PoseFid );
%     % Format
%     % px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsSpeed gpsFlag ModelFlag
%     tmp = str2num(tLine);
%     if length(tmp) == 15
%         [ px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsSpeed gpsFlag ModelFlag ] = strread( tLine, '%f%f%f%f%f%f%f%f%f%f%f%f%f%d%d' );
%         gpsPitch = 0;
%         gpsRoll = 0;
%         bOldFormat = 1;
%     else
%         [ px py pz head pitch roll yawRate Speed gpsPx gpsPy gpsPz gpsHead gpsPitch gpsRoll gpsSpeed gpsFlag ModelFlag ] = strread( tLine, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%d%d' );
%         bOldFormat = 0;
%     end
%     tmp = [];
%     tmp.local = [px py pz head pitch roll];
%     tmp.global = [gpsPx gpsPy gpsPz gpsHead gpsPitch gpsRoll];
%     tmp.v = Speed;
%     tmp.flag = [gpsFlag ModelFlag];
%     tmp.t = [wh wm ws wmm];
%     PoseData = [PoseData tmp];
% end
% fclose( PoseFid );
if nargin == 0
    time = GetPoseFun(PoseData, 'time');
    Gap = time(2:end, :) - time(1:end-1, :);
    time = GetTimeFun(Gap);
    figure;
    plot(time, 'b.');
    title('Pose Capture');
    LocalPose = GetPoseFun(PoseData, 'local');
    figure;
    subplot(3, 1, 1);
%     index = find(LocalPose(:,4)>0);
%     LocalPose(index,4)=LocalPose(index,4)-360;
    plot(LocalPose(:, 4), 'b.--' );
    title('local head');
    subplot(3, 1, 2);
    plot(LocalPose(:, 5), 'b.--' );
    title('local pitch');
    subplot(3, 1, 3);
    plot(LocalPose(:, 6), 'b.--' );
    title('local roll');
    
    figure;
    hold on;
    axis equal;
    grid on;
    plot3(LocalPose(:, 1), LocalPose(:, 2), LocalPose(:, 3), 'k.' );
    plot3(LocalPose(1, 1), LocalPose(1, 2), LocalPose(1, 3), 'rh' );
    plot3(LocalPose(end, 1), LocalPose(end, 2), LocalPose(end, 3), 'bh' );
    title('Local trajectory');
    
    GlobalPose = GetPoseFun(PoseData, 'global');
    figure;
    subplot(3, 1, 1);
    plot(GlobalPose(:, 4), 'b.--' );
    title('global head');
    subplot(3, 1, 2);
    plot(GlobalPose(:, 5), 'b.--' );
    title('global pitch');
    subplot(3, 1, 3);
    plot(GlobalPose(:, 6), 'b.--' );
    title('global roll');
    
    figure;
    hold on;
    axis equal;
    grid on;
    plot3(GlobalPose(:, 1), GlobalPose(:, 2), GlobalPose(:, 3), 'k.' );
    plot3(GlobalPose(1, 1), GlobalPose(1, 2), GlobalPose(1, 3), 'rh' );
    plot3(GlobalPose(end, 1), GlobalPose(end, 2), GlobalPose(end, 3), 'bh' );
    title('Global trajectory');
    bTest = 1;
end

