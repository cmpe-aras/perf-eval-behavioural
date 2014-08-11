function outTesting = nFold(data, methodCell, pars)
% This function handles the cross validation for a given dataSet called
% data for given methods in methodCell

stepDays    = pars.experiment.crossvalidate.stepFolds;
numFolds    = pars.feature.split.numFolds; % Number of days in this dataset
availDays   = 1:numFolds; 
numMethods  = length(methodCell); % Number of methods to be compared in cross validation
outTesting  = cell(numMethods,numFolds); % the outputs will be saved in this structure

disp(sprintf('Cycling over %d methods',numMethods));
for iMethod=1:numMethods,
    % Cycle over methods
    methodName = methodCell{iMethod}.name;
    disp(sprintf('Cross validation for %s started. Total number of folds is %d', methodName, numFolds));
    % Cycle over folds

    for iFold=1:stepDays:numFolds,
        disp(sprintf('Running fold %d/%d' ,iFold,numFolds));
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
        
        % Dimensionality reduction
        if isfield(pars.feature.extract, 'dimReduceMethod')
            dimReduceMethod = strcat('feature.extract.',...
                pars.feature.extract.dimReduceMethod);
            [curExp, pars] = feval(dimReduceMethod, curExp, pars);
        end
        
        % Find the function to be called 
        modelExperiment = strcat('method.',methodName,'.experiment'); 
        outTesting{iMethod,iFold} = feval(modelExperiment, curExp, pars);
    end
end

end