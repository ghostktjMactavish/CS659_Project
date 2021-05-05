function formula2 = fml2(tmpl,gear2low,gear3low,gear4low)

formula2 = struct(tmpl);
formula2.expName = 'formula2';
formula2.targetFormula = '[](p1 /\ p2)';
formula2.monitoringFormula = 'p1 /\ p2';
formula2.br_formula = STL_Formula('formula2', 'alw ((Out1[t] <= 4500.0) and (Out2[t] <= 150))');
formula2.preds(1).str = 'p1';
formula2.preds(1).A = [1 0 0];
formula2.preds(1).b = 4500.0;
formula2.preds(2).str = 'p2';
formula2.preds(2).A = [0 1 0];
formula2.preds(2).b = 150.0;
formula2.stopTime = 30;
end