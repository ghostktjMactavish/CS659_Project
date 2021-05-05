function formula7 = fml7(tmpl,gear2low,gear3low,gear4low)

formula7 = struct(tmpl);
formula7.expName = 'formula7';
formula7.targetFormula = '!<>p1';
formula7.monitoringFormula = '!p1';
formula7.br_formula = STL_Formula('formula6', 'not ev (Out2[t]>=160)');
formula7.preds(1).str = 'p1';
formula7.preds(1).A = [0 -1 0];
formula7.preds(1).b = -160.0;
formula7.stopTime = 100;

end