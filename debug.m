clear classes
mod = py.importlib.import_module('a3c_agent');
py.importlib.reload(mod);
disp('A3C Loaded')
mod = py.importlib.import_module('DDQN_agent');
py.importlib.reload(mod);
disp('DDQN Loaded')