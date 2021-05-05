function formula3 = fml3(tmpl,gear2low,gear3low,gear4low)

formula3 = struct(tmpl);
formula3.expName = 'formula3';
formula3.targetFormula = '[]_[0,29.0]( ((gear2low/\gear2up) /\ <>_[0, 0.1] gear1) -> []_[0.1,1.0](!(gear2low/\gear2up)))';
formula3.monitoringFormula = '[.]_[1.0,1.0]( ((gear2low/\gear2up) /\ <>_[0, 0.1] gear1) -> []_[0.1,1.0](!(gear2low/\gear2up)))';
formula3.br_formula = STL_Formula('formula3',...
    'alw_[0, 29.0](((Out3[t] >= 1.5 and Out3[t] <= 2.5) and ev_[0, 0.1] (Out3[t] <= 1.5)) => alw_[0.1,1.0]((Out3[t]< 1.5) or (Out3[t] > 2.5)))');
formula3.preds(1).str = 'gear1';
formula3.preds(1).A = [0 0 1];
formula3.preds(1).b = gear2low;
formula3.preds(2).str = 'gear2low';
formula3.preds(2).A = [0 0 -1];
formula3.preds(2).b = -gear2low;
formula3.preds(3).str = 'gear2up';
formula3.preds(3).A = [0 0 1];
formula3.preds(3).b = gear3low;
formula3.preds(4).str = 'gear3low';
formula3.preds(4).A = [0 0 -1];
formula3.preds(4).b = -gear3low;
formula3.preds(5).str = 'gear3up';
formula3.preds(5).A = [0 0 1];
formula3.preds(5).b = gear4low;
formula3.preds(6).str = 'gear4';
formula3.preds(6).A = [0 0 -1];
formula3.preds(6).b = -gear4low;
formula3.stopTime = 30;

end