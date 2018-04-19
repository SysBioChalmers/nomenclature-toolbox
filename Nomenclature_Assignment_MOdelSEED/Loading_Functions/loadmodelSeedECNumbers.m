function [ modelSeedECNumbers ] = loadmodelSeedECNumbers( filename )
% loadmodelSeedECNumbers
%   Loads Flatfile downloaded from
%   https://github.com/ModelSEED/ModelSEEDDatabase/tree/master/Aliases
%   
%   that contains the list of:
%   standardised modelSEED reaction names and their respective Enzyme Comission Numberssynonyms.
%   
%   Returns an(mx2) cell structure including:
%       a.Enzyme Class or Enzyme Comission Numbers in the first cell array
%       b.modelSEED reaction aliases in the second cell array that
%       correspond to the Enzyme Comission Numbers in the first one
%       
%   
%   Usage: modelSeedECNumbers = loadmodelSeedECNumbers('filename.txt')
%
%   Dimitra Lappa, 2016-05-13


    %Reading the file
    A = importdata('modelseedECNumbers.txt');
    for i=1:length(A)
            name = char(A{i,1});
            str= '\t';
            [C,matches] = strsplit(name,'\t');
            for j=1:length(C)
                modelSeedECNumbers{i,j}= char(C(j));
            end
    end

    
    
     %Printing Loading Message
    fprintf('Loading Flatfile for corresponding annotation from ModelSEED reaction names to Enzyme Commission Numbers \n \n');
    
    
    
end