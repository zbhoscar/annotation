lightpose = fopen('lightposelog.txt','r');
txtnumber = fopen('txtnumber.txt','w+');
simpleImgLog = fopen('simpleImgLog.txt','w+');
timefile = fopen('TimeStamp.txt','r');

str1='----------';
str2='';
i=0;
while ~feof(timefile)
    i = i+1;
    tempstr2 = fgetl(timefile);
    tempstr2 = strrep(tempstr2,str1,str2);
    number1 = tempstr2;
    
    tempstr2 = fgetl(timefile);
    time1 = tempstr2(4:15);
    linz1 = regexp(time1, ':', 'split');
    tempstr2 = fgetl(timefile);
    time2 = tempstr2(4:15);
    linz2 = regexp(time2, ':', 'split');
    
    ltime1 = str2double(linz1{1})*60*60*1000 + str2double(linz1{2})*60*1000 + str2double(linz1{3})*1000 + str2double(linz1{4});
    ltime2 = str2double(linz2{1})*60*60*1000 + str2double(linz2{2})*60*1000 + str2double(linz2{3})*1000 + str2double(linz2{4});
    
    tempTime(i,1) = str2num(number1);
    tempTime(i,2) = ltime1;
    tempTime(i,3) = ltime2;
end

while ~feof(lightpose)
    tempstr =  fgetl(lightpose);
    templine1 = textscan(tempstr,'%s %s');
    counts = cell2mat(templine1{2});
    tempstr =  fgetl(lightpose);
    
    templine = textscan(tempstr,'%s %s %s %s %s %s %s %s');
    
    hour = str2double(templine{5});
    minute = str2double(templine{6});
    second = str2double(templine{7});
    msed = str2double(templine{8});
    
    
    imagetimemes = hour*60*60*1000 + minute*60*1000 + second*1000 + msed;
    index = find(tempTime(:,2)<imagetimemes & tempTime(:,3)>imagetimemes );
    if ~isempty(index)
        fprintf(txtnumber,'%s %s\n',counts,num2str(tempTime(index,1)));
    end
    fprintf(simpleImgLog,'%s %s\n',counts,num2str(imagetimemes));  
    tempstr =  fgetl(lightpose);
    tempstr =  fgetl(lightpose);
end
fclose(timefile);
%     if flag == 0
%         fprintf(txtnumber,'%s\n',counts);
%     end
fclose(lightpose);
fclose(txtnumber);



