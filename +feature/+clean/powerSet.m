function [dataPowerSet, pars] = powerSet(data,pars)
% INPUT and OUTPUT
% dataCleaned and data contains features the dataset represented in days and are structs with
% .Features      : a {1 x numDays} cell array where each element is 
%                  a [numSensors x numTimeStepsPerDay] matrix 
%                  with the selected representation of the features
% .Labels        : a {1 x numDays} cell array where each element is
%                  a [1 x numTimeStepsPerDay] matrix where each column is the 
%                  ID of the activity label
% .Labels2       : a {1 x numDays} cell array where each element is
%                  a [1 x numTimeStepsPerDay] matrix where each column is the 
%                  ID of the activity label
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
%
% dataCleaned is the cleaned version of the input data according to the
% daysToRemove
%%

numDays = size(data.Features,2);
numAct = length(data.actList);
actMap = zeros(numAct,numAct);
%actList = zeros(1,numAct*numAct);
actList = 1:numAct*numAct;
index=1;
for i=1:numAct
    for j=1:numAct
        actMap(i,j) = index;
        actLabels{index}= strcat(data.actLabels{i},'-',data.actLabels{j});
        % which activity for first subject
        newMap(index,1) = i;
        newMap(index,2) = j;
        index = index+1;
    end
end


for i=1:numDays
    dataPowerSet.Features{i} = data.Features{i};
    dataPowerSet.Labels{i} = zeros(1, length(data.Labels{i}));
    
    for k=1:length(data.Labels{i})
       firstAct = data.Labels{i}(1,k);
       secondAct= data.Labels2{i}(1,k);
       dataPowerSet.Labels{i}(1,k) = actMap(firstAct,secondAct);
    end
end


% We may have thrown away some of the activities or features so we need to
% check them

newActList = sort(unique([dataPowerSet.Labels{:}]));
    toBeDeletedCombinations = setdiff(actList,newActList);
    newMap(toBeDeletedCombinations,:) = [];
    if ~isempty(toBeDeletedCombinations) % check if we removed some of the activities
        dataPowerSet.actLabels = cellstr(char(actLabels{[newActList]}));
        dataPowerSet.actList = 1:length(newActList);

        % Now correct the Labels as well
        for i=1:length(dataPowerSet.Labels)
            [idxO,idxN] = intersect(newActList, dataPowerSet.Labels{i});
            for j=1:length(idxO)
                dataPowerSet.Labels{i}( find(dataPowerSet.Labels{i}==idxO(j))) = idxN(j);
            end
        end
    else % if not we're good
        dataPowerSet.actList   = 1:length(dataPowerSet.actLabels);
    end


% Did not changed them so they must be the same
dataPowerSet.senseList  = data.senseList;
dataPowerSet.senseLabels= data.senseLabels;
dataPowerSet.activityMap= newMap;

% These may have changed so update them
pars.feature.extract.actList  = dataPowerSet.actList;
pars.feature.extract.numAct   = length(dataPowerSet.actList);
pars.feature.extract.obsList  = sort(unique([dataPowerSet.Features{:}]))';
pars.feature.extract.numVals  = length(pars.feature.extract.obsList);

end

