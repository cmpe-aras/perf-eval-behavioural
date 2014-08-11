function results(performanceCell, pars, timestamp)
resultOutput = performanceCell;
%% Save results to a mat file
outFile = sprintf('%s\\resultOutput_%s.mat',pars.results.save.directory, timestamp);
save(outFile, 'resultOutput','-v7.3');        
end