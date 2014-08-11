function resultCell = runExperiment(dSet, feature, methods)
% script for running cross validation experiment on single dataset, for
% single feature configuration using multiple methods.

% Load datasets
dSet = prepTimHuis2;

% global experiment parameters
globPars.timeStepSize = 60; % seconds % size to discretize data with in seconds
globPars.stepDays = 1;      % Number of days per testset
globPars.useIdle = 1;       % Include idle class
globPars.verbose = 1;
globPars.max_iter = 25;
globPars.max_iter = 10;
globPars.smallValue = 0.01;
globPars.realTimeEval = 0; % Use 1 second accuracy
globPars.cutHour = 3; % At which hour should the day start, 3 am is best because it cuts in the sleep cycle
globPars.realTimeEval = 0; % Use 1 second accuracy

% globPars.reduceIdle = 1;
globPars.size1SegList = []; % 0 = idle, rest according to as.getIDs
durationModel =  2; %1: gamma, 2: gauss

% Load configurations
globPars.timeStepSize = 60; % 1 minute

data = features.extract.events2changepoint(dSet)
data = features.clean.cleanData(data);
dataCell = features.split.inDays(data);

info = features.info.createModelInfo(dataCell, dSet);

hmm = methods.probabilistic.hmm(info);
crf = methods.probabilistic.crf(info);

resultCell = experiment.crossvalidate.nFold(dataCell, {hmm, crf});

