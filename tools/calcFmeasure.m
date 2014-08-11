function output = calcFmeasure(resultCell,pars)
numAct = pars.feature.extract.numAct;
confMat = zeros(numAct,numAct);
[nExperiment nRun]= size(resultCell);

for i = 1:nExperiment,
    for j= 1:nRun,
        result = resultCell{i,j};
        nResultsperFold = size(result,2);
        for idx = 1:nResultsperFold
            nDay = length(result(idx).inferedLabelsDays); % if we use more than one days for testing
            tempPrec = [];tempRec = [];tempAcc = [];
            for k = 1:nDay,
                hmmLabel = result(idx).inferedLabelsDays{k};
                gtLabel =  result(idx).inputData.testLabels{k};
                
                tempPrec(k) = calcPrecision(gtLabel, hmmLabel);
                tempRec(k) = calcRecall(gtLabel, hmmLabel);
                tempAcc(k) = calcTimeSliceAccuracy(gtLabel, hmmLabel);
                confMat = confMat + calcConfusionMatrix(gtLabel', hmmLabel', numAct);
            end % end Days
            precDays(i,j,idx) = mean(tempPrec);
            recDays(i,j,idx)  = mean(tempRec);
            accDays(i,j,idx) = mean(tempAcc);
            
            if (precDays(i,j,idx)==0 || recDays(i,j,idx)==0)
                FMesDays(i,j,idx) = 0;
            else
                FMesDays(i,j,idx) = (2*precDays(i,j,idx)*recDays(i,j,idx))/(precDays(i,j,idx)+recDays(i,j,idx));
            end
        end % end resultsperFold
    end % end Runs
    
    confMatCell{i} = confMat;
    confMat = zeros(numAct,numAct);
end % end Experiments

output.precision = precDays ;
output.recall  = recDays;
output.fMeasure = FMesDays;
output.confMat = confMatCell;
output.accDays = accDays;

end
