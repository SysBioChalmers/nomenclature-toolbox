function [ ChEBIInChI ] = loadChEBI2InChI( filename )
% loadChEBI2InChI
%   Loads Flatfile downloaded from www.chebi.org, [ftp://ftp.ebi.ac.uk/pub/databases/chebi/Flat_file_tab_delimited/]
%   that contains the list of:
%   standardised ChEBI ids and their respective InChI Identifiers.
%   
%   Returns an(1x2) cell structure including:
%       a.ChEBI ids in the first cell array
%       b.InChI ids in the second cell array that correspond to the ChEBI
%       ids in the first one
%   
%   Usage: ChEBIInChI = loadChEBI2InChI('filename.txt')
%
%   Dimitra Lappa, 2015-11-20


    %Reading the file
    fileID = fopen('chebiIdInchi.tsv');
    ChEBIInChI = textscan(fileID,'%s %s');
    fclose(fileID);

    %Creating the correct ChEBI Identifier in the first column
    fprintf('Loading Flatfile for corresponding annotation from ChEBI ids to Inchi ids \n \n');
    for n =2:length(ChEBIInChI{1, 1})
            ChEBIInChI{1,1}{n,1}= strcat('CHEBI:', ChEBIInChI{1,1}{n,1} );
    end
   
end

