 function [state, T, robustness] = process_output(model_output)
            state = model_output.getElement(2).Values.Data;
            T = model_output.getElement(2).Values.Time;
            [T,idx,~] = unique(T,'first');
            state = state(idx,:);
            robustness = model_output.getElement(1).Values.Data;
            robustness = robustness(end,1);
    end