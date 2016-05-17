%clear
tic
% Loading Genome'Scale Metabolic Mode  
model=model2;

% Adding a chebi field into the gem model's matlab structure
%model.chebis=cell(6006,1);

% Converting model's metabolites and reactions identifiers according ti
% SysBio standars
model = convertIdsSysBioStandars(model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen('ModelSEED-compounds-db.csv');
chemicalFormula = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s','delimiter',';');
fclose(fileID);

dict=containers.Map( chemicalFormula{1}, chemicalFormula{6});

model.metFormulas=cell(numel(model.mets),1);
for i=1:numel(model.mets)
    model.metFormulas{i}=dict(strtok(model.mets{i},'_'))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Converting Model Matlab Cell structures  for metabolites' feature to
% tables
% Extracting metabolites id and name to flat files
[metabolites, metId, metName, metFormula] = loadMets(model);
reactions = loadRxns(model);
writetable(metabolites, 'mets.txt', 'Delimiter', '\t');


% Starting Assigning Identifiers Process

%Loading Flatfiles with standardised CHEBI and INCHI Identifiers 
%and create cell arrays with correspondance
chEBIMetaboliteNames = loadChEBI2MetNames('compounds.tsv');
chEBIInChI = loadChEBI2InChI('chebiIdInchi.tsv');
chEBIChemicalFormula = loadChEBI2ChemicalFormula('chemicalData.tsv');

% Create dictionaries
[metaboliteNames2ChEBIMap, chEbI2InChIMap, chemicalFormula2ChEBIMap] = ...
    createDictionaries(chEBIMetaboliteNames, chEBIInChI, chEBIChemicalFormula);

%Creating a log file to keep the Matlab Command Prompt output
fileID = fopen('log.txt', 'w');

startingPoint=provideStartingPointPromptMsg(model);
%Loop through your metabolites and find annotation in Dictionary archives
for i=startingPoint:length(metName)
    %Ask user for continuing process
    %assigning = continueAssigningIdsPromptMsg(startingPoint);
    %if assigning == false
    %    break
    %end
    
    %Loading metabolites features into temporary variables
    name = metName{i};, id = metId{i};, formula = metFormula{i};
    if (strcmp(formula,''))
        formula = 'NO FORMULA';
    end
    
    %Printing in command prompt the current
    %information
%     fprintf(fileID, '%s \t %s \t %s \n',id, name, formula); fprintf('%s \t %s \t %s \n',id, name, formula);
%     fprintf('If this is your choice of annotation please press 1 \n \n');
    noIdentifiers(fileID, name, id, formula);
    
    
    %If the name of the metabolite is standardised and agrees with official
    %ChEBI nomenclature
    [stored_chebi_2, stored_inchi_2] = getChebiInchiBasedOnMetName(fileID,name, id, formula, chEbI2InChIMap, metaboliteNames2ChEBIMap);
    
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
%
%
toc
