DataRoot = 'G:\2017_05_09\'; %将图像时间戳和激光时间戳放在根目录下
picRoot = 'G:\2017_05_09\2017_05_09_09_43_13\Light\';
laserRoot = 'G:\2017_05_09\Record-2017-05-09-09-41-44\';
% DataRoot = 'G:\5.10标定\'; %将图像时间戳和激光时间戳放在根目录下
% picRoot = 'G:\5.10标定\2017_05_10_15_24_12\Light\';
% laserRoot = 'G:\5.10标定\Record-2017-05-10-15-20-14\';

BinarylaserRoot = [laserRoot,'BinaryData\'];
if ~exist([DataRoot,'calibrationshow'])
mkdir([DataRoot,'calibrationshow']);
end
PoseDataRoot = [laserRoot,'SimplePose.txt'];
if ~exist(PoseDataRoot)
    CvtPoseFun(laserRoot)
end
L = load(PoseDataRoot);
% SplitBigBinary(laserRoot);  %分解激光数据
% Gettimestep(DataRoot);    %根据时间戳获得对应激光图像序号
% LaserBinary23D(DataRoot,laserRoot);  %将匹配到的激光数据由二进制变为三维点云数据，存于calibrationshow文件夹中
% changename(DataRoot,picRoot);  %将匹配到的图像数据转存于calibrationshow文件夹中
% pic_num = 500;   %选取的激光图像对的数量
% Select_calib_source(picRoot,BinarylaserRoot,DataRoot,pic_num,[5100 5800]);  %随机选取九组对应的激光图像数据进行标定 
% pic2IDTpic(DataRoot,[1:250]);  %将选取到的图像进行反向距离变换
load([DataRoot,'Rt.mat'])
% zy_cam_0511_calib_1
%% 不同的网格搜索更新参数方法
% [R t] = gridresearch(DataRoot,laserRoot,R,t,L);  %网格搜索更新参数
% [R t] = gridresearchnew(DataRoot,laserRoot,R,t,L);  %网格搜索更新参数
% [R t] = gridresearchnew1(DataRoot,laserRoot,R,t,L); %网格搜索更新参数
% [R t] = globalresearch(DataRoot,laserRoot,R,t);
% [R t] = gridresearchnew2(DataRoot,laserRoot,R,t,L,[1:500]); %网格搜索更新参数
% [R t] = gridresearchnew3(DataRoot,laserRoot,R,t,L);  %网格搜索更新参数
%  [R t] = gridresearchnew4(DataRoot,laserRoot,R,t,L);  %网格搜索更新参数
 %%
% for i = 3757:3757
% show_laser_to_image2(i,R,t,L,DataRoot,picRoot,laserRoot);  %显示激光图像  [1010 2034 3200 7063 8018 11813]
%  F = getframe(gcf);
%  imwrite(F.cdata,[DataRoot,'calibrationshow\',num2str(i),'.bmp']);
% end