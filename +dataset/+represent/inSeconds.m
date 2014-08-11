function [data] = inSeconds(dSet)
% This function puts Tim's data set into seconds format
% INPUT is a struct with
% .name             : string contains the name of the data set
% .ss               : a sensorstruct contains the sensor readings for the data set
% .as               : an actstruct contains the activity labels for the data set
% .sensor_labels    : a {numSensors x 2} cell array that relates the id's of the sensors
%                     to the actual names and locations of the sensors
% .activity_labels  : a {numActivities x 1} cell array that relates the id's of the activities
%                     to the actual names of the labels
%
% OUTPUT is a struct with
% .observations  : a [numSensors x lengthOfDataset] matrix where each column
%                  is a representation of all sensor readings in a second
% .labels        : a [1 x lengthOfDataset] matrix where each column
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

ss = dSet.ss;  % Load SensorStruct (StartTime EndTime ID Val)
as = dSet.as;  % Load ActStruct    (StartTime EndTime ID Val)

senseList   = ss.getIDs;            % Id's of the sensors in the dataset
actList     = as.getIDs;            % Id's of the activities in the dataset
numSense    = length(senseList);    % Number of sensors in the house

startTimestamp  = as(1).startsecs;     % The very first start time in the data set
endTimestamp    = as(as.len).endsecs;  % The very last end time in the data set

% Total number of timesteps in seconds
numTimesteps = ceil(endTimestamp - startTimestamp);

% Initialize Matrices to be filled in this function 
FeatMat = zeros(numSense, numTimesteps);
Labels  = zeros(1, numTimesteps);

for i=1:ss.len,   
    % Determine position in feature vector
    [~,idxS] = intersect(senseList,ss(i).id);
    
    startSenseFire = floor(ss(i).startsecs - startTimestamp);
    endSenseFire   = ceil(ss(i).endsecs - startTimestamp);
    
    % In case sensor fired and ended before first activity
    if (startSenseFire > numTimesteps || endSenseFire <= 0)
        continue;
    end

    % In case sensor fired before first activity
    if (startSenseFire <= 0)
        startSenseFire = 1;
    end
    
    if (endSenseFire > numTimesteps)
        endSenseFire = numTimesteps;
    end

    FeatMat(idxS, startSenseFire:endSenseFire) = 1;
end

for i=1:as.len,
    % Determine position in feature vector
     [~,idxA] = intersect(actList,as(i).id);
    
    % Determine time steps
    startAct = floor(as(i).startsecs - startTimestamp);
    if(i==1 && startAct <= 0)
        startAct = 1;
    end
    endAct   = ceil(as(i).endsecs - startTimestamp);
    
    % Set value to 1 for sensor at time
    Labels(1, startAct:endAct) = idxA;
end

% Prepare OUTPUT
data.observations  = FeatMat;
data.labels        = Labels;
data.actList       = actList; 
data.actLabels     = cellstr(char(dSet.activity_labels{[actList]}));
data.senseList     = senseList;
data.senseLabels   = cellstr(char(dSet.sensor_labels{:,2}));
data.startTime     = as(1).starttime;
end