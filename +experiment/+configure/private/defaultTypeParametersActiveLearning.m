function pars = defaultTypeParametersActiveLearning

pars = defaultParameters;

pars.experiment = defaultParametersExperiment;

pars.feature = defaultParametersFeatures;

pars.feature.extract.timeStepSize  = 60; % seconds to discretize data
pars.feature.extract.useIdle       = 1;  % Include idle class

pars.feature.split.startHour = 3; % At which hour should the day start, 
                                   % 3 am is best because it cuts in the sleep cycle

pars.method = defaultParametersMethods;
pars.method.max_iter = 25;
pars.method.smallValue = 0.01;

pars.result = defaultParametersResults;
