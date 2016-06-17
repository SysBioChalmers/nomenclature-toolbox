clear
tic
%% Loading Genome'Scale Metabolic Mode using RAVEN Toolbox 
model=importModel('iAl1006 v1.00.xml',false,false,false);

%% Adding a MetaCyc Id field into the gem model's matlab structure
model.metaCycMetId=cell(length(model.mets),1);

% Adding a MetaCyc Metname Id field into the gem model's matlab structure
model.metaCycMetName = cell(length(model.mets),1);
model.metaCycChEBI = cell(length(model.mets),1);

%% Loading Flatfile and Creating Mapping for Assigning Identifiers Process

%Loading Flatfiles with standardised CHEBI and INCHI Identifiers 
%and create cell arrays with correspondance
chEBIMetaboliteNames = loadChEBI2MetNames('compounds.tsv');
chEBIInChI = loadChEBI2InChI('chebiIdInchi.tsv');
chEBIChemicalFormula = loadChEBI2ChemicalFormula('chemicalData.tsv');

%Loading Flatfiles with MetaCyc Identifiers, Metabolites Names & Synonyms,
%Chemical Formulas, InChi Strings and create cell arrays with correspondance
metaCycMetNameSynonyms = loadmetaCycMetNameSynonyms('metaCycMetNameSynonymsMapping.txt');
metaCycIdMetName = loadmetaCycIDMetNameMapping('metaCycIDMetNameMapping.txt');
metaCycIdFormulaInChiMapping = loadmetaCycIdFormulaInChiMapping('metaCycIdFormulaInChiMapping.txt');

% Create dictionaries
[metaboliteNames2ChEBIMap, chEbI2InChIMap, chemicalFormula2ChEBIMap, inChI2ChEBIMap] = ...
    createDictionaries(chEBIMetaboliteNames, chEBIInChI, chEBIChemicalFormula);

% Converting Model Matlab Cell structures  for metabolites' feature to
% tables
% Extracting metabolites id and name to flat files
[metabolites, metId, metName, metFormulas] = loadMets(model);
reactions = loadRxns(model);
writetable(metabolites, 'mets.txt', 'Delimiter', '\t');


%% Assigning Identifiers Process
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
    name = metName{i};, id = metId{i};, formula = metFormulas{i};
    if (strcmp(formula,''))
        formula = 'NO FORMULA';
    end
    metaCycAnnotation = {};    
    metaCycAnnotation = displayMetacycIds(model, startingPoint, metaCycIdFormulaInChiMapping, metaCycIdMetName, metaCycMetNameSynonyms);
    
    model = storeMetaCycIdentifiers(model, metaCycAnnotation, startingPoint, inChI2ChEBIMap);

    startingPoint=i;
    
end
fclose(fileID);


toc
