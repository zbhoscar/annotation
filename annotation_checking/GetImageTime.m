function ImageTime = GetImageTime(imgidx,Root)
%%��ö�Ӧ��ͼ��֡����ʱ�����imgidxΪm*1����,RootΪsimpleImgLog.txt�ļ���Ŀ¼��
%%���ļ���һ��ʼ���Ҽ���ͼ���Ӧ���ݵĹ���������
if nargin == 1
    Root = 'G:\DouJianCalibration\';
end
ImgLog = load([Root,'simpleImgLog.txt']);
ImageTime = zeros(size(imgidx));
for i = 1:length(imgidx)
    ImageTime(i,:) = ImgLog(imgidx(i),2);
end
end


