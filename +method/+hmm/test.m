function [inferedLabelsDays, bestProbDays] = test(pars, learnedParams, testFeatMatDays)

prior       = learnedParams.prior;
obsModel    = learnedParams.obsModel;
transModel  = learnedParams.transModel;

numAct      = pars.feature.extract.numAct;
obsList     = pars.feature.extract.obsList;
numVals     = pars.feature.extract.numVals;

inferedLabelsDays   = cell(length(testFeatMatDays),1);
bestProbDays        = cell(length(testFeatMatDays),1);

for n=1:length(testFeatMatDays),
    % Viterbi algorithm as described in Rabiner 1989 (page 264)
    testFeatMat = testFeatMatDays{n};
    numTimeSteps = size(testFeatMat,2);

    inferedLabels = zeros(1,numTimeSteps);
    bestProb = zeros(numAct,numTimeSteps);
    bestState = zeros(numAct,numTimeSteps);

    % Calculate observation probability
    probObs = ones(1,numAct);
    for i=1:numVals,
        idxVal = find(testFeatMat(:,1)== obsList(i));
        probCurObs = prod(obsModel(idxVal,i,:),1);
        probObs = probObs .* reshape(probCurObs,1,numAct);
    end

    %%% 1) Initialization
    bestProb(:,1) = prior.*probObs';
    bestState(:,1) = 0;

    for k=2:numTimeSteps,
        %%% 2) Recursion
        % Calculate bestProb * transModel
        repBestProbs = repmat(bestProb(:,k-1),1,numAct);
        [Y,I] = max(repBestProbs .* transModel,[],1);
        maxLogTransProb=Y;
        bestState(:,k)=I';

    % Calculate observation probability
    probObs = ones(1,numAct);
    for i=1:numVals,
        idxVal = find(testFeatMat(:,k)== obsList(i));
        probCurObs = prod(obsModel(idxVal,i,:),1);
        probObs = probObs .* reshape(probCurObs,1,numAct);
    end
        bestProb(:,k) = (maxLogTransProb.*probObs)';
        % Normalize 
        bestProb(:,k) = normalize(bestProb(:,k));    
    end

    %%% 3) Termination
    [~,inferedLabels(numTimeSteps)] = max(bestProb(:,numTimeSteps));

    %%% 4) Path backtracking
    for k=numTimeSteps-1:-1:1
        inferedLabels(k) = bestState(inferedLabels(k+1),k+1);
    end

    inferedLabelsDays{n}    = inferedLabels;
    bestProbDays{n}         = bestProb;
end