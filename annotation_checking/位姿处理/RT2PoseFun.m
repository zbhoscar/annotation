function pose = RT2PoseFun(R, T)
    pose = zeros(1, 18); 
    pose(1:3) = T'; 
    Ang = atan2d(R(2, 1), R(1, 1)); 
    pose(4) = Ang; 
end