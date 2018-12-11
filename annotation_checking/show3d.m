function [pcData] = show3d(LaserRoot,Index)
pcData = HDLAnalyserNew([LaserRoot,num2str(Index),'.txt']);
pcData = pcData';
x = pcData(:, 1);
y = pcData(:, 2);
z = pcData(:, 3);

plot3(x,y,z, '.b'); axis equal; grid on;hold on;
% view(2);