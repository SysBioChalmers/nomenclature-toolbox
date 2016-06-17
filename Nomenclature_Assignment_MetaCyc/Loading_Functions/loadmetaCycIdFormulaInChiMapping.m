function [ metaCycIdFormulaInChiMapping ] = loadmetaCycIdFormulaInChiMapping( filename )
% loadmetaCycIdFormulaInChiMappings
%   Loads Flatfile downloaded from www.metacyc.org that contains the list of:
%   standardised MetaCyc metabolite names and their respective chemical formulas and InChi Strings.
%   
%   Returns an(1x3) cell structure including:
%       a.MetaCyc metabolite ids in the first cell array
%       b.MetaCyc chemical formulas in the following cell arrays that correspond to the MetaCyc metabolite names
%       in the first one
%       c.InChI strings for MetaCyc Metabolites
%   
%   Usage: metaCycIdFormulaInChiMapping = loadmetaCycIdFormulaInChiMapping('filename.txt')
%
%   Dimitra Lappa, 2016-05-30


    


    %Reading the file
    fileID = fopen('metaCycIdFormulaInChiMapping.txt');
    A = textscan(fileID,'%s %s %s %s');
    fclose(fileID);
    %removing quotes from characters
    A{1, 2}=strrep(A{1, 2}, '"', '');
    A{1, 3}=strrep(A{1, 3}, '"', '');
    %Creating the proper Cell Array for the mapping
    fprintf('Loading Flatfile for corresponding annotation from MetaCyc metabolite Ids to their chemical formulas and InChI identifiers \n \n')
    metaCycIdFormulaInChiMapping = {A{1, 1},A{1, 2}, A{1, 3}};
    

end

