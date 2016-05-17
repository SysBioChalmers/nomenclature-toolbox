function [ SEEDChemicalFormula ] = loadSEED2ChemicalFormula( filename )
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