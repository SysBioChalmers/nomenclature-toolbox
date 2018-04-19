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
modelSeedECNumbers = loadmodelSeedECNumbers('modelseedECNumbers.txt');


%% Create dictionaries
[metaboliteNames2ChEBIMap, chEbI2InChIMap, chemicalFormula2ChEBIMap] = ...
    createDictionaries(chEBIMetaboliteNames, chEBIInChI, chEBIChemicalFormula);


% Create ModelSEED dictionaries
[modelSeedMetaboliteNames2FormulaMap, modelSeedMetaboliteIds2FormulaMap] = ...
    createModelSeedDictionaries(modelSeedMetNameFormula);


%% Check for Short Chain Fatty Acids Production
num_model = length(model);
% load the short-chain fatty acid information
scfa_info = readtable('SCFA.txt', 'Delimiter', '\t', 'ReadVariableNames',false);
scfa_id = scfa_info{2:end, 'Var1'}
scfa_name = scfa_info{2:end, 'Var2'}

num_scfa = length(scfa_id);

% for each of model check the SCFA production

% create a array to store the production
scfa_production = zeros(num_scfa, num_model);

for i = 1:num_scfa
    
    i_scfa_name = scfa_name(i);
    i_scfa_id = scfa_id(i);
    
    i_scfa_exchange_rxns_name = strcat('EX_', i_scfa_id, '_e0');
    i_scfa_met = strcat(i_scfa_id, '_c0');
    i_scfa_demand_rxns_name = strcat('DM_', i_scfa_met);
    
    for j = 1:num_model
        
        j_model = model(j);
        
        % set all the exchange rxns are free
        [j_model, j_exchange_rxns] = set_exchange_lb(j_model, -10, 1000);
        
        % check if the exchange of scfa is open in the model, if yes, close
        % it
        i_in_exchange_status = ismember(i_scfa_exchange_rxns_name, j_exchange_rxns);
        if i_in_exchange_status
            j_model = changeRxnBounds(j_model, i_scfa_exchange_rxns_name, 0, 'l');
        end
        
        % add the demand reaction of scfa
        j_model = addDemandReaction(j_model, i_scfa_met);
        
        % change objective function
        j_model = changeObjective(j_model, i_scfa_demand_rxns_name);
        
        % maximize the obj
        j_sol = optimizeCbModel(j_model);
        
        scfa_production(i, j) = j_sol.f;
        
    end
end

save('scfa_production.mat', 'scfa_production')
save scfa_id;
save scfa_name;


%% Check for Amino Acids Production

% load the amino acid information
aa_info = readtable('AA.txt', 'Delimiter', '\t', 'ReadVariableNames',false);
aa_id = aa_info{2:end, 'Var1'}
aa_name = aa_info{2:end, 'Var2'}

num_aa = length(aa_id);

% for each of model check the aa production

% create a array to store the production
aa_production = zeros(num_aa, num_model);

for i = 1:num_aa
    
    i_aa_name = aa_name(i);
    i_aa_id = aa_id(i);
    
    i_aa_exchange_rxns_name = strcat('EX_', i_aa_id, '_e0');
    i_aa_met = strcat(i_aa_id, '_c0');
    i_aa_demand_rxns_name = strcat('DM_', i_aa_met);
    
    for j = 1:num_model
        
        j_model = model(j);
        
        % set all the exchange rxns are free
        [j_model, j_exchange_rxns] = set_exchange_lb(j_model, -10, 1000);
        
        % check if the exchange of aa is open in the model, if yes, close
        % it
        i_in_exchange_status = ismember(i_aa_exchange_rxns_name, j_exchange_rxns);
        if i_in_exchange_status
            j_model = changeRxnBounds(j_model, i_aa_exchange_rxns_name, 0, 'l');
        end
        
        % add the demand reaction of aa
        j_model = addDemandReaction(j_model, i_aa_met);
        
        % change objective function
        j_model = changeObjective(j_model, i_aa_demand_rxns_name);
        
        % maximize the obj
        j_sol = optimizeCbModel(j_model);
        
        aa_production(i, j) = j_sol.f;
        
    end
end

save('aa_production.mat', 'aa_production')
save aa_id;
save aa_name;

%% Add Genome annotation(assigned via KBase Interface) and bioservices. Updating genome annotation, too.
load('52GenomeFeatures')
    
    for i=1:length(model)
        for j=2:(length(model(i).genes)-1)
            model(i).genes{j}=['kb|' model(i).genes{j}];
        end
        model(i).genes(end)=[];
        model(i).genes(1)=[];
    end

    genesNewE={};


    for j=1:length(model)
        sciName=data(j).tax.scientific_name;
        disp(['Updating annotation for ' sciName '.']);

        fieldn=fieldnames(data(j).gene);
        genes=cell(0);
        for i=1:length(fieldn)
            tmp=getfield(getfield(data(j).gene,fieldn{i}),'aliases');
            if(~isstruct(tmp))
                if(~isempty(tmp{1}))
                    genes{end+1}=tmp;
                end
            end
        end
        	genes=genes';
        try
            genesNewE{end+1}=findMapping(genes,'UniProtKB AC',sciName);
        catch e
            disp(e)
        end
    end
		
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
