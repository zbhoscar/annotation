function RecpcData = AccRecHDLFun(pcData,UDPPose,poseInfo,UDPB,UDPE)
pcDataTemp = zeros(size(pcData));
if nargin == 3
UDPB = 1;
UDPE = 586;
end
pose0 = GetPoseFun(poseInfo,'local');
[R0,T0] = LTPose2RTFun(pose0);
for i = UDPB:1:UDPE
     index  = find(pcData(6,:)==i);
     pose1 = GetPoseFun(UDPPose(i,:),'local');
     [R1,T1] = LTPose2RTFun (pose1);
     pcDataTemp(1:3,index) = bsxfun(@plus,(R1'*R0)*pcData(1:3,index),R0*(T1-T0));
     pcDataTemp(4:6,index) = pcData(4:6,index);
end
RecpcData = pcDataTemp;
end


function [R T] = LTPose2RTFun(pose)
    T = pose(1:3)'; 
    Ang1 = pose(4);
    Ang2 = pose(5);
    Ang3 = pose(6);
    R = eul2rotm([deg2rad(-Ang1) deg2rad(Ang2) deg2rad(-Ang3)]); %%位姿角度正方向与matlab默认正方向不同，所以加负号
end