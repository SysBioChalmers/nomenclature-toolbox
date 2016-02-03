function [ reactions ] = loadRxns( model )
%loadRxns
%   Loads the reaction names from the genome scale metabolic model given as
%   input parameter.
%   
%   Returns a table structure including:
%       a.reaction ids
%   
%   Usage: reactions = loadRxns(model)
%
%   Dimitra Lappa, 2016-01-23


    rxnId = cell2table(model.ihuman.rxns);
    rxnId.Properties.VariableNames{'Var1'} = 'reaction_id';
    rxnsId = table2array(rxnId);

    reactions = [rxnId];

end

