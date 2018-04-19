function [ modelSeedMetNameFormula ] = loadmodelSeedMetNameFormula( filename )
% loadmodelSeedMetNameFormula
%   Loads Flatfile downloaded from www.modelSEED.org
%   that contains the list of:
%   standardised modelSEED metabolite names and their respective Chemical Formulas.
%   
%   Returns an(1x2) cell structure including:
%       a.modelSEED metabolite names in the first cell array
%       b.Chemical Formulas in the second cell array that correspond to the modelSEED metabolite names
%       in the first one
%   
%   Usage: modelSeedMetNameFormula = loadmodelSeedMetNameFormula('filename.txt')
%
%   Dimitra Lappa, 2016-03-30


    %Reading the file
    A= importdata('modelSEEDcompounds.txt', '\t');
    for i=2:length(A)
            metabolite = char(A{i,1});
            str= '\t';
            [C,matches] = strsplit(metabolite,'\t');
            modelSeedMetNameFormula{1,1}{i,1} = char(C(1));
            modelSeedMetNameFormula{1,2}{i,1} = char(C(2));
            modelSeedMetNameFormula{1,3}{i,1} = char(C(3));
            
    end
    
    %Creating the correct ChEBI Identifier in the first column
    fprintf('Loading Flatfile for corresponding annotation from ModelSEED metabolite names to Chemical Formulas ids \n \n');
    modelSeedMetNameFormula{1,1}{1,1} = 'METABOLITE ID';
    modelSeedMetNameFormula{1,2}{1,1} = 'METABOLITE NAME';
    modelSeedMetNameFormula{1,3}{1,1} = 'METABOLITE FORMULA';
   
end