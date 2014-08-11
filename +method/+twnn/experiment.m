function out = experiment(curExp, pars)
% This function describes the experiment process for the given method
% For TWNN it contains a training and a testing method

% out is a cell struct of the form 
% learnedParameters
% inputData
% inferedLabelsDays
out={};
out(end+1).learnedParameters = method.twnn.train(curExp, pars);
out(end).inputData = curExp;
[out(end).inferedLabelsDays]= method.twnn.test(pars, out.learnedParameters, curExp.testFeatMat );
end