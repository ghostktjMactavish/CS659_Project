function [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_staliro(exp_params)
    options = staliro_options();
    options.interpolationtype = exp_params.interpolation;
    options.fals_at_zero = 0;
    if strcmp(exp_params.option, 'CE')
        options.optimization_solver = 'CE_Taliro';
    end
    options.optim_params.n_tests = exp_params.maxEpisodes;
    time = repelem(exp_params.stopTime / exp_params.sampleTime, size(exp_params.input_range, 1));
    [results, ~, ~] = staliro(exp_params.simlink_model,[], exp_params.input_range,time,exp_params.targetFormula, exp_params.preds, exp_params.stopTime, options);
    numEpisode = results.run.nTests;
    elapsedTime = results.run.time;
    bestRob = results.run.bestRob;
    bestXout = results.run.bestSample;
    bestYout = [];
end
