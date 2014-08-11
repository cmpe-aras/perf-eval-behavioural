function learnedParams = train(curExp, pars)
% Learning of HMM parameters through maximum likelihood. 
% By counting parameters will be estimated

% Initialize parameters
smallValue  = pars.method.smallValue; % Used to avoid zero probabilties
numAct      = pars.feature.extract.numAct;
numSense    = pars.feature.extract.numSense;
actList     = pars.feature.extract.actList;
obsList     = pars.feature.extract.obsList;
numVals     = pars.feature.extract.numVals;

trainFeatMat= curExp.trainFeatMat;
trainLabels = curExp.trainLabels;

totalObsLabsPerClass    = zeros(numAct,1);
totalTransLabsPerClass  = zeros(numAct,1);

% Parameters
prior       = zeros(numAct,1);
obsModel    = zeros(numSense, numVals, numAct);
transModel  = zeros(numAct, numAct);

for n=1:length(trainFeatMat),
    
    % initial state distribution: sum[Label(n,1)]/totalNumberDays
    [~,I] = ismember(trainLabels{n}(1,1),actList);
    prior(I) = prior(I)+1;

    totalObsLabsPerClass    = totalObsLabsPerClass  + histc(trainLabels{n},actList)';
    totalTransLabsPerClass  = totalTransLabsPerClass+ histc(trainLabels{n}(1:end-1),actList)';

    for i=1:length(actList),
        % Find all occurances of activity actList(i)
        idxObs = find(trainLabels{n}==actList(i));
        
        if (isempty(idxObs))
            continue;
        end
        % observation model: sum[activity=i][sensor=j]/sum[activity=i]
        for j=1:numVals,
            obsModel(:,j,i) = obsModel(:,j,i)+sum(trainFeatMat{n}(:,idxObs)== obsList(j),2);            
        end

        idxTrans = find(trainLabels{n}(1:end-1)==actList(i));
        if (isempty(idxTrans))
            continue;
        end

        % transition model: sum[act_{t+1}=i][act_t=j]/sum[act_t=j]
        nextActidx = idxTrans + 1;

        % Count occurances of activity_{t+1}
        actCounts = histc(trainLabels{n}(nextActidx),actList);
        transModel(i, :) = transModel(i, :) + actCounts;
    end
end

% La place smoothing
prior       = (prior+smallValue)/(length(trainFeatMat)+smallValue);
obsModel    = (obsModel+smallValue)./repmat(reshape((totalObsLabsPerClass+(smallValue*numVals)),1,1,numAct),numSense,numVals);
transModel  = (transModel+smallValue)./repmat(totalTransLabsPerClass+(smallValue*numAct),1,numAct);

learnedParams.prior      = prior;
learnedParams.obsModel   = obsModel;
% Q x N matrix  where Q is the number of states
%learnedParams.obsModel  = reshape( obsModel(:,1,:), numAct,numSense);
learnedParams.transModel = transModel;
end