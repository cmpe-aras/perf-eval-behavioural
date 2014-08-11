function folds = prepareFolds(data, pars)
% This function handles the cross validation for a given dataSet called
% data for given methods in methodCell

stepDays    = pars.experiment.crossvalidate.stepFolds;
numFolds    = pars.feature.split.numFolds; % Number of days in this dataset
availDays   = 1:numFolds; 
folds  = cell(1,numFolds); % the outputs will be saved in this structure

    for iFold=1:stepDays:numFolds,
        testDays = iFold:min((iFold+(stepDays-1)),numFolds);
        trainDays = availDays(~ismember(availDays,testDays));
        
        % Create structure for current experiment
        curExp.trainFeatMat = data.Features(trainDays);
        curExp.trainLabels  = data.Labels(trainDays);
        
        if (size(curExp.trainFeatMat,2) == 0)
            error('Empty training matrix');
        end
        
        curExp.testFeatMat  = data.Features(testDays);
        curExp.testLabels   = data.Labels(testDays);
        
        if (size(curExp.testFeatMat,2) == 0)
            error('Empty test matrix');
        end
        
        folds{iFold} = curExp;
        
    end
end