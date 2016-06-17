function [ Dict1, Dict2, Dict3, Dict4 ] = createDictionaries( Cell1, Cell2, Cell3,Cell4 )
%Create_Dictionaries
%   Creating container maps-the same function as Python dictionaries for
%   "translating":
%       a.metabolite names into their ChEBI identifiers
%       b.ChEBI Identifiers into InChI identifiers for standardised
%       elements
%       c.chemical formulas of each metabolite into their ChEBI identifiers
%       d.InChI Identifiers into ChEBI identifiers for standardised
%       elements
%   
%   Takes as input three (1x2)cell arrays that contain:
%       a.metabolite names and their ChEBI identifiers
%       b.ChEBI Identifiers and their respective InChI identifiers 
%       c.chemical formulas of a metabolite and their respective ChEBI identifiers
%       d.InChI Identifiers and their respective ChEBI identifiers
%
%   Returns 4 Map structures that represent these dictionaries.
%       
%   
%   Usage: [Dict1, Dict2, Dict3, Dict4]=createDictionaries(Cell1, Cell2, Cell3, Cell4)
%
%   Dimitra Lappa, 2015-11-25

    % Create the dictionaries
    fprintf('Creating dictionary for Metabolite names and their corresponding ChEBI Identifiers \n \n');
    fprintf('Creating dictionary for ChEBI Identifiers and their corresponding InChI identifiers \n \n');
    fprintf('Creating dictionary for Metabolites Chemical Formulas and their corresponding ChEBI identifiers \n  \n');
    fprintf('Creating dictionary for InChI Identifiers and their corresponding ChEBI identifiers \n \n \n');
    Dict1 = containers.Map( Cell1{1, 2},Cell1{1, 1} );
    Dict2 = containers.Map( Cell2{1, 1},Cell2{1, 2} );
    Dict3 = containers.Map( Cell3{1, 2},Cell3{1, 1} );
    Dict4 = containers.Map( Cell2{1, 2},Cell2{1, 1} );


end

