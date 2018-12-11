function showlaser(pcData)
x = pcData(:, 1);
y = pcData(:, 2);
z = pcData(:, 3);
plot3(x,y,z, '.b'); axis equal; grid on;
end