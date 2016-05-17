function [ stored_chebi_2, stored_inchi_2 ] = getChebiInchiBasedOnMetName(fileID, name, id, formula, chEbI2InChIMap, metaboliteNames2ChEBIMap )
%getChebiInchiBasedOnMetName
%   Function for assigning Inchi and ChEBI identifiers in the genome scale
%   metabolic model based on the metabolite's name.
% 
%   Takes as input:
%       a.the identifier for the log file (Command Prompt output)
%       b.the name of the metabolite
%       c.the id of the metabolite
%       d.the formula of the metabolite
%       e.the ChEBI to InChi identifier translation Dictionary
%       f.the Metabolite Name to ChEBI identifier translation Dictionary 
%     
%   The script searches through the map given the metabolites name and
%   returns the respective ChEBI and InChi identifiers
%   
%   Returns 2 string variables containg the chosen ChEBI and InChi
%   Identifiers
%   
%   Usage:[stored_chebi_2, stored_inchi_2] = ...
%   getChebiInchiBasedOnMetName(fileID, name, id, formula, chEbI2InChIMap, metaboliteNames2ChEBIMap )
%
%
%   Dimitra Lappa, 2016-01-25

stored_chebi_2=[];
stored_inchi_2=[];

if isKey(metaboliteNames2ChEBIMap, name)
    chebi = metaboliteNames2ChEBIMap(name);
    if isKey(chEbI2InChIMap, chebi)
        inchi = chEbI2InChIMap(chebi);
        cprintf('blue','%s \t %s \t %s \t %s \n \n',id, name, formula, chebi, inchi);
        fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, formula, chebi, inchi);
        fprintf('If this is your choice of annotation please press 2 \n \n');
        stored_chebi_2 = chebi;
        stored_inchi_2 = inchi;
    end
else
    disp('Metabolite name not found.')
end

