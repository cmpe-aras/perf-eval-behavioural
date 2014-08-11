%% HOUSE A
pars = experiment.configure.parameters('activity recognition');
pars.experiment.description = 'HMM with leave one out cross validation';
load('./datasets/Tim/houseA/HouseA_CP.mat');
pars.feature.split.numFolds = length(data.Features);
[hmm, pars]  = method.hmm.init(pars);
pars.feature.extract.numAct = 10;
pars.feature.extract.numSense = 14;
pars.feature.extract.actList = 1:10;
pars.feature.extract.obsList = [0 1];
pars.feature.extract.numVals = 2;

methodCell = {hmm};
disp('Running cross validation'); 
resultCell = experiment.crossvalidate.nFold(data,methodCell,pars);

perfCell = result.prep.frameResults(resultCell,pars);


%% House B
pars = experiment.configure.parameters('activity recognition');
pars.experiment.description = 'HMM with leave one out cross validation';
load('./datasets/Tim/houseB/HouseB_CP.mat');
pars.feature.split.numFolds = length(data.Features);
[hmm, pars]  = method.hmm.init(pars);
pars.feature.extract.numAct = 14;
pars.feature.extract.numSense = 23;
pars.feature.extract.actList = 1:14;
pars.feature.extract.obsList = [0 1];
pars.feature.extract.numVals = 2;
methodCell = {hmm};
disp('Running cross validation'); 
resultCell = experiment.crossvalidate.nFold(data,methodCell,pars);

perfCell = result.prep.frameResults(resultCell,pars);




%% House C
clear all
pars = experiment.configure.parameters('activity recognition');
pars.experiment.description = 'HMM with leave one out cross validation';
load('./datasets/Tim/houseC/HouseC_CP.mat');
pars.feature.split.numFolds = length(data.Features);
[hmm, pars]  = method.hmm.init(pars);
pars.feature.extract.numAct = 16;
pars.feature.extract.numSense = 21;
pars.feature.extract.actList = 1:16;
pars.feature.extract.obsList = [0 1];
pars.feature.extract.numVals = 2;
methodCell = {hmm};
disp('Running cross validation'); 
resultCell = experiment.crossvalidate.nFold(data,methodCell,pars);

perfCell = result.prep.frameResults(resultCell,pars);

%% Perf Eval

[nExp nFold nAct] = size(perfCell);
for exp = 1:nExp
    for  act = 1:nAct
        FrameStats = zeros(2,5);
        EventStats = zeros(2,5);
        for  fold = 1:nFold
            FrameStats = FrameStats + perfCell{exp,fold,act}.FrameStats;
            
            GT = perfCell{exp,fold,act}.GtActSegments;
            for i=1:numel(GT)
                if(strcmp(GT(i).type,'D'))
                    EventStats(1,1) = EventStats(1,1) + 1;
                elseif(strcmp(GT(i).type,'F'))
                    EventStats(1,2) = EventStats(1,2) + 1;
                elseif(strcmp(GT(i).type,'FM'))
                    EventStats(1,3) = EventStats(1,3) + 1;
                elseif(strcmp(GT(i).type,'M'))
                    EventStats(1,4) = EventStats(1,4) + 1;
                elseif(strcmp(GT(i).type,'C'))
                    EventStats(1,5) = EventStats(1,5) + 1;
                else
                    disp('Err');
                end
            end
            
            OUT = perfCell{exp,fold,act}.OutActSegments;
            for i=1:numel(OUT)
                if(strcmp(OUT(i).type,'C'))
                    EventStats(2,1) = EventStats(2,1) + 1;
                elseif(strcmp(OUT(i).type,'Mprime'))
                    EventStats(2,2) = EventStats(2,2) + 1;
                elseif(strcmp(OUT(i).type,'FMprime'))
                    EventStats(2,3) = EventStats(2,3) + 1;
                elseif(strcmp(OUT(i).type,'Fprime'))
                    EventStats(2,4) = EventStats(2,4) + 1;
                elseif(strcmp(OUT(i).type,'Iprime'))
                    EventStats(2,5) = EventStats(2,5) + 1;
                else
                    disp('Err 2');
                end
            end
        end % End folds
        
        P(act,:) = FrameStats(1,:);
        N(act,:) = FrameStats(2,:);
        
        EADAct(act,:) =  EventStats(1,:);
        EADRet(act,:) =  EventStats(2,:);
    end
end
B = [EADAct EADRet(:,2:end)];