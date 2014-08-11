function pars = defaultTypeParametersActivityRecognition

pars = defaultParameters;

pars.experiment = defaultParametersExperiment;

pars.feature = defaultParametersFeatures;
pars.feature.extract.timeStepSize = 60; % seconds % size to discretize data with in seconds
pars.feature.extract.useIdle = 1;       % Include idle class
pars.feature.extract.useShortDays = 1;  % Include days that contain less data points than it should
pars.feature.split.startHour = 3; % At which hour should the day start, 3 am is best because it cuts in the sleep cycle

pars.method = defaultParametersMethods;
pars.method.max_iter = 100;
pars.method.smallValue = 0.01;
pars.method.min_iter = 5;

pars.result = defaultParametersResults;
