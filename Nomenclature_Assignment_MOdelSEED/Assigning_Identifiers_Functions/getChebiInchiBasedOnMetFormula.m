function [ stored_chebi_3, stored_inchi_3, formulaAppearranceCounter] = getChebiInchiBasedOnMetFormula(fileID, name, id, formula, chEbI2InChIMap, chEBIChemicalFormula )
%getChebiInchiBasedOnMetFormula
%   Function for assigning Inchi and ChEBI identifiers in the genome scale
%   metabolic model based on the metabolite's formula.
% 
%   Takes as input:
%       a.the identifier for the log file (Command Prompt output)
%       b.the name of the metabolite
%       c.the id of the metabolite
%       d.the formula of the metabolite
%       e.the ChEBI to InChi identifier translation Dictionary
%       f.the ChEBI to Chemical Formula identifier translation Dictionary 
%     
%   The script searches through the map given the metabolites formula and
%   returns the respective ChEBI and InChi identifiers
%   
%   Returns a two (nx1) cell arrays containing all the possible annotation that can be
%   assigned to this chemical formula
%   
%   Usage:[stored_chebi_2, stored_inchi_2] = ...
%   getChebiInchiBasedOnMetFormula(fileID, name, id, formula, chEbI2InChIMap, chEBIChemicalFormula)
%
%
%   Dimitra Lappa, 2016-01-25
    
    %Initialising empty varialble
    stored_chebi_3={};
    stored_inchi_3={};
    formulaAppearranceCounter = 0;
    
    %Searching through the formula-ChEBI lists and maps
    for j=1:length(chEBIChemicalFormula{1,2})
        if strcmp(formula, chEBIChemicalFormula{1,2}{j,1})
            chebi = chEBIChemicalFormula{1,1}{j,1};
            formulaAppearranceCounter = formulaAppearranceCounter +1;
            fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, chebi);
            fprintf( '%s \t %s \t %s \t %s \n \n',id, name, chebi);
            fprintf('If this is your choice of annotation please press 3, %d \n \n', formulaAppearranceCounter);
            inchi= '';
            stored_chebi_3{formulaAppearranceCounter,1}= chebi;
            stored_inchi_3{formulaAppearranceCounter,1}= inchi; 
            if isKey(chEbI2InChIMap, chebi)
                inchi = chEbI2InChIMap(chebi);
                formulaAppearranceCounter = formulaAppearranceCounter +1; 
                fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
                cprintf('magenta', '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
                fprintf('If this is your choice of annotation please press 3, %d \n \n', formulaAppearranceCounter);
               stored_chebi_3{formulaAppearranceCounter,1}= chebi;
               stored_inchi_3{formulaAppearranceCounter,1}= inchi;
            end
        end

end



end

