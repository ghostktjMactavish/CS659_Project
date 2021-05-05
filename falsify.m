function [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify(exp_params)
    for i = 1:size(exp_params.init_opts, 2)
       assignin('base', exp_params.init_opts{i}{1}, exp_params.init_opts{i}{2});
    end
    if strcmp(exp_params.algo_type, 's-taliro')
        [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_staliro(exp_params);
    elseif strcmp(exp_params.algo_type, 'RL')
        [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL(exp_params);
    end
end