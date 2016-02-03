function [ metabolites, metsIds, metsNames, metsFormulas ] = loadMets( model )
%loadMets
%   Loads the metabolites' features from the genome scale metabolic model
%   given as input parameter.
%   Metabolite ids, Metabolite Names and their respective Chemical Formulas
%   
%   Returns a table structure and three cell arrays structures including:
%       a.Metabolite ids, names and chemical formulas table
%       b.Metabolites' ids cell array
%       c.Metabolites' Names cell array
%       d.Metabolites' Chemical Formulas cell array
%   
%   Usage: [metabolites, metsIds, metsNames, metsFormulas] = loadMets(model)
%
%   Dimitra Lappa, 2016-01-23

    metId = cell2table(model.ihuman.mets);
    metId.Properties.VariableNames{'Var1'} = 'metabolite_id';
    metsIds = table2array(metId);

    metFormula = cell2table(model.ihuman.metFormulas);
    metFormula.Properties.VariableNames{'Var1'} = 'metabolite_formula';
    metsFormulas = table2array(metFormula);

    metName = cell2table(model.ihuman.metNames);
    metName.Properties.VariableNames{'Var1'} = 'metabolite_name';
    metsNames = table2array(metName);

    metabolites = [metId, metName, metFormula];

end

