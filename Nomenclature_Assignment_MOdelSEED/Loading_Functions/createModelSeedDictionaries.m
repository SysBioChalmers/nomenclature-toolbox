function [ Dict1, Dict2] = createModelSeedDictionaries( Cell1)
%createModelSeedDictionaries
%   Creating container maps-the same function as Python dictionaries for
%   "translating":
%       a.metabolite names into their ModelSEED identifiers/chemical
%       formulas
%       b.ModelSEED metabolite identifiers into their respective chemical formulas
%   
%   Takes as input one (1x3)cell array that contains:
%       a.ModelSEED identifiers
%       b.ModelSEED metabolite names 
%       c.chemical formula for each metabolite
%   Returns 2 Map structures that represent these dictionaries.
%       
%   
%   Usage: [ Dict1, Dict2] = createModelSeedDictionaries( Cell1)
%
%   Dimitra Lappa, 2016-03-23

    % Create the dictionaries
    fprintf('Creating dictionary for Model Seed Metabolite ids and their corresponding Chemical Formulas \n \n');
    fprintf('Creating dictionary for Model Seed Metabolite names and their corresponding Chemical Formulas \n \n');
    Dict1 = containers.Map( Cell1{1, 1},Cell1{1, 3} );
    Dict2 = containers.Map( Cell1{1, 2},Cell1{1, 3} );
    


end

