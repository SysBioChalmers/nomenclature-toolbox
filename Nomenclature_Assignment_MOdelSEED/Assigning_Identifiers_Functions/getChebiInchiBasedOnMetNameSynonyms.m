function [ stored_chebi_2, stored_inchi_2 ] = getChebiInchiBasedOnMetNameSynonyms(fileID, name, id, formula, chEbI2InChIMap, metaboliteNames2ChEBIMap,modelSeedMetNameFormula,  modelSeedMetNameSynonyms, chEBIMetaboliteNames )
%getChebiInchiBasedOnMetNameSynonyms
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
%       modelSeedMetNameFormula
%       modelSeedMetNameSynonyms
%       chEBIMetaboliteNames 
%     
%   The script searches through the maps given the metabolites names and
%   returns the respective ChEBI and InChi identifiers
%   
%   Returns 2 string variables containg the chosen ChEBI and InChi
%   Identifiers
%   
%   Usage:[stored_chebi_2, stored_inchi_2] = ...
%   getChebiInchiBasedOnMetNameSynonyms(fileID, name, id, formula, chEbI2InChIMap, metaboliteNames2ChEBIMap,modelSeedMetNameFormula,  modelSeedMetNameSynonyms, chEBIMetaboliteNames )
%
%
%   Dimitra Lappa, 2016-04-18

    stored_chebi_2={};
    stored_inchi_2={};
    formulaAppearranceCounter = 0;
    index = find(ismember(modelSeedMetNameFormula{1, 1}, id));
    nextSynonym=1;
    numSynonyms= size(modelSeedMetNameSynonyms);

    while (nextSynonym <= numSynonyms(2))
        chebi_index = find(ismember(chEBIMetaboliteNames{1, 2}, id));
        if chebi_index~= 0
                chebi = metaboliteNames2ChEBIMap(name);
                formulaAppearranceCounter = formulaAppearranceCounter +1
                fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, chebi);
                fprintf( '%s \t %s \t %s \t %s \n \n',id, name, chebi);
                fprintf('If this is your choice of annotation please press 2, %d \n \n', formulaAppearranceCounter);
                inchi= '';
                stored_chebi_2{formulaAppearranceCounter,1}= chebi;
                stored_inchi_2{formulaAppearranceCounter,1}= inchi; 
                if isKey(chEbI2InChIMap, chebi)
                   inchi = chEbI2InChIMap(chebi);
                   formulaAppearranceCounter = formulaAppearranceCounter +1 
                   fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
                   printf('blue', '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
                   fprintf('If this is your choice of annotation please press 2, %d \n \n', formulaAppearranceCounter);
                   stored_chebi_2{formulaAppearranceCounter,1}= chebi;
                   stored_inchi_2{formulaAppearranceCounter,1}= inchi;
                end
        end
        index = find(ismember(modelSeedMetNameFormula{1, 1}, id));
        name = modelSeedMetNameSynonyms(index, nextSynonym);
        nextSynonym = nextSynonym+1;
    end
end

