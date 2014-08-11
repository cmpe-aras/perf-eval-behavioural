function [dataCleaned, pars] = mergeActivities(data,pars,actsToMerge)
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
% actsToMerge    : a cell array contining the lists of activities to be
%                  merged. Activities are mapped to the smallest ID
%
% dataCleaned is the cleaned version of the input data according to the
% 
%%

numDays = size(data.Features,2);

% Assuming we have IDLE activity whose label is 1
for i=1:numDays
    dataCleaned.Labels{i} = data.Labels{i};
    dataCleaned.Features{i} = data.Features{i};
    if isfield(data,'Labels2')
        dataCleaned.Labels2{i} = data.Labels2{i};
    end
    
    for j=1:length(actsToMerge)
        actsListMerged = actsToMerge{j};
        
        % Map activities to the smallest one
        newActId = min(actsListMerged);
        
        actsListMerged = setdiff(actsListMerged,newActId);
        
        for k=1:length(actsListMerged)
            if (i==1)
                disp(sprintf('Merging activity %d as %d',actsListMerged(k),newActId));
            end
            if ~isempty( find( data.Labels{i} == actsListMerged(k)))
                dataCleaned.Labels{i}(find(data.Labels{i} == actsListMerged(k)))= newActId;
            end
            if isfield(data,'Labels2') && ~isempty( find( data.Labels2{i} == actsListMerged(k)))
                dataCleaned.Labels2{i}(find(data.Labels2{i} == actsListMerged(k)))= newActId;
            end
        end
    end
end


% We may have thrown away some of the activities or features so we need to
% check them
if ~isfield(data,'Labels2')
    newActList = sort(unique([dataCleaned.Labels{:}]));
    if ~isempty(setdiff(data.actList,newActList)) % check if we removed some of the activities
        if(~isempty(data.actLabels{1}))
            dataCleaned.actLabels = cellstr(char(data.actLabels{[newActList]}));
        end
        dataCleaned.actList = 1:length(newActList);
        
        % Now correct the Labels as well
        for i=1:length(dataCleaned.Labels)
            [idxO,idxN] = intersect(newActList, dataCleaned.Labels{i});
            for j=1:length(idxO)
                dataCleaned.Labels{i}( find(dataCleaned.Labels{i}==idxO(j))) = idxN(j);
            end
        end
    else % if not we're good
        dataCleaned.actList   = 1:length(dataCleaned.actLabels);
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

end

