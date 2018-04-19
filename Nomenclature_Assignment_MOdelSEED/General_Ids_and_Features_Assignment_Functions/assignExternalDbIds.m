function [ model ] = assignExternalDbIds( model, externalId )
%assignExternalDbIds
%   Function for assigning external Identifiers from different Databases
%   to a Genome-Scale Metabolic Model reconstructed from ModelSEED.
%   The external Identifiers are:
%       a. KEGG Ids for metabolites and reactions
%       b. ChEBI Ids for metabolites
%       c. InChI Ids for metabolites
%       d. Enzyme Comission Numbers for reactions
%   and DeltaG for metabolites and reactions
% 
% Takes as input argument:
%       a. a Genome-Scale Metabolic Model
%       b. a string representing the desired annotation, e.g.
%           i.  'KEGG'
%           ii. 'ChEBI'
%           iii.'InChI'
%           iv.  'EC'
%
%   Returns one Genome-Scale Metabolic
%   Model structure with additional fields that represent these external
%   identifiers
%   The function is calling other functions for
%       a. loading the necessary flatfiles
%       b. creating the Matlab model structures for storing the information
%       c. assigning the chosen annotation 
%   
%   Usage: model = assignExternalDbIds(model, externalId)
%   Dimitra Lappa, 2016-09-01




    if isempty(externalId)
            while isempty(externalId)
                fprintf( 'Please provide a proper input argument \n');
                fprintf( 'for assigning chemical properties such as:\n');
                fprintf( ' "KEGG" or \n');
                fprintf( ' "EC" or \n');
                fprintf( ' "InChI" or \n');
                fprintf( ' " ChEBI"\n');
                prompt = 'Please provide a proper answer\n';
                externalId = input(prompt,'s');
                externalId = input(prompt,'s');
            end
    end
    
    if strcmpi(externalId, 'KEGG')
        % Loading Flatfile with KEGG Identifiers 
        modelSeedKEGG = loadmodelSeedKEGG('modelseedKEGG.txt');
        for i=1:length(model)
            %Adding a reaction KEGG identifier field to the model
            model(i).rxnKEGGID = cell(length(model(i).rxns),1);
            
            %Assign KEGG Identifiers to to ModelSeed Metabolite Ids
            model(i).metKEGGID = assignModelSeedMetKEGGID(model(i).mets, modelSeedKEGG);
        
            %Assign KEGG Identifiers to to ModelSeed Reaction Ids
        model(i).rxnKEGGID = assignModelSeedRxnKEGGID(model(i).rxns, modelSeedKEGG);
        end
    elseif strcmpi(externalId, 'EC')
        % Loading Flatfile with Enzyme Commission Numbers
        modelSeedECNumbers = loadmodelSeedECNumbers('modelseedECNumbers.txt');
        for i=1:length(model)
            %Assign EC Numbers to to ModelSeed Reaction Ids
            model(i).rxnECNumbers = assignModelSeedRxnECNumber(model(i).rxns, modelSeedECNumbers);
        end   
    elseif (strcmpi(externalId, 'ChEBI') | strcmpi(externalId, 'InChI'))
        chEBIMetaboliteNames = loadChEBI2MetNames('compounds.tsv');
        chEBIInChI = loadChEBI2InChI('chebiIdInchi.tsv');
        chEBIChemicalFormula = loadChEBI2ChemicalFormula('chemicalData.tsv');
        modelSeedMetNameFormula = loadmodelSeedMetNameFormula('modelSEEDcompounds.txt');
        modelSeedMetNameSynonyms = loadmodelSeedMetNameSynonyms('modelSeedSynonyms.txt');
        

        
        % Create dictionaries
        [metaboliteNames2ChEBIMap, chEbI2InChIMap, chemicalFormula2ChEBIMap] = ...
        createDictionaries(chEBIMetaboliteNames, chEBIInChI, chEBIChemicalFormula);


        % Create ModelSEED dictionaries
        [modelSeedMetaboliteNames2FormulaMap, modelSeedMetaboliteIds2FormulaMap] = ...
        createModelSeedDictionaries(modelSeedMetNameFormula);
        
        % Converting Model Matlab Cell structures  for metabolites' feature to
        % tables
        for i=1:length(model)
                [metabolites, metId, metName, metFormula] = loadMets(model);
                reactions = loadRxns(model);
                %Creating a log file to keep the Matlab Command Prompt output
                fileID = fopen('log.txt', 'w');


                startingPoint=provideStartingPointPromptMsg(model);
                %Loop through your metabolites and find annotation in Dictionary archives
                for i=startingPoint:length(metName)
                    %Ask user for continuing process
                    assigning = continueAssigningIdsPromptMsg(startingPoint);
                    if assigning == false
                        break
                    end

                    %Loading metabolites features into temporary variables
                    name = metName{i};, id = metId{i};, formula = metFormula{i};
                    if (strcmp(formula,''))
                        formula = 'NO FORMULA';
                    end

                    %Printing in command prompt the current
                    %information
                    noIdentifiers(fileID, name, id, formula);


                    %If the name of the metabolite is standardised and agrees with official
                    %ChEBI nomenclature
                    [stored_chebi_2, stored_inchi_2] = getChebiInchiBasedOnMetNameSynonyms(fileID,...
                        name, id, formula, chEbI2InChIMap, metaboliteNames2ChEBIMap,modelSeedMetNameFormula,...
                            modelSeedMetNameSynonyms, chEBIMetaboliteNames);
                    %If the name does not correspond there, perform a search in the ChEBI
                    %Database file given Chemical formula    
                    [stored_chebi_3, stored_inchi_3] = getChebiInchiBasedOnMetFormula(fileID,...
                        name, id, formula, chEbI2InChIMap, chEBIChemicalFormula);

                    %Store the identifiers in the genome-scale metabolic model's matlab structure
                    model = storeIdentifiers(model, i,stored_chebi_2,...
                        stored_inchi_2, stored_chebi_3, stored_inchi_3);
                    startingPoint=i;
                end
                fclose(fileID);
        end
            else
                fprintf( 'No proper input argument,cannot assign chemical properties,re-run your command \n');
            end
    

end

