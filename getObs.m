function [t, State, Output] = getObs(expParams, preds_normalized) %t removed 
        
system_dimension = size(expParams.output_range, 1);
assignin('base', 'SystemDimension', system_dimension);
assignin('base', 'Formula', expParams.monitoringFormula);
assignin('base', 'Preds', preds_normalized);

set_param([expParams.simlink_model, expParams.agentName], 'sample_time', num2str(expParams.sampleTime));
set_param([expParams.simlink_model, expParams.agentName], 'input_range', mat2str(expParams.input_range));
        simOut = sim(expParams.simlink_model,'SimulationMode','normal','AbsTol','1e-7',...
                     'CaptureErrors', 'on',...
                     'SaveTime', 'on', 'TimeSaveName', 't',...
                     'SaveState','on','StateSaveName','State',...
                     'SaveOutput','on','OutputSaveName','Output',...
                     'SaveFormat', 'Dataset',...
                     'StartTime', '0.0',...
                     'StopTime', num2str(expParams.stopTime));
        
assignin('base', 'simOut', simOut);
t = simOut.get('t');
State = simOut.get('State');
Output = simOut.get('Output');

end
