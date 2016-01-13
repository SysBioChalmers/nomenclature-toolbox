function [ ChEBI_Metabolite_Names ] = loadChEBI2MetNames( filename )
% loadChEBI2MetNames
%   Loads Flatfile downloaded from www.chebi.org, [ftp://ftp.ebi.ac.uk/pub/databases/chebi/Flat_file_tab_delimited/]
%   that contains the list of:
%   standardised Metabolite Names and their respective ChEBI Identifiers.
%   
%   Returns an(1x2) cell structure including:
%       a.ChEBI ids in the first cell array
%       b.Metabolite Names in the second cell array that correspond to the ChEBI
%       ids in the first one
%   
%   Usage: ChEBI_Metabolite_Names = loadChEBI2MetNames('filename.txt')
%
%   Dimitra Lappa, 2015-11-20   

     fprintf('Loading Flatfile for corresponding annotation from ChEBI ids to matabolite names \n \n');
     Chebi_Metabolite_Names = importdata('compounds.tsv', '\t');
     ChEBI_Metabolite_Names = {Chebi_Metabolite_Names.textdata{:,3}}';
     ChEBI_Metabolite_Names = {ChEBI_Metabolite_Names, {Chebi_Metabolite_Names.textdata{:,6}}'};
     
end

