function [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify_RL(expParams)

    py.DDQN_agent.hello();
    % Load Simulink Model
    load_system(expParams.simlink_model);
    bestRob = inf;
    preds_normalized = normalize_pred(expParams.preds, expParams.output_range);
%     if isfield(expParams, 'alpha')
%         py.DDQN_agent.train(expParams.option,...
%             size(expParams.output_range, 1), size(expParams.input_range, 1),...
%             expParams.alpha);
%     else
    py.DDQN_agent.train(expParams.option,...
            size(expParams.output_range, 1), size(expParams.input_range, 1), 1);
    tic;


    for numEpisode=1:expParams.maxEpisodes
        [~, inputs, outputs] = getObs(expParams, preds_normalized);
        [state, T, robustness] = process_output(outputs);
        rob = dp_taliro(expParams.targetFormula, preds_normalized, state, T, [], [], []);
        py.DDQN_agent.stop_episode_and_train(state(end, :), exp(- robustness) - 1);
        disp(['Current iteration: ', num2str(numEpisode), ', rob = ', num2str(rob)])
        if rob <= bestRob
            bestRob = rob;
            bestYout = outputs;
            bestXout = inputs;
            if rob < 0
                break;
            end
        end
        py.DDQN_agent.save(strcat('./agents/',expParams.simlink_model));
    end
    elapsedTime = toc;
    close_system(expParams.simlink_model, 0);
end
