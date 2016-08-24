function [out_model ex_rxns] = set_exchange_lb (in_model, lb_value, ub_value)

% find both exchange & sink reactions
[ex_boolean, ~] = findExcRxns(in_model);
ex_rxns = in_model.rxns(ex_boolean);
% [~, ex_rxns_index] = ismember(ex_rxns, in_model.rxns);

ex_Rev = in_model.rev(ex_boolean);
    
out_model = in_model;

for j=1:length(ex_rxns)
    rxns = ex_rxns{j};
    rev = ex_Rev(j);

    if (rev)
        out_model = changeRxnBounds(out_model, rxns, lb_value, 'l');
        out_model = changeRxnBounds(out_model, rxns, ub_value, 'u');
    else
        out_model = changeRxnBounds(out_model, rxns, 0, 'l');
        out_model = changeRxnBounds(out_model, rxns, ub_value, 'u');
    end
end
    


end
