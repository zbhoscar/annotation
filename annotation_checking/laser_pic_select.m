DataRoot = 'G:\2017_05_09\'; %��ͼ��ʱ����ͼ���ʱ������ڸ�Ŀ¼��
picRoot = 'G:\2017_05_09\2017_05_09_09_43_13\Light\';
laserRoot = 'G:\2017_05_09\Record-2017-05-09-09-41-44\';
% DataRoot = 'G:\5.10�궨\'; %��ͼ��ʱ����ͼ���ʱ������ڸ�Ŀ¼��
% picRoot = 'G:\5.10�궨\2017_05_10_15_24_12\Light\';
% laserRoot = 'G:\5.10�궨\Record-2017-05-10-15-20-14\';

BinarylaserRoot = [laserRoot,'BinaryData\'];
if ~exist([DataRoot,'calibrationshow'])
mkdir([DataRoot,'calibrationshow']);
end
PoseDataRoot = [laserRoot,'SimplePose.txt'];
if ~exist(PoseDataRoot)
    CvtPoseFun(laserRoot)
end
L = load(PoseDataRoot);
% SplitBigBinary(laserRoot);  %�ֽ⼤������
% Gettimestep(DataRoot);    %����ʱ�����ö�Ӧ����ͼ�����
% LaserBinary23D(DataRoot,laserRoot);  %��ƥ�䵽�ļ��������ɶ����Ʊ�Ϊ��ά�������ݣ�����calibrationshow�ļ�����
% changename(DataRoot,picRoot);  %��ƥ�䵽��ͼ������ת����calibrationshow�ļ�����
% pic_num = 500;   %ѡȡ�ļ���ͼ��Ե�����
% Select_calib_source(picRoot,BinarylaserRoot,DataRoot,pic_num,[5100 5800]);  %���ѡȡ�����Ӧ�ļ���ͼ�����ݽ��б궨 
% pic2IDTpic(DataRoot,[1:250]);  %��ѡȡ����ͼ����з������任
load([DataRoot,'Rt.mat'])
% zy_cam_0511_calib_1
%% ��ͬ�������������²�������
% [R t] = gridresearch(DataRoot,laserRoot,R,t,L);  %�����������²���
% [R t] = gridresearchnew(DataRoot,laserRoot,R,t,L);  %�����������²���
% [R t] = gridresearchnew1(DataRoot,laserRoot,R,t,L); %�����������²���
% [R t] = globalresearch(DataRoot,laserRoot,R,t);
% [R t] = gridresearchnew2(DataRoot,laserRoot,R,t,L,[1:500]); %�����������²���
% [R t] = gridresearchnew3(DataRoot,laserRoot,R,t,L);  %�����������²���
%  [R t] = gridresearchnew4(DataRoot,laserRoot,R,t,L);  %�����������²���
 %%
% for i = 3757:3757
% show_laser_to_image2(i,R,t,L,DataRoot,picRoot,laserRoot);  %��ʾ����ͼ��  [1010 2034 3200 7063 8018 11813]
%  F = getframe(gcf);
%  imwrite(F.cdata,[DataRoot,'calibrationshow\',num2str(i),'.bmp']);
% end