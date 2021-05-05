function run_experiment(modelname, experiments)
 results = table('Size', [0 8],...
     'VariableTypes', {'int32', 'string', 'string', 'string', 'double', 'int32', 'double', 'double'},...
     'VariableNames', {'id', 'modelName', 'expName', 'algoName', 'sampleTime',...
     'numEpisode', 'elapsedTime', 'bestRob'});
 global logDir;
 %st = experiments(1).sampleTime;
 logFile = fullfile(logDir, [modelname, '.csv']);
 id = 1;
 for i = 1:size(experiments, 2)
         exp_params = experiments(i);
         
         [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify(exp_params);
         
         result = {i, modelname, exp_params.expName, exp_params.algoName, exp_params.sampleTime,numEpisode, elapsedTime, bestRob};
         results(i,:) = result;%[results; result];
         writetable(results, logFile);
         fname = [modelname, '_', exp_params.expName,'_', num2str(i)];
         
         file = fullfile(logDir, [fname,  '.mat']);
         save(file, 'bestXout', 'bestYout', 'exp_params');
 end
end



























