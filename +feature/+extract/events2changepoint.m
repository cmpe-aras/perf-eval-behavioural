function [data,pars] = events2changepoint(dSet, pars)

%%%% This function needs to be rewritten from scratch and should be split
%%%% into multiple functions so that there is more overlap with the other
%%%% approaches.

ss = dSet.ss;  % Load SensorStruct (StartTime EndTime ID Val)
as = dSet.as;  % Load ActStruct    (StartTime EndTime ID Val)
timeStepSize = pars.feature.extract.timeStepSize;  % Discretize in timeStepSize seconds
size1SegList = 1;  % Size 1 segment list

senseList   = ss.getIDs;            % Id's of the sensors in the dataset
numSense    = length(senseList);    % Number of sensors in the house
actList     = as.getIDs;            % Id's of the activities in the dataset

startTimestamp  = as(1).startsecs;     % The very first start time in the data set
endTimestamp    = as(as.len).endsecs;  % The very last end time in the data set

% Total number of timesteps according to discretization interval
numTimesteps = ceil((endTimestamp - startTimestamp)/timeStepSize)+1;

% Initialize Matrices to be filled in this function 
FeatMat = zeros(numSense, numTimesteps);
Labels  = zeros(1, numTimesteps);
Dates   = (startTimestamp + (0:(numTimesteps-1))*timeStepSize)/86400;
Segments= zeros(1, numTimesteps);
Activity_Map = zeros(length(actList),1);

for i=1:ss.len,   % This part handles the change point representation of the sensor values
    % Determine position in feature vector
    [dummy,idxS] = intersect(senseList,ss(i).id);
    
    % Determine time steps
    if (floor((ss(i).startsecs - startTimestamp)/timeStepSize)+1 > 0 & ceil((ss(i).endsecs - startTimestamp)/timeStepSize)+1>0)
        startSenseFire = floor((ss(i).startsecs - startTimestamp)/timeStepSize)+1;
        endSenseFire = ceil((ss(i).endsecs - startTimestamp)/timeStepSize)+1;
    else
        continue;
    end
    
    % In case sensor fired before first activity
    if (startSenseFire < 1)
        startSenseFire = 1;
    end        
    if (ss(i).startsecs > endTimestamp)
        continue;
    end
    if (ss(i).endsecs>endTimestamp)
        continue;
    end
    
    % Set value to 1 for sensor at time
    FeatMat(idxS, startSenseFire) = 1;
    FeatMat(idxS, endSenseFire) = 1;
end

segNum=1;
for i=1:as.len,
    % Determine position in feature vector
     [dummy,idxA] = intersect(actList,as(i).id);
     
     Activity_Map(idxA) = as(i).id;
    
    % Determine time steps
    startAct = floor((as(i).startsecs - startTimestamp)/timeStepSize)+1;
    endAct = ceil((as(i).endsecs - startTimestamp)/timeStepSize)+1;

    % Set value to 1 for sensor at time
    Labels(1, startAct:endAct) = idxA;
    
    if (ismember(as(i).id, size1SegList)) % use size 1 segments
        Segments(1, startAct:endAct) = segNum:segNum+(endAct-startAct);
        segNum = segNum+(endAct-startAct)+1;
    else
        Segments(1, startAct:endAct) = segNum;
        segNum= segNum+1;
    end
end

segDiff = Segments(2:end)-Segments(1:end-1);
startidx = find(segDiff<0);
startidx = startidx+1;
for i=1:length(startidx),
    idx = find(Segments(startidx(i):end)==Segments(startidx(i)));
    idx2 = find(idx(2:end) - idx(1:end-1) ~=1);
    if (isempty(idx2))
        sizSegm = length(idx)-1;
    else
        sizSegm = idx2(1)-1;
    end
    
    endidx = startidx(i) + sizSegm;
    
    if (Labels(startidx(i))==0)
        actID = 0;
    else
        actID = actList(Labels(startidx(i)));    
    end
    
    if (ismember(actID, size1SegList)) % use size 1 segments
        Segments(startidx(i):endidx) = segNum:segNum+sizSegm;
        segNum = segNum+sizSegm+1;
    else
        Segments(startidx(i):endidx) = segNum;
        segNum= segNum+1;
    end
end


%% Correct Idle activity
actList = unique(Labels); % 0 means IDLE activity
if (ismember(0,actList))  % If we have IDLE activity in the data set
    if (pars.feature.extract.useIdle) % if we want to use IDLE activity
        Labels = Labels + 1; % then we add one to every label so that IDLE activity becomes 1
        % other activities is shifted by one
        % We need to shift Activity_Map as well
        actMap = [0; Activity_Map]; 
    else
        % If we do not want to use IDLE then we simply remove instances
        % that have 0 as label
        idx = find(Labels ~= 0);
        Labels = Labels(idx);
        FeatMat= FeatMat(:,idx);
        Dates = Dates(idx);
        Segments = Segments(idx);
    end          
end

%% Store outputs
data.features   = FeatMat;
data.labels     = Labels;
data.dates      = Dates;
data.segments   = Segments;
data.activityMap= actMap;

[st,i] = dbstack;
pars.feature.extract.method = st(1).name; % save current function name
% pars.method.obsList    = [0 1]; %binary features
% pars.method.numAct     = length(actList); % This should be changed to a list of consecutive numbers (1:N)dd
% pars.method.actList    = 1:pars.methods.numAct;
%pars.method.numSense 	= size(FeatMat,1);
% pars.method.numVals    = length(pars.methods.obsList);