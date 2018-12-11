function [ImgPt] = show_laser_to_image5(Image,laserdata,R,t,calib_result)
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

img_height=round(scan');
ImgPt = img_height(:,1:2);