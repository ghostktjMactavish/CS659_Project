function formula8 = fml8(tmpl,gear2low,gear3low,gear4low)

formula8 = struct(tmpl);
formula8.expName = 'formula8';
formula8.targetFormula = '[]_[0,75](<>_[0,25](!(vl/\vu)))';
formula8.monitoringFormula = '[.]_[25, 25]<>_[0,25](!(vl/\vu))';
formula8.br_formula = STL_Formula('formula8', 'alw_[0,75](ev_[0,25](not ((Out2[t]>=70) and (Out2[t]<=80))))');
vl = 70.0;
vu = 80.0;
formula8.preds(1).str = 'vl';
formula8.preds(1).A = [0 -1 0];
formula8.preds(1).b = -vl;
formula8.preds(2).str = 'vu';
formula8.preds(2).A = [0 1 0];
formula8.preds(2).b = vu;
formula8.stopTime = 100;
end