function [ImgPt] = show_laser_to_image4(Image,laserdata,R,t,calib_result)
% calib_result = load('Calib_Results.mat');

cam_data=Image;
imrows=size(cam_data,1);
imcols=size(cam_data,2);

laser_data = laserdata(:,1:3);
limg_data=R*laser_data'+repmat(t,1,size(laser_data,1));

inv_Z = 1./limg_data(3,:);

x =(limg_data([1 2],:).*([1;1] * inv_Z));
xx=[calib_result.fc(1) 0;0 calib_result.fc(2)]*x;
xxx=xx+repmat(calib_result.cc,1,size(xx,2));
scan=xxx;

scan=round(scan');
inliers=find(scan(:,1)>0 & scan(:,1)<imcols & scan(:,2)> 0& scan(:,2)<imrows);

img_height=[scan(inliers,1),scan(inliers,2),laser_data(inliers,3)];
ImgPt = img_height(:,1:2);


