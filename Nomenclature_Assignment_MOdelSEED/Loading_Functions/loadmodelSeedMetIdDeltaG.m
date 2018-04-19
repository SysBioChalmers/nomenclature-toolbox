function [ modelSeedMetIdDeltaG ] = loadmodelSeedMetIdDeltaG( filename )
% loadmodelSeedMetNameFormula
%   Loads Flatfile downloaded from www.modelSEED.org
%   that contains the list of:
%   standardised modelSEED metabolite names and their respective DeltaGs
%   and DeltaG Errors.
%   
%   Returns an(1x1) struct with two fields including:
%       1.Field 1 is data (nx2)double array) with:
%               a.numerical values for DeltaGs in the first column
%               b.numerical values for DeltaG Errors in the second column
%
%
%       2.Field 2 is a (nx3) cell array with:
%           a.modelSEED metabolite names in the first cell array
%           b.DeltaGs and  in the second cell array that correspond to the
%           modelSEED metabolite Ids
%           in the first one
%           c.DeltaG Errors for the respective metabolites
%   
%   Usage: modelSeedMetIdDeltaG = loadmodelSeedMetMetIdDeltaG('filename.txt')
%
%   Dimitra Lappa, 2016-06-02


    %Reading the file modelSeedMetIdDeltaG 
    modelSeedMetIdDeltaG = importdata('DeltaG.txt', '\t');
    modelSeedMetIdDeltaG.data = [0 0; modelSeedMetIdDeltaG.data] ;
    for i=2:length(modelSeedMetIdDeltaG.textdata)
            modelSeedMetIdDeltaG.textdata{i,2} = num2str(modelSeedMetIdDeltaG.data(i,1));
            modelSeedMetIdDeltaG.textdata{i,3} = num2str(modelSeedMetIdDeltaG.data(i,2));
    end
   
    
    %Creating the correct ChEBI Identifier in the first column
    fprintf('Loading Flatfile for corresponding annotation from ModelSEED metabolite names to DeltaGs and DeltaG Errors \n \n');
    
   
end