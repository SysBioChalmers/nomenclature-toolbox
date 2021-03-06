function [ ChEBIChemicalFormula ] = loadChEBI2ChemicalFormula( filename )
% loadChEBI2ChemicalFormula
%   Loads Flatfile downloaded from www.chebi.org, [ftp://ftp.ebi.ac.uk/pub/databases/chebi/Flat_file_tab_delimited/]
%   that contains the list of:
%   standardised ChEBI and their respective InChI Identifiers.
%   
%   Returns an(1x2) cell structure including:
%       a.ChEBI ids in the first cell array
%       b.Chemical Formulas of metabolites in the second cell array that correspond to the ChEBI
%       ids in the first one
%   
%   Usage: ChEBIChemicalFormula = loadChEBI2ChemicalFormula('filename.txt')
%
%   Dimitra Lappa, 2015-11-25


    %Reading the file
    fileID = fopen('chemicalData.tsv');
    CHEBIChemicalFormula = textscan(fileID,'%s %s %s %s %s %s %s');
    fclose(fileID);
    
    %Loading the neccessary data
    ChEBIChemicalFormula = CHEBIChemicalFormula{:,1};
    %Correcting the files problematic format in column separation (not a standard delimiter-inconsistency in number of columns)-loading data in a temporary structure 
    temp_list = {};
    temp_list{1,1}= 'FORMULA';
    
    for n =2:(length(CHEBIChemicalFormula{1, 1})-1)
        if (strcmp(CHEBIChemicalFormula{1,3}{n,1},'KEGG'))
            temp_list{n,1} = CHEBIChemicalFormula{1,6}{n,1};
        elseif (strcmp(CHEBIChemicalFormula{1,3}{n,1},'NIST'))
            temp_list{n,1} = CHEBIChemicalFormula{1,7}{n,1};
        else
            temp_list{n,1} = CHEBIChemicalFormula{1,5}{n,1};
        end
    end
    temp_list{length(CHEBIChemicalFormula{1, 1}), 1} = '.';
    ChEBIChemicalFormula = {ChEBIChemicalFormula, temp_list};
   
    %Creating the correct ChEBI Identifier in the first column
    fprintf('Loading Flatfile for corresponding annotation from ChEBI ids to Chemical Formulas \n \n');
    for n =2:length(ChEBIChemicalFormula{1, 1})
            ChEBIChemicalFormula{1,1}{n,1}= strcat('CHEBI:', ChEBIChemicalFormula{1,1}{n,1} );
    end
        
end

