function [data] = prepAras(datasetName)
if strcmp(datasetName,'HouseA') == 1
    load HouseA.mat
elseif strcmp(datasetName,'HouseB') == 1
    load HouseB.mat
else 
    error('Wrong dataset name for ARAS');
end
data = ArasDataset;
