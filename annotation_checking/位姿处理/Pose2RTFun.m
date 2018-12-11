function [R T] = Pose2RTFun(pose)
    T = pose(1:3)'; 
    Ang = pose(4); 
    R = eul2rotm([deg2rad(Ang) 0 0]); 
end