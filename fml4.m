function formula4 = fml4(tmpl,gear2low,gear3low,gear4low)

formula3 = fml3(tmpl,gear2low,gear3low,gear4low);

formula4 = struct(tmpl);
formula4.expName = 'formula4';
formula4.targetFormula = '[]_[0,29.0]( (!gear1 /\ <>_[0, 0.1] gear1) -> []_[0.1,1.0](gear1))';
formula4.monitoringFormula = '[.]_[1.0,1.0]((!gear1 /\ <>_[0, 0.1] gear1) -> []_[0.1,1.0](gear1))';
formula4.br_formula = STL_Formula('formula4',...
    'alw_[0, 29.0](((Out3[t] > 1.5) and ev_[0, 0.1] (Out3[t] <= 1.5)) => alw_[0.1,1.0](Out3[t]<= 1.5))');
formula4.preds = formula3.preds;
formula4.stopTime = 30;


end