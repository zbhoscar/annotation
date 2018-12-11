function ImageTime = GetImageTime(imgidx,Root)
%%获得对应于图像帧数的时间戳，imgidx为m*1向量,Root为simpleImgLog.txt文件的目录，
%%此文件在一开始查找激光图像对应数据的过程中生成
if nargin == 1
    Root = 'G:\DouJianCalibration\';
end
ImgLog = load([Root,'simpleImgLog.txt']);
ImageTime = zeros(size(imgidx));
for i = 1:length(imgidx)
    ImageTime(i,:) = ImgLog(imgidx(i),2);
end
end


