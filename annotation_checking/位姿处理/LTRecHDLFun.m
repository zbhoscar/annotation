function  [RecData]  = LTRecHDLFun(pcData, poseInfo0, poseInfo1,UDPB,UDPE)
%%将所有激光数据点映射到poseInfo0的位姿下，且默认pcData第一个点的位姿是poseInfo0,激光数据数量可以小于586
if nargin == 3
UDPB = min(pcData(6,:));
UDPE = max(pcData(6,:));
PointNum = UDPE-UDPB+1;
end
UDPNum = 586; 
scanPeriod = 0.10;
pose0 = GetPoseFun(poseInfo0, 'local');
pose1 = GetPoseFun(poseInfo1, 'local');
[R0, T0] = Pose2RTFun(pose0);
[R1, T1] = Pose2RTFun(pose1);
dR = R0'*R1;
dT = R0'*(T1-T0);    
pose0 = RT2PoseFun(dR, dT); 
RecData = [];  
t0 = GetPoseFun(poseInfo0, 'time'); 
t1 = GetPoseFun(poseInfo1, 'time'); 
scanPeriod = GetTimeFun( t1 - t0 ) / 1000.0;
% if scanPeriod < 0
%     error('Wrong scan!');
% end
for i = UDPB : 1 : UDPE
    idx =find(pcData(end, :) == i);
    if isempty(idx)
        continue; 
    end
    tmpData = pcData(:, idx); 
    s = (i-min(pcData(6,:))) / (PointNum-1); 
    if scanPeriod <0
        s = 1-s;
    end
    tmpPose = s*pose0;
    [R, T] = Pose2RTFun(tmpPose);
    NewData = Loc2Glo(tmpData(1:3, :), R', T); 
    NewData(4:6,:) = tmpData(4:6,:);
    RecData = [RecData NewData]; 
end 
end

function [R T] = Pose2RTFun(pose)
    T = pose(1:3)'; 
    Ang = pose(4); 
    R = eul2rotm([deg2rad(Ang) 0 0]); 
end

function pose = RT2PoseFun(R, T)
    pose = zeros(1, 18); 
    pose(1:3) = T'; 
    Ang = atan2d(R(2, 1), R(1, 1)); 
    pose(4) = Ang; 
end
