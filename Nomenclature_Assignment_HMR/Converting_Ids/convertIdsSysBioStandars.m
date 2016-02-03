function [ model ] = convertIdsSysBioStandars(model)
%convertIdsSysBioStandards
%
%   Takes as input a GEM model. Isolates the model's Reaction IDs and metabolites' ids, converts
%   them according to the SysBio naming ID standrads for human GEM models
%   
%   Returns the updated version of the gem model structure
%      
%   Usage: model = convertIdsSysBioStandards(model)
%
%   Dimitra Lappa, 2015-12-10

    fprintf('Converting  the models Reaction IDs and mMtabolites ids, according to SysBio naming ID standrads for human GEM models \n \n');
    model.mets=replaceMetIds(model.mets);
    model.rxns=replaceRxnIds(model.rxns);

end

