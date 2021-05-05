%Load Python Env, Run Only Once
%pyversion('~/anaconda3/envs/CS659/bin/python');
global logDir;

staliro_dir = './s-taliro_public/trunk/';
breach_dir = './breach';
logDir = './log/';
% Initialization
%%%%%%%%%%%%%%%%

%Setup S Taliro
if exist('dp_taliro.m', 'file') == 0
    addpath(staliro_dir);
    cwd = pwd;
    cd(staliro_dir);
    setup_staliro;
    cd(cwd);
end


%Setup S Taliro Monitor
if exist('setup_monitor.m', 'file') == 0
    addpath(fullfile(staliro_dir, 'monitor'));
    cwd = pwd;
    cd(fullfile(staliro_dir, 'monitor'));
    setup_monitor;
    cd(cwd);
end

%Setup Breach
if exist('InitBreach.m', 'file') == 0
    addpath(breach_dir);
    cwd = pwd;
    cd(breach_dir);
    InitBreach;
    InstallBreach;
    cd(cwd);
end    

%Create Log Directory
disp('Creating Log Directory if not exists')
if ~1 == exist(logDir, 'dir')
    mkdir(logDir);
end

disp("Initialization Complete");