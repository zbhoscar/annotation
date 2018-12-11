clc; clear;
path = 'F:\shuju\';
imgfile = fopen([path,'imagetime.txt'],'w+');

fileFolder = fullfile('F:\shuju\12-19-calibration');
dirOutput = dir(fullfile(fileFolder,'*.jpg'));
fileNames = {dirOutput.name}';
imgnumber = [];
for i=1:size(fileNames,1)
    names = fileNames{i};
    x = findstr(names,'.');
    y =x-1;
    imgnumber = [imgnumber;names(1:y)];
end
% imgnumber = sort(imgnumber);
i=1;
lightpose = fopen('F:\shuju\2016_12_19_09_15_29-bd\imglog.txt','r');
while ~feof(lightpose)
    tempstr1 =  fgetl(lightpose);
    templine = textscan(tempstr1,'%s %s');
    count = cell2mat(templine{2});
    tempstr2 =  fgetl(lightpose);
    tempstr3 =  fgetl(lightpose);
    tempstr4 =  fgetl(lightpose);

    if (i <= size(imgnumber,1))
        if strcmp(count, imgnumber(i,:))==1
            fprintf(imgfile,'%s\n',tempstr1);
            fprintf(imgfile,'%s\n',tempstr2);
            fprintf(imgfile,'%s\n',tempstr3);
            fprintf(imgfile,'%s\n',tempstr4);
            i=i+1;
        end
    end
end
fclose(lightpose);
fclose(imgfile);