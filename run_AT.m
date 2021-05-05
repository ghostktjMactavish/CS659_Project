clc;
clear all;

global  logDir;

logDir = './log/';
runs = 20;
maxEpisodes = 200;

init_configs = struct('runs', runs,'maxEpisodes', maxEpisodes,'agentName', '/DDQN_Agent');

% Setup Taliro Breach etc.            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
setup_tools;


% Auto Transmission Model Properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AT_tmpl = struct(init_configs);
AT_tmpl.outputs = [2, 3, 4];
AT_tmpl.input_range = [0.0 100.0; 0.0 100.0];
AT_tmpl.output_range = [0.0 5000.0;0.0 200.0;1.0 4.0];
AT_tmpl.init_opts = {};
AT_tmpl.interpolation = {'linear'};

gear2low = 1.5;
gear3low = 2.5;
gear4low = 3.5;

%Formula Definitions

% Formula 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula1 = fml1(AT_tmpl,gear2low,gear3low,gear4low);

% Formula 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula2 = fml2(AT_tmpl,gear2low,gear3low,gear4low);

%Formula 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula3 = fml3(AT_tmpl,gear2low,gear3low,gear4low);

%Formula 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula4 = fml4(AT_tmpl,gear2low,gear3low,gear4low);

%Formula 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula5 = fml5(AT_tmpl,gear2low,gear3low,gear4low);

% Formula 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula6 = fml6(AT_tmpl,gear2low,gear3low,gear4low);

%Formula 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula7 = fml7(AT_tmpl,gear2low,gear3low,gear4low);

%Formula 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula8 = fml8(AT_tmpl,gear2low,gear3low,gear4low);

%Formula 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formula9 = fml9(AT_tmpl,gear2low,gear3low,gear4low);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Define Model to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%formulas 
formulas = {formula8};
sampleTimes = [ 1 ];

% Algo to run
algos = {{'RL', 'DDQN', 'DDQN_AT'}};%{'s-taliro', 'CE', 'arch2014_staliro'}};%};%,};


%Experiment configurations 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiments = [];

for k = 1:size(formulas, 2)
    for i = 1:size(algos, 2)
        for j = 1:size(sampleTimes, 2)
            exp_params = struct(formulas{k});
            exp_params.simlink_model = algos{i}{3};
            exp_params.algoName = [algos{i}{1}, '_', algos{i}{2}];
            exp_params.sampleTime = sampleTimes(j);
            exp_params.algo_type = algos{i}{1};
            exp_params.option = algos{i}{2};
            
            for l = 1:runs
              experiments = [experiments, exp_params];
            end
            
        end
    end
end

experiment_name = strcat('AT_RL_DDQN_st_',exp_params.expName,'_Time_',num2str(sampleTimes(1)));

run_experiment(experiment_name, shuffle_array(experiments));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




