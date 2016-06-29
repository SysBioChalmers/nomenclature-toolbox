function [ model ] = convertIdsSysBioStandars(model)
%convertIdsSysBioStandards
%
%   Takes as input a GEM model. Isolates the model's metabolite ModelSEED names and ModelSEED metabolites' ids, converts
%   them by removing their compartment id from their name
%   
%   Returns the updated version of the gem model structure
%      
%   Usage: model = convertIdsSysBioStandards(model)
%
%   Dimitra Lappa, 2016-03-24

    fprintf('Converting  the models Metabolites ids and names, by removing the compartment from their name \n \n');
    model.mets=replaceMetIds(model.mets);
    model.metNames=replaceMetIds(model.metNames);
    
    fprintf('Converting  the models Reaction ids, by removing the compartment from their name \n \n');
    model.rxns=replaceRxnIds(model.rxns);
end

