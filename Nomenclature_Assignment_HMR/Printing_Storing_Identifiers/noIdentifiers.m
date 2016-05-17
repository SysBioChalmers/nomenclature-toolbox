function [ ] = noIdentifiers( fileID, name, id, formula  )
%noIdentifiers
%   Function for printing metabolite's id, name, formula.
% 
%   Takes as input:
%       a.the identifier for the log file (Command Prompt output)
%       b.the name of the metabolite
%       c.the id of the metabolite
%       d.the formula of the metabolite
%       
%   
%   Usage:[stored_chebi_2, stored_inchi_2] = ...
%   getChebiInchiBasedOnMetFormula(fileID, name, id, formula, chEbI2InChIMap, chEBIChemicalFormula)
%
%
%   Dimitra Lappa, 2016-01-25

    fprintf(fileID, '%s \t %s \t %s \n',id, name, formula);
    fprintf('%s \t %s \t %s \n',id, name, formula);
    fprintf('If this is your choice of annotation please press 1 \n \n');


end

