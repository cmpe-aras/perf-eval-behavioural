function [dataCleaned, pars] = removeDays(data,pars,daysToRemove)
% INPUT and OUTPUT
% dataCleaned and data contains features the dataset represented in days and are structs with
% .Features      : a {1 x numDays} cell array where each element is 
%                  a [numSensors x numTimeStepsPerDay] matrix 
%                  with the selected representation of the features
% .Labels        : a {1 x numDays} cell array where each element is
%                  a [1 x numTimeStepsPerDay] matrix where each column is the 
%                  ID of the activity label
% .Labels2       : (OPTIONAL) a {1 x numDays} cell array where each element is
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

index = 1;
for i=1:numDays
    if(~isempty(intersect(daysToRemove,i))) % if this day is in the list then skip
        disp(sprintf('Skipping day %d',i));
        continue;
    end
    dataCleaned.Labels{index}  = data.Labels{i};
    dataCleaned.Features{index}= data.Features{i};
    if isfield(data,'Labels2')
        dataCleaned.Labels2{index}  = data.Labels2{i};
    end
    index = index + 1;
end


% We may have thrown away some of the activities or features so we need to
% check them
if ~isfield(data,'Labels2')
    newActList = sort(unique([dataCleaned.Labels{:}]));
    if ~isempty(setdiff(data.actList,newActList)) % check if we removed some of the activities
        dataCleaned.actLabels = cellstr(char(data.actLabels{[newActList]}));
        dataCleaned.actList = 1:length(newActList);

        % Now correct the Labels as well
        for i=1:length(dataCleaned.Labels)
            [idxO,idxN] = intersect(newActList, dataCleaned.Labels{i});
            for j=1:length(idxO)
                dataCleaned.Labels{i}( find(dataCleaned.Labels{i}==idxO(j))) = idxN(j);
            end
        end
    else % if not we're good
        dataCleaned.actList   = 1:length(data.actLabels);
    end
else % we have 2 labels so we need to check them both
    newActList = sort(unique([dataCleaned.Labels{:} dataCleaned.Labels2{:}]));
    if ~isempty(setdiff(data.actList,newActList)) % check if we removed some of the activities
        dataCleaned.actLabels = cellstr(char(data.actLabels{[newActList]}));
        dataCleaned.actList = 1:length(newActList);

        % Now correct the Labels as well
        for i=1:length(dataCleaned.Labels)
            [idxO,idxN] = intersect(newActList, dataCleaned.Labels{i});
            for j=1:length(idxO)
                dataCleaned.Labels{i}( find(dataCleaned.Labels{i}==idxO(j))) = idxN(j);
            end
        end
        
        % Now correct the Labels2 as well
        for i=1:length(dataCleaned.Labels2)
            [idxO,idxN] = intersect(newActList, dataCleaned.Labels2{i});
            for j=1:length(idxO)
                dataCleaned.Labels2{i}( find(dataCleaned.Labels2{i}==idxO(j))) = idxN(j);
            end
        end
    else % if not we're good
        dataCleaned.actList   = 1:length(data.actLabels);
    end
end

% Did not changed them so they must be the same
dataCleaned.senseList  = data.senseList;
dataCleaned.senseLabels= data.senseLabels;

% These may have changed so update them
pars.feature.extract.actList  = dataCleaned.actList;
pars.feature.extract.numAct   = length(dataCleaned.actList);
pars.feature.extract.obsList  = sort(unique([dataCleaned.Features{:}]))';
pars.feature.extract.numVals  = length(pars.feature.extract.obsList);
pars.feature.split.numFolds = index-1;
end

