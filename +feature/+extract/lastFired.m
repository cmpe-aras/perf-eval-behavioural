function [dataWithFeat,pars] = lastFired(data,pars)
% INPUT 
% data contains the second-based representation of the data set and is a struct with
% .observations  : a [numSensors x lengthOfDataset] matrix where each column
%                  is a representation of all sensor readings in a second
% .labels        : a [1 x lengthOfDataset] matrix where each column
%                  is the ID of the activity label
% .labels2       : (OPTIONAL) a [1 x lengthOfDataset] matrix where each column
%                  is the ID of the activity label
% .actList       : a [numActivities x 1] matrix that relates the ID's of
%                  the activities in the original data set to the
%                  representation given in this struct
% .actLabels     : a {numActivities x 1} cell array that relates the ID's of
%                  the activities in this representation to the names of
%                  activities
% .senseList     : a [numSensors x 1] matrix that relates the ID's of
%                  the sensors in the original data set to the
%                  representation given in this struct
% .senseLabels   : a {numSensors x 1} cell array that relates the ID's of
%                  the sensors in this representation to the names and
%                  locations of the sensors
% .startTime     : start Time of the data set in seconds i.e. 00:19:32 -> 1172 
%
% pars is a struct that contains the parameters
%
% OUTPUT
% dataWithFeat contains the last fired representation of features in the dataset and is a struct with
% .features      : a [numSensors x numTimesteps] matrix where each column
%                  is the last fired representation of the features
% .labels        : a [1 x numTimesteps] matrix where each column
%                  is the ID of the activity label
% .labels2       : (OPTIONAL) a [1 x lengthOfDataset] matrix where each column
%                  is the ID of the activity label
% .actList       : a [numActivities x 1] matrix that relates the ID's of
%                  the activities in the original data set to the
%                  representation given in this struct
% .actLabels     : a {numActivities x 1} cell array that relates the ID's of
%                  the activities in this representation to the names of
%                  activities
% .senseList     : a [numSensors x 1] matrix that relates the ID's of
%                  the sensors in the original data set to the
%                  representation given in this struct
% .senseLabels   : a {numSensors x 1} cell array that relates the ID's of
%                  the sensors in this representation to the names and
%                  locations of the sensors
% .startTime     : start Time of the data set in seconds i.e. 00:19:32 -> 1172 
%
% pars is a struct that contains the parameters
%%

% Discretize in timeStepSize seconds
timeStepSize    = pars.feature.extract.timeStepSize;  
totalTimeSteps  = size(data.observations,2);
numTimesteps    = floor(totalTimeSteps / timeStepSize);
numSense        = length(data.senseList);

if isfield(data,'labels2')
    actList     = unique(union(data.labels,data.labels2));
else
    actList     = 0:max(data.labels);
end

% Calculate Last Fired Features
FeatMat = sum(reshape(data.observations(:,1:numTimesteps*timeStepSize),numSense,timeStepSize,numTimesteps),2);
FeatMat(find(FeatMat ~=0 & FeatMat~= timeStepSize))=1;
FeatMat(find(FeatMat== timeStepSize))=0;
FeatMat = reshape(FeatMat,numSense,numTimesteps);

[idxRow, idxCol] = find(FeatMat(:,1:end)==1);
for i=1:length(idxCol)-1,
    FeatMat(idxRow(i), idxCol(i):idxCol(i+1))=1;
end

% Calculate the labels using majority voting
% Labels  = reshape(data.labels(:,1:numTimesteps*timeStepSize),timeStepSize,numTimesteps);
% [~,idx] = max(histc(Labels,actList),[],1);
% Labels  = idx-1; 

% Calculte the labels using the last activity label in that time step
Labels = reshape(data.labels(:,1:numTimesteps*timeStepSize),timeStepSize,numTimesteps);
Labels = Labels(end,:);

if isfield(data,'labels2')
    Labels2 = reshape(data.labels2(:,1:numTimesteps*timeStepSize),timeStepSize,numTimesteps);
    Labels2 = Labels2(end,:);
end

% OUTPUT 
dataWithFeat.features   = FeatMat;
dataWithFeat.labels     = Labels;
if isfield(data,'labels2')
    dataWithFeat.labels2 = Labels2;
end
dataWithFeat.actList    = data.actList;
dataWithFeat.actLabels  = data.actLabels;
dataWithFeat.senseList  = data.senseList;
dataWithFeat.senseLabels= data.senseLabels;
dataWithFeat.startTime  = data.startTime;

[st,~] = dbstack;
pars.feature.extract.method = st(1).name; % save current function name
pars.feature.extract.actList  = actList;
pars.feature.extract.numAct   = length(actList);
pars.feature.extract.numSense = numSense;
pars.feature.extract.obsList  = sort(unique(FeatMat))';
pars.feature.extract.numVals  = length(pars.feature.extract.obsList);
end