function [ chEBIMetaboliteNames ] = loadChEBI2MetNames( filename )
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
%   Usage: chEBIMetaboliteNames = loadChEBI2MetNames('filename.txt')
%
%   Dimitra Lappa, 2015-11-20   

     fprintf('Loading Flatfile for corresponding annotation from ChEBI ids to matabolite names \n \n');
     ChebiMetaboliteNames = importdata('compounds.tsv', '\t');
     chEBIMetaboliteNames = {ChebiMetaboliteNames.textdata{:,3}}';
     chEBIMetaboliteNames = {chEBIMetaboliteNames, {ChebiMetaboliteNames.textdata{:,6}}'};
     
end

