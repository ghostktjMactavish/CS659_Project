function [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify(exp_params)
    for i = 1:size(exp_params.init_opts, 2)
       assignin('base', exp_params.init_opts{i}{1}, exp_params.init_opts{i}{2});
    end
    if strcmp(exp_params.algo_type, 's-taliro')
        [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_staliro(exp_params);
    elseif strcmp(exp_params.algo_type, 'RL')
        %[numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL_ddqn(exp_params);
        %[numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL_a3c(exp_params);
        %[numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL_dqn(exp_params);
        [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL_pcl(exp_params);
        %[numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL_catdqn(exp_params);
    end
end