clear classes
mod = py.importlib.import_module('a3c_agent');
py.importlib.reload(mod);
disp('A3C Loaded')
mod = py.importlib.import_module('DDQN_agent');
py.importlib.reload(mod);
disp('DDQN Loaded')
mod = py.importlib.import_module('DQN_agent');
py.importlib.reload(mod);
disp('DQN Loaded')
mod = py.importlib.import_module('CatDQN_agent');
py.importlib.reload(mod);
disp('CatDQN Loaded')
mod = py.importlib.import_module('pcl_agent');
py.importlib.reload(mod);
disp('PCL Loaded')