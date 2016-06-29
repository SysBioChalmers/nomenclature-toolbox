function [ modelSeedKEGG ] = loadmodelSeedKEGG( filename )
% loadmodelSeedKEGG
%   Loads Flatfile downloaded from
%   https://github.com/ModelSEED/ModelSEEDDatabase/blob/master/Aliases/KEGG.aliases
%   
%   that contains the list of:
%   standardised modelSEED metabolite & reaction names and their respective
%   KEGG Identifiers.
%   
%   Returns an(mx3) cell structure including:
%       a.KEGG Identifiers  in the first cell array
%       b.modelSEED reaction or metabolite aliases in the second cell array that
%       correspond to the KEGG in the first one
%       c.modelSEED reaction or metabolite aliases in the third cell arrays that
%       correspond to the KEGG in the first one for plant default
%       organisms.
%   
%   Usage: modelSeedKEGG = loadmodelSeedKEGG('filename.txt')
%
%   Dimitra Lappa, 2016-05-20



        %Reading the file modelSeedMetIdDeltaG 
        A = importdata('modelseedKEGG.txt');
            for i=1:length(A)
                    name = char(A{i,1});
                    str= '\t';
                    [C,matches] = strsplit(name,'\t');
                    for j=1:length(C)
                        modelSeedKEGG{i,j}= char(C(j));
                    end
            end
    
        %Printing Loading Message
        fprintf('Loading Flatfile for corresponding annotation from ModelSEED metabolite and reaction names to KEGG Identifiers \n \n');
    
   
end