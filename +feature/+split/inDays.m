function [dataInDays, pars] = inDays(data, pars)
% This function groups the feature representations in days
% INPUT 
% data contains the features representation in the dataset and is a struct with
% .features      : a [numSensors x numTimesteps] matrix where each column
%                  is the change point representation of the features
% .labels        : a [1 x numTimesteps] matrix where each column
%                  is the ID of the activity label
% .labels2       : (OPTIONAL) a [1 x numTimesteps] matrix where each column
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
% dataInDays contains the features representation in the dataset in days and is a struct with
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
% pars is a struct that contains the parameters
%%

startHour    = pars.feature.split.startHour;       % Start at which hour of the day
timeStepSize = pars.feature.extract.timeStepSize;  % Incoming data is discretized in this many seconds

% Total number of seconds in a day is 24 hours * 60 minutes * 60 seconds
NUM_SECONDS_IN_DAY = 86400;

% Total number of data points we have in our data set
numTotalTimeSteps = size(data.features,2);

% We have numTimeStepsPerDay data points in one day
numTimeStepsPerDay = floor(NUM_SECONDS_IN_DAY / timeStepSize);

% We have numDays days in our data set
numDays = ceil(numTotalTimeSteps/numTimeStepsPerDay);

% Find starting index of our day
startIdxForDay = ceil(((startHour * 3600) - data.startTime)/ timeStepSize);

if startIdxForDay < 0 % starting time is greater than the startHour
    startIdxForDay =  numTimeStepsPerDay - floor((data.startTime -(startHour * 3600))/ timeStepSize);
end

if(startIdxForDay <= 0)
    startIdxForDay = 1;
    warning('We cannot make start hour change you requested, sorry!');
end
    
if(pars.feature.split.rearrange)
    Features = cell(1,numDays);
    Labels   = cell(1,numDays);
    
    if isfield(data,'labels2')
        Labels2   = cell(1,numDays);
    end
    
    for i=1:numDays
        startIdx = (i-1)*numTimeStepsPerDay+1;
        endIdx   = i*numTimeStepsPerDay;
        if(endIdx > numTotalTimeSteps)
            endIdx = numTotalTimeSteps;
        end

        feat  = data.features(:,startIdx:endIdx);
        label = data.labels(:,startIdx:endIdx);
        
        if isfield(data,'labels2')
            label2 = data.labels2(:,startIdx:endIdx);
        end

        if(startIdxForDay > 1)
            if(size(feat,2) < numTimeStepsPerDay) % We have short day
                Features{i}= feat(:,startIdxForDay:end);
                Labels{i}  = label(:,startIdxForDay:end);
                
                if isfield(data,'labels2')
                    Labels2{i}  = label2(:,startIdxForDay:end);
                end
            else
                Features{i}= [ feat(:,startIdxForDay:end)  feat(:,1:startIdxForDay-1) ];
                Labels{i}  = [ label(:,startIdxForDay:end) label(:,1:startIdxForDay-1)]; 
                
                if isfield(data,'labels2')
                    Labels2{i}  = [ label2(:,startIdxForDay:end) label2(:,1:startIdxForDay-1)]; 
                end
            end
        else % We cannot change the start times
            Features{i}= feat;
            Labels{i}  = label; 
            if isfield(data,'labels2')
               Labels2{i}  = label2; 
            end
        end
    end
else % do not rearrange but just remove   
    % remove data  
    data.features = data.features(:,startIdxForDay:end);
    data.labels = data.labels(:,startIdxForDay:end);
    if isfield(data,'labels2')
        data.labels2 = data.labels2(:,startIdxForDay:end);
    end
            
    numTotalTimeSteps = size(data.features,2);

    % recalculate numDays
    numDays = ceil(numTotalTimeSteps/numTimeStepsPerDay);

    Features = cell(1,numDays);
    Labels   = cell(1,numDays);
    
    if isfield(data,'labels2')
        Labels2  = cell(1,numDays);
    end
    
    for i=1:numDays
        startIdx = (i-1)*numTimeStepsPerDay+1;
        endIdx   = i*numTimeStepsPerDay;
        if(endIdx > numTotalTimeSteps)
            endIdx = numTotalTimeSteps;
        end

        Features{i}  = data.features(:,startIdx:endIdx);
        Labels{i} = data.labels(:,startIdx:endIdx);
        if isfield(data,'labels2')
            Labels2{i} = data.labels2(:,startIdx:endIdx);
        end
    end
end % end rearrange

% OUTPUT
dataInDays.Features    = Features;
dataInDays.Labels      = Labels ;
if isfield(data,'labels2')
    dataInDays.Labels2      = Labels2;
end
dataInDays.actList     = data.actList;
dataInDays.actLabels   = data.actLabels;
dataInDays.senseList   = data.senseList;
dataInDays.senseLabels = data.senseLabels;

[st,~] = dbstack;
pars.feature.split.method   = st(1).name; % save current function name
pars.feature.split.numFolds = numDays;
end

