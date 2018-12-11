function DataCell=filterDatasetName(DataCell)
    DataCell= cellfun( @(x)getDatasetName(x),DataCell,'UniformOutput',false);
    DataCell(cellfun(@isempty,DataCell))=[];
end
function x=getDatasetName(x)
    if isempty(str2num(x(1)))
        x=[];
    end
end