clear
tic
% Loading model from Various formats 
HMRmat=load('HMRdatabase2_00.mat');

% Adding a chebi field into the gem model's matlab structure
HMRmat.ihuman.chebis=cell(6006,1);

% Converting model's metabolites and reactions identifiers according ti
% SysBio standars
HMRmat.ihuman = Convert_ids_SysBio_standars(HMRmat.ihuman);

% Converting Model Matlab Cell structures  for metabolites' feature to
% tables
mets_id = cell2table(HMRmat.ihuman.mets);
mets_id.Properties.VariableNames{'Var1'} = 'metabolite_id';
met_id = table2array(mets_id);

mets_formulas = cell2table(HMRmat.ihuman.metFormulas);
mets_formulas.Properties.VariableNames{'Var1'} = 'metabolite_formula';
met_formula = table2array(mets_formulas);

mets_names = cell2table(HMRmat.ihuman.metNames);
mets_names.Properties.VariableNames{'Var1'} = 'metabolite_name';
met_name = table2array(mets_names);

rxns_id = cell2table(HMRmat.ihuman.rxns);
rxns_id.Properties.VariableNames{'Var1'} = 'reaction_id';
rxn_id = table2array(rxns_id);

% Extracting metabolites id and name to flat files
metabolites = [mets_id, mets_names, mets_formulas];
writetable(metabolites, 'mets.txt', 'Delimiter', '\t');


% Starting Assigning Identifiers Process

%Loading Flatfiles with standardised CHEBI and INCHI Identifiers and create cells with correspondance
ChEBI_Metabolite_Names = loadChEBI2MetNames('compounds.tsv');
ChEBI_InChI = loadChEBI2InChI('chebiId_inchi.tsv');
ChEBI_Chemical_Formula = loadChEBI2ChemicalFormula('chemical_data.tsv');

% Create dictionaries
[Metabolite_Names_2_ChEBI_Map, ChEbI_2_InChI_Map, Chemical_Formula_2_ChEbI_Map] = Create_Dictionaries(ChEBI_Metabolite_Names, ChEBI_InChI, ChEBI_Chemical_Formula);

%Creating a log file to keep the Matlab Command Prompt output
fileID = fopen('log.txt', 'w');

starting_point=1;
%Loop through your metabolites and find annotation in Dictionary archives
for i=1:length(met_name)
    %Ask user for continuing process
    assigning = Continue_assign_ids_prompt_msg(starting_point);
    if assigning == false
        break
    end
    
    %Loading metabolites features into temporary variables
    name = met_name{i};, id = met_id{i};, formula = met_formula{i};
    if (strcmp(formula,''))
        formula = 'NO FORMULA';
    end
    
    %Initialising some variables and Printing in command prompt the current
    %information
    stored_chebi_3='';
    stored_chebi_2='';
    stored_inchi_3='';
    stored_inchi_2='';
    
    fprintf(fileID, '%s \t %s \t %s \n',id, name, formula);
    fprintf('%s \t %s \t %s \n',id, name, formula);
    fprintf('If this is your choice of annotation please press 1 \n \n');
    
    
    %If the name of the metabolite is standardised and agrees with official
    %ChEBI nomenclature
    if isKey(Metabolite_Names_2_ChEBI_Map, name)
        chebi = Metabolite_Names_2_ChEBI_Map(name);
        if isKey(ChEbI_2_InChI_Map, chebi)
            inchi = ChEbI_2_InChI_Map(chebi);
            cprintf('blue','%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
            fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
            fprintf('If this is your choice of annotation please press 2 \n \n');
            stored_chebi_2 = chebi;
            stored_inchi_2 = inchi;
        end
    end
    
    
    %If the name does not correspond there, perform a search in the ChEBI
    %Database file given Chemical formula
    if isKey(Chemical_Formula_2_ChEbI_Map, formula)
        chebi = Chemical_Formula_2_ChEbI_Map(formula);
        if isKey(ChEbI_2_InChI_Map, chebi)
            inchi = ChEbI_2_InChI_Map(chebi);
            fprintf(fileID, '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
            cprintf('magenta', '%s \t %s \t %s \t %s \n \n',id, name, chebi, inchi);
            fprintf('If this is your choice of annotation please press 3 \n \n');
            stored_chebi_3 = chebi;
            stored_inchi_3 = inchi;
        end
    end
    
    HMRmat.ihuman = Store_identifiers(HMRmat.ihuman, i,stored_chebi_2, stored_inchi_2, stored_chebi_3, stored_inchi_3);
    starting_point=i;
end
fclose(fileID);
%
%
toc
