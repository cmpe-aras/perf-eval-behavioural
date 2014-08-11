function [dataCleaned, pars] = cleanDataset(data, pars)
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
% parameters
%%

numDays = size(data.Features,2);

% Find the number of data points in the longest day
% It will be used in skip short days option
maxLength = 0; 
for i=numDays
    if( size(data.Features{i},2) > maxLength )
        maxLength = size(data.Features{i},2);
    end
end

index = 1;
for i=1:numDays
    % If we have empty features
    if (sum(sum(data.Features{i},2),1) == 0) 
        disp(sprintf('Found empty features. Skipping day %d',i));
        continue;
    end
    
    % If we have only one activity skip
    if ~isfield(data,'Labels2')
        if (length(unique(data.Labels{i})) == 1)
            disp(sprintf('Found only one activity. Skipping day %d',i));
            continue;
        end
    else
        if (length(unique(data.Labels{i})) == 1 && length(unique(data.Labels2{i})) == 1)
            disp(sprintf('Found only one activity for all labels. Skipping day %d',i));
            continue;
        end
    end
    
    % If we do not want to include short days skip
    if(pars.feature.extract.useShortDays == 0)
        if( size(data.Features{i},2) < maxLength )
            disp(sprintf('Found short day. Skipping day %d',i));
            continue;
        end
    end
    
    % If we want to include IDLE acitivty
    if(pars.feature.extract.useIdle)
        % We add one to every label so that IDLE activity becomes 1
        dataCleaned.Labels{index}  = data.Labels{i}+1;
        dataCleaned.Features{index}= data.Features{i};
        if isfield(data,'Labels2')
            dataCleaned.Labels2{index}  = data.Labels2{i}+1;
        end
    else
        % If we do not want to use IDLE then we simply remove instances
        % that have 0 as label
        idx = find(data.Labels{i}~=0);
        dataCleaned.Labels{index}  = data.Labels{i}(idx);
        if isfield(data,'Labels2')
            dataCleaned.Labels2{index}  = data.Labels2{i}(idx);
        end
        dataCleaned.Features{index}= data.Features{i}(:,idx);
    end
    index = index + 1;
end

if(pars.feature.extract.useIdle)
    disp('Using IDLE activity');
    dataCleaned.actLabels = ['IDLE'; data.actLabels];
    dataCleaned.actList   = 1:length(dataCleaned.actLabels);
else 
    dataCleaned.actLabels = data.actLabels;
    dataCleaned.actList   = 1:length(dataCleaned.actLabels);
end

% % We may have thrown away some of the activities or features so we need to
% % check them
% if ~isfield(data,'Labels2')
%     newActList = sort(unique([dataCleaned.Labels{:}]));
%     if ~isempty(setdiff(data.actList,newActList)) % check if we removed some of the activities
%         dataCleaned.actLabels = cellstr(char(dataCleaned.actLabels{[newActList]}));
%         dataCleaned.actList = 1:length(newActList);
% 
%         % Now correct the Labels as well
%         for i=1:length(dataCleaned.Labels)
%             [idxO,idxN] = intersect(newActList, dataCleaned.Labels{i});
%             for j=1:length(idxO)
%                 dataCleaned.Labels{i}( find(dataCleaned.Labels{i}==idxO(j))) = idxN(j);
%             end
%         end
%     else % if not we're good
%         dataCleaned.actList   = 1:length(dataCleaned.actLabels);
%     end
% else % we have 2 labels so we need to check them both
%     newActList = sort(unique([dataCleaned.Labels{:} dataCleaned.Labels2{:}]));
%     if ~isempty(setdiff(data.actList,newActList)) % check if we removed some of the activities
%         dataCleaned.actLabels = cellstr(char(dataCleaned.actLabels{[newActList]}));
%         dataCleaned.actList = 1:length(newActList);
% 
%         % Now correct the Labels as well
%         for i=1:length(dataCleaned.Labels)
%             [idxO,idxN] = intersect(newActList, dataCleaned.Labels{i});
%             for j=1:length(idxO)
%                 dataCleaned.Labels{i}( find(dataCleaned.Labels{i}==idxO(j))) = idxN(j);
%             end
%         end
%         
%         % Now correct the Labels2 as well
%         for i=1:length(dataCleaned.Labels2)
%             [idxO,idxN] = intersect(newActList, dataCleaned.Labels2{i});
%             for j=1:length(idxO)
%                 dataCleaned.Labels2{i}( find(dataCleaned.Labels2{i}==idxO(j))) = idxN(j);
%             end
%         end
%     else % if not we're good
%         dataCleaned.actList   = 1:length(dataCleaned.actLabels);
%     end
% end

% Did not changed them so they must be the same
dataCleaned.senseList  = data.senseList;
dataCleaned.senseLabels= data.senseLabels;

% These may have changed so update them
pars.feature.extract.actList  = dataCleaned.actList;
pars.feature.extract.numAct   = length(dataCleaned.actList);
pars.feature.extract.obsList  = sort(unique([dataCleaned.Features{:}]))';
pars.feature.extract.numVals  = length(pars.feature.extract.obsList);
pars.feature.split.numFolds   = index-1;
end

