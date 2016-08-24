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