function [normal_preds] = normalize_pred(preds, range)
       normal_preds = [];
       lower = range(:,1);
       upper = range(:,2);
       middle = (lower + upper)/2;
       d = (upper - lower)/2;
       dd = diag(d);
       for i = 1:size(preds,2)
          normal_preds(i).str = preds(i).str;
          normal_preds(i).A = preds(i).A * dd;
          normal_preds(i).b = preds(i).b - preds(i).A * middle;
       end
end