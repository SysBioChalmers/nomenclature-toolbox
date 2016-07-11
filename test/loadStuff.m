%clear
tic
% Loading Genome'Scale Metabolic Mode  
model=models(1);

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