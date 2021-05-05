function formula6 = fml6(tmpl,gear2low,gear3low,gear4low)

formula6 = struct(tmpl);
formula6.expName = 'formula6';
formula6.targetFormula = '[]_[0, 80](([]_[0, 10](p1)) -> ([]_[10,20](p2)))';
formula6.monitoringFormula = '[.]_[20, 20](([]_[0, 10](p1)) -> ([]_[10,20](p2)))';
formula6.br_formula = STL_Formula('formula6', 'alw_[0,80.0]((alw_[0,10](Out1[t]<=4500)) => alw_[10,20](Out2[t]<=130))');
formula6.preds(1).str = 'p1';
formula6.preds(1).A = [1 0 0];
formula6.preds(1).b = 4500.0;
formula6.preds(2).str = 'p2';
formula6.preds(2).A = [0 1 0];
formula6.preds(2).b = 130.0;
formula6.stopTime = 100;
end