clear
tic
%% Loading Genome'Scale Metabolic Mode  
load('52Models.mat');

%% Adding fields into the gem model's matlab structure
for i=1:length(model)
    %Adding a metabolite formula field to the model 
    model(i).metFormula=cell(length(model(i).mets),1);
    
    %Adding a metabolite DeltG, DeltaG error field to the model
    model(i).metDeltaG = cell(length(model(i).mets),2);
    
    %Adding a reaction DeltG field to the model
    model(i).rxnDeltaG = cell(length(model(i).rxns),1);
    
    %Adding a reaction KEGG identifier field to the model
    model(i).rxnKEGGID = cell(length(model(i).rxns),1);
    
    % Converting model's metabolites and reactions identifiers according to
    % SysBio standars
    model(i)= convertIdsSysBioStandars(model(i));
end

%% Loading Flatfiles with standardised CHEBI and INCHI Identifiers 
%and create cell arrays with correspondance
chEBIMetaboliteNames = loadChEBI2MetNames('compounds.tsv');
chEBIInChI = loadChEBI2InChI('chebiIdInchi.tsv');
chEBIChemicalFormula = loadChEBI2ChemicalFormula('chemicalData.tsv');
modelSeedMetNameFormula = loadmodelSeedMetNameFormula('modelSEEDcompounds.txt');
modelSeedMetNameSynonyms = loadmodelSeedMetNameSynonyms('modelSeedSynonyms.txt');
modelSeedMetIdDeltaG = loadmodelSeedMetIdDeltaG('DeltaG.txt');
modelSeedKEGG = loadmodelSeedKEGG('modelseedKEGG.txt');
modelSeedECNmbers = loadmodelSeedECNumbers('modelseedECNumbers.txt');


%% Create dictionaries
[metaboliteNames2ChEBIMap, chEbI2InChIMap, chemicalFormula2ChEBIMap] = ...
    createDictionaries(chEBIMetaboliteNames, chEBIInChI, chEBIChemicalFormula);


% Create ModelSEED dictionaries
[modelSeedMetaboliteNames2FormulaMap, modelSeedMetaboliteIds2FormulaMap] = ...
    createModelSeedDictionaries(modelSeedMetNameFormula);

%% Starting Assigning Identifiers Process

for i=1:length(model)
        %Assign Formula to ModelSeed Ids
        model(i).metFormula = assignModelSeedFormula(model(i).mets, modelSeedMetNameFormula);

        %Assign DeltaG values to to ModelSeed Ids
        model(i).metDeltaG = assignModelSeedDeltaG(model(i).mets, modelSeedMetIdDeltaG);
        
        %Assign KEGG Identifiers to to ModelSeed Metabolite Ids
        model(i).metKEGGID = assignModelSeedMetKEGGID(model(i).mets, modelSeedKEGG);
        
        %Assign KEGG Identifiers to to ModelSeed Reaction Ids
        model(i).rxnKEGGID = assignModelSeedRxnKEGGID(model(i).rxns, modelSeedKEGG);
        
        %Assign EC Numbers to to ModelSeed Reaction Ids
        model(i).rxnECNumbers = assignModelSeedRxnECNumber(model(i).rxns, modelSeedECNumbers);
        
        %Calculate Delta Gs for all the reactions in the models
        model(i) = calculateDeltaG(model(i), modelSeedMetIdDeltaG);
        
end
        

% Converting Model Matlab Cell structures  for metabolites' feature to
% tables
% Extracting metabolites id and name to flat files
[metabolites, metId, metName, metFormula] = loadMets(model);
reactions = loadRxns(model);
writetable(metabolites, 'mets.txt', 'Delimiter', '\t');


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


toc
