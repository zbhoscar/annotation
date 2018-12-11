 function   recData =  GeneralRecHDLFun(LaserDir,InsTime,L)
%%静态场景无人车高速运动的情况下激光数据的时间对齐,time可以是矩阵,每行类型为[16 52 11 273]或者以ms为单位的格式。
if nargin == 0
InsTime=[16 33 13 273;16 31 14 111;16 20 12 992;16 15 13 204];
LaserDir='G:\DouJianCalibration\2017_04_16lidar\Record-2017-04-16-15-59-59\';
end
[m,n] = size(InsTime);
if n==1
    insTime(:,4) = mod(InsTime,1000);
    temp = (InsTime-insTime(:,4))/1000;
    insTime(:,3) = mod(temp,60);
    temp = (temp-insTime(:,3))/60;
    insTime(:,2) = mod(temp,60);
    insTime(:,1) = (temp-insTime(:,2))/60; %将时间转化为正常的四位数
    InsTime = insTime;
end

PoseData = [L(:, 1:6) L(:, 8) L(:, 9:15) L(:, end-3:end)];
%  IInsTime = GetTimeFun(InsTime);
InsPose = IterpPoseFun(PoseData,InsTime);
InsTime = GetTimeFun(InsTime);
%%%%%%%%%%%%%%%%%%%%%%恢复对应时间的位姿插值%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smpTimeStampRoot = [LaserDir,'simpleTimeStamp.txt'];
if ~exist(smpTimeStampRoot)
    cvtTimeStampFun(LaserDir); %创建一个可以直接load的时间戳文本
end
LaserFrame = zeros(m,2);
LaserTime = load(smpTimeStampRoot);
for i = 1:m
     index1 = find(InsTime(i)>LaserTime(:,2));
     index2 = find(InsTime(i)>LaserTime(:,3));
     index3 = find(InsTime(i)<LaserTime(:,2));
     index4 = find(InsTime(i)<LaserTime(:,3));
     Ind1 = max(index1(end),index2(end));
     Ind2 = min(index3(1),index4(1));
     LaserFrame(i,1:3) = LaserTime(Ind1,:);
     LaserFrame(i,4:6) = LaserTime(Ind2,:);
end
%%%%%%%%%%%%%%%%%%%%%%选取相关时间段的激光数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UDPTime = zeros(586,1);
for k = 1:586
    UDPTime(k) = (k-1)/(586-1);   
end
for i = 1:length(InsTime)
    if LaserFrame(i,1) == LaserFrame(i,4)
    Time = UDPTime+LaserFrame(i,2);
    UDPPose = LTIterpPoseFun(PoseData,Time);
    num2str(LaserFrame(i,1))
    PcData = HDLAnalyserNew([LaserDir,'BinaryData\Binary',num2str(LaserFrame(i,1)),'.txt']);
    recData{i} = AccRecHDLFun(PcData,UDPPose,InsPose(i,:));
    end
    
    if LaserFrame(i,1) ~= LaserFrame(i,4)   %选取前一帧的后一半激光数据和后一帧的前一半激光数据
       Time1 = UDPTime+LaserFrame(i,2);
       Time2 = UDPTime+LaserFrame(i,5);
       UDPPose1 = LTIterpPoseFun(PoseData,Time1);
       UDPPose2 = LTIterpPoseFun(PoseData,Time2);
       PcData1 = HDLAnalyserNew([LaserDir,'BinaryData\Binary',num2str(LaserFrame(i,1)),'.txt']);
       PcData2 = HDLAnalyserNew([LaserDir,'BinaryData\Binary',num2str(LaserFrame(i,4)),'.txt']);
       tmpPcData1 =  AccRecHDLFun(PcData1,UDPPose1,InsPose(i,:),294,586);       
       tmpPcData2 =  AccRecHDLFun(PcData2,UDPPose2,InsPose(i,:),1,293);
       idx1 = find(tmpPcData1(6,:)~=0);
       idx2 = find(tmpPcData2(6,:)~=0);
       recData{i} = [tmpPcData1(:,idx1) tmpPcData2(:,idx2)];
     end
end
 end


 function cvtTimeStampFun(Dir)
 LaserDir = Dir;
 TimeStampRoot = [LaserDir,'TimeStamp.txt'];
 Timefid = fopen(TimeStampRoot);
 str1='----------';
 str2='';

 i = 0;
 while ~feof(Timefid)
     i = i+1;
     tline = fgetl(Timefid);
     if tline==-1
         break
     end
     frame1 = strrep(tline,str1,str2);
     tline = fgetl(Timefid);
     tline1 = tline(4:15);
     tempTime1 = regexp(tline1,':','split');
     tline = fgetl(Timefid);
     tline1 = tline(4:15);
     tempTime2 = regexp(tline1,':','split');
     LaserTime(i,1) = str2double(frame1);
     LaserTime(i,2) = ((str2double(tempTime1{1})*60+str2double(tempTime1{2}))*60+str2double(tempTime1{3}))*1000+str2double(tempTime1{4});
     LaserTime(i,3) = ((str2double(tempTime2{1})*60+str2double(tempTime2{2}))*60+str2double(tempTime2{3}))*1000+str2double(tempTime2{4});
 end
 save([LaserDir,'simpleTimeStamp.txt'],'LaserTime','-ascii');
 end


















