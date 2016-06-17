function [ metaCycMetNameSynonyms ] = loadmetaCycMetNameSynonyms( filename )
% loadmetaCycMetNameSynonyms
%   Loads Flatfile downloaded from www.metacyc.org that contains the list of:
%   standardised MetaCyc metabolite names and their respective synonyms.
%   
%   Returns an(mx2) cell structure including:
%       a.MetaCyc metabolite names in the first cell array
%       b.MetaCyc metabolitesynonyms in the following cell arrays that correspond to the MetaCyc metabolite names
%       in the first one
%   
%   Usage: metaCycMetNameSynonyms = loadmetaCycMetNameSynonyms('filename.txt')
%
%   Dimitra Lappa, 2016-05-30


    
    %Reading the file
    A= importdata('metaCycMetNameSynonymsMapping.txt');
    A= strrep(A, '"', '');
    A= strrep(A, ';', '  ');
    for i=1:length(A)
            metabolite = char(A{i,1});
            str= ' ';
            [C,matches] = strsplit(metabolite,'\t');
            for j=1:length(C)
                C(j)=strrep(C(j), '\t', ' ');
                metaCycMetNameSynonyms{i,j}= (C(j));
        
            end
    end
    
    
    %Creating the correct Naming in the first column
    fprintf('Loading Flatfile for corresponding annotation from MetaCyc metabolite names to their synonyms \n \n')


end

