datapath='D:\research\���ݼ�����\����2\';
datadir=dir(datapath);
load datasetbydate.mat
global data;
data={};
for di=3:length(datadir)
    fprintf('------%d/%d\n',di-2,length(datadir)-2);
    subdatadir=dir([datapath,datadir(di).name]);
    subdatanamecell={subdatadir.name}';
    subdatanamecell= filterDatasetName(subdatanamecell);
    for set=1:length(subdatanamecell)
        fprintf('--%d/%d\n',set,length(subdatanamecell));
        labelpath=[[datapath,datadir(di).name] '\' subdatanamecell{set} '\Label\'];
        labeldir=dir(labelpath);
        %��֡��ȡ�����е�label
        label_sequence=[];
        for li=3:length(labeldir)
            tic_toc_print(sprintf('%s:%d/%d\n',subdatanamecell{set},li-2,length(labeldir)-2));
            try
                frame=str2num(labeldir(li).name(1:6));
            catch
                s=1
            end
            label_frame=load([labelpath labeldir(li).name]);
%             if strcmp(subdatanamecell{set},'104')
%                 label_frame[:,2]=2;
%             end
            %label
            %��ţ���������������Ϊ�������Ϊ�����ģ�ground�������������򣬸߶�
            if isempty(label_frame)
                continue;
            end
            if label_frame(1,2)==2||label_frame(1,2)==5||label_frame(1,2)==7
                %��ֱ������
                continue;
            end
            if label_frame(1,3)~=1 && label_frame(1,3)~=2 && label_frame(1,3)~=5
                data=[data;[subdatanamecell(set) label_frame(1,3)]];
                break;
            end
            %label_frame=[ ones(size(label_frame,1),1)*frame,label_frame];
%             label_sequence=[label_sequence;label_frame];
%             if ismember(subdatanamecell{set}, datasetbydate.morning) %morning data
%                 a=['data.m' subdatanamecell{set}];
%             else
%                 a=['data.n' subdatanamecell{set}];
%             end
%             eval([a,'=',mat2str(label_sequence),';']);
        end
    end
end

