function formula9 = fml9(tmpl,gear2low,gear3low,gear4low)

formula9 = struct(tmpl);
formula3 = fml3(tmpl,gear2low,gear3low,gear4low);
formula9.expName = 'formula9';
formula9.targetFormula = '[]_[0,80](![]_[0,20](!gear4 /\ highRPM))';
formula9.monitoringFormula = '[.]_[20, 20]![]_[0,20](!gear4 /\ highRPM)';
formula9.br_formula = STL_Formula('formula9', 'alw_[0,80](not alw_[0,20]((Out3[t]<3.5) and (Out1[t]>=3100)))');
pred = struct('str', 'highRPM', 'A', [-1 0 0], 'b', -3100.0);
formula9.preds = [formula3.preds, pred];
formula9.stopTime = 100;


end