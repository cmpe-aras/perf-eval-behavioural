%% ARAS House A
clear all
pars = experiment.configure.parameters('activity recognition');
pars.experiment.description = 'HMM with leave one out cross validation'; 
data = prepAras('HouseA');
data.observations(2, data.labels == 10) = 1;

pars.feature.split.startHour = 0;
pars.feature.split.rearrange = 0;
pars.feature.extract.timeStepSize  = 60; % seconds to discretize data

[data, pars] = feature.extract.raw(data, pars);
%[data, pars] = feature.extract.changePoint(data, pars);

[data, pars] = feature.split.inDays(data, pars);

% Remove second user
for i=1:length(data.Labels)
    idx = find(data.Labels2{i} == 1);
    labels{i} = data.Labels{i}(idx);
    features{i} = data.Features{i}(:,idx);
end

data2.Features = features;
data2.Labels = labels;
data2.actlist = data.actList;
data2.actLabels = data.actLabels;
data2.senseList = data.senseList;
data2.senseLabels = data.senseLabels;

[data, pars] = feature.clean.cleanDataset(data2, pars);

clear data2 features labels idx i;
[data, pars] = feature.clean.mergeActivities(data,pars,{[3 5 7],[4 6 8],[13 17 18]});
[data, pars] = feature.clean.removeActivities(data,pars,[12 13 16 17 18]);

[hmm, pars]  = method.hmm.init(pars);
methodCell = {hmm};
disp('Running cross validation'); 
resultCell = experiment.crossvalidate.nFold(data,methodCell,pars);
perfCell = result.prep.frameSegmentResults(resultCell,pars);
data.actLabels{1}='IDLE';
data.actLabels{2}='Outside';
data.actLabels{3}='Preparing Meal';
data.actLabels{4}='Having Meal';
data.actLabels{5}='Washing dishes';
data.actLabels{6}='Snack';
data.actLabels{7}='Sleeping';
data.actLabels{8}='Watching TV';
data.actLabels{9}='Studying';
data.actLabels{10}='Taking shower';
data.actLabels{11}='Toileting';
data.actLabels{12}='Brushing teeth';
data.actLabels{13}='Telephone';
data.actLabels{14}='Dressing';

%% ARAS House B
clear all
pars = experiment.configure.parameters('activity recognition');
pars.experiment.description = 'HMM with leave one out cross validation'; 
data = prepAras('HouseB');

pars.feature.split.startHour = 0;
pars.feature.split.rearrange = 0;
pars.feature.extract.timeStepSize  = 60; % seconds to discretize data

[data, pars] = feature.extract.raw(data, pars);
%[data, pars] = feature.extract.changePoint(data, pars);

[data, pars] = feature.split.inDays(data, pars);

% Remove second user
for i=1:length(data.Labels)
    idx = find(data.Labels2{i} == 1);
    labels{i} = data.Labels{i}(idx);
    features{i} = data.Features{i}(:,idx);
end

data2.Features = features;
data2.Labels = labels;
data2.actlist = data.actList;
data2.actLabels = data.actLabels;
data2.senseList = data.senseList;
data2.senseLabels = data.senseLabels;

[data, pars] = feature.clean.cleanDataset(data2, pars);

clear data2 features labels idx i;

[data, pars] = feature.clean.mergeActivities(data,pars,{[3 5 7],[4 6 8]});
[data, pars] = feature.clean.removeActivities(data,pars,[5 12 13 14 16]);

data.actLabels{1}='IDLE';
data.actLabels{2}='Outside';
data.actLabels{3}='Preparing Meal';
data.actLabels{4}='Having Meal';
data.actLabels{5}='Snack';
data.actLabels{6}='Sleeping';
data.actLabels{7}='Watching TV';
data.actLabels{8}='Studying';
data.actLabels{9}='Taking shower';
data.actLabels{10}='Toileting';
data.actLabels{11}='Brushing teeth';
data.actLabels{12}='Dressing';

[hmm, pars]  = method.hmm.init(pars);
methodCell = {hmm};
disp('Running cross validation'); 
resultCell = experiment.crossvalidate.nFold(data,methodCell,pars);
perfCell = result.prep.frameSegmentResults(resultCell,pars);
