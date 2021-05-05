function formula1 = fml1(tmpl,gear2low,gear3low,gear4low)

formula1 = struct(tmpl);
formula1.expName = 'formula1';
formula1.targetFormula = '[]p1';
formula1.monitoringFormula = 'p1';
formula1.preds(1).str = 'p1';
formula1.preds(1).A = [1 0 0];
formula1.preds(1).b = 4500.0;
formula1.br_formula = STL_Formula('formula1', 'alw (Out1[t] <= 4500.0)');
formula1.stopTime = 30;

end