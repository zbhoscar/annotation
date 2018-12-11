datapath='E:\DATA\';
datadir=dir(datapath);
datasetbydate=struct();
datasetbydate.morning=[];
datasetbydate.night=[];
for di=3:length(datadir)
    subdatadir=dir([datapath,datadir(di).name]);
    subdatanamecell={subdatadir.name}';
    if strcmp(datadir(di).name(9),'m')%morning 
        datasetbydate.morning=[{subdatadir.name}';datasetbydate.morning];
    else%night
        datasetbydate.night=[{subdatadir.name}';datasetbydate.night];
    end
end
datasetbydate.morning= filterDatasetName(datasetbydate.morning);
datasetbydate.night= filterDatasetName(datasetbydate.night);