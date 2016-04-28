function [ modelSeedMetNameSynonyms ] = loadmodelSeedMetNameSynonyms( filename )
% loadmodelSeedMetNameSynonyms
%   Loads Flatfile downloaded from www.modelSEED.org
%   that contains the list of:
%   standardised modelSEED metabolite names and their respective synonyms.
%   
%   Returns an(mxn) cell structure including:
%       a.modelSEED metabolite names in the first cell array
%       b.modelSEED metabolitesynonyms in the following cell arrays that correspond to the modelSEED metabolite names
%       in the first one
%   
%   Usage: modelSeedMetNameSynonyms = loadmodelSeedMetNameFormula('filename.txt')
%
%   Dimitra Lappa, 2016-03-30


    %Reading the file
    A= importdata('modelSeedSynonyms.txt');
    for i=1:length(A)
            metabolite = char(A{i,1});
            str= '|';
            [C,matches] = strsplit(metabolite,'|');
            for j=1:length(C)
                modelSeedMetNameSynonyms{i,j}= char(C(j));
            end
    end
    
    %Creating the correct Naming in the first column
    fprintf('Loading Flatfile for corresponding annotation from ModelSEED metabolite names to their synonyms \n \n')


end

