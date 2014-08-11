function experiment(resultCell, pars, timestamp)
expOutput = resultCell;
%% Save results to a mat file
outFile = sprintf('%s\\expOutput_%s.mat',pars.results.save.directory ,timestamp);
save(outFile, 'expOutput','-v7.3');        
end