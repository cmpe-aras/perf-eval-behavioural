function [ data, pars ] = temporalCombination( data, pars )
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

numComb = pars.feature.extract.numTempComb;
numDays = size(data.Features,2);

for k=1:numDays
    
    features = data.Features{k};
    Y = zeros((2*numComb+1)*size(features,1), size(features,2));
    
    for i=1:size(features,2);
        combinedFeatures = features(:,i);
        
        for j=1:numComb
            prevIndex = i-j;
            nextIndex = i+j;
        
            if prevIndex > 0
                prevFeatures = features(:,prevIndex);
            else
                prevFeatures = zeros(size(features,1),1);
            end
        
            if nextIndex < size(features,2)+1
                nextFeatures = features(:,nextIndex);
            else
                nextFeatures = zeros(size(features,1),1);
            end
        
            combinedFeatures = [ prevFeatures; combinedFeatures; nextFeatures ];
        end
    
        Y(:,i) = combinedFeatures;
    end
    
    data.Features{k} = Y;
end

% update parameters
pars.feature.extract.numSense = (2*numComb+1)*pars.feature.extract.numSense;

end

