function out = experiment(curExp, info)
% This function describes the experiment process for the given method
% For hmm it contains a training and a testing method

% out is a cell struct of the form 
% learnedParameters
% inputData
% inferedLabelsDays
out={};
out(end+1).learnedParameters = method.hmm.train(curExp, info);
out(end).inputData = curExp;
[out(end).inferedLabelsDays ~]= method.hmm.test(info, out.learnedParameters, curExp.testFeatMat );
end