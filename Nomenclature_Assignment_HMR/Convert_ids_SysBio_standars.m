function [ model ] = Convert_ids_SysBio_standars(model)
%Convert_ids_SysBio_standars
%   Takes as input a GEM model. Isolates the model's Reaction IDs and metabolites' ids, converts
%   them according to the SysBio naming ID standrads for human GEM models
%   
%   Returns the updated version of the gem model structure
%      
%   Usage: model = Convert_ids_SysBio_standars(model)
%
%   Dimitra Lappa, 2015-12-10

    model.mets=replace_met_ids(model.mets);
    model.rxns=replace_rxn_ids(model.rxns);

end

