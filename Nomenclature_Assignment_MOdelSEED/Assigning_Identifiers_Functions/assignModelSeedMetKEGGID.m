function [ metKEGGID ] = assignModelSeedMetKEGGID( metaboliteIdArray, modelSeedKEGG)
%assignModelSeedMetKEGGID
%   Creating cell arrays and structures for
%   "assigning":
%       a.modelSEED metabolite names into their KEGG Identifiers
%   
%   Takes as input two  (mxn) cell arrays that contain:
%       a.metabolite names and their ModelSEED identifiers
%       b.ModelSeed KEGG metabolite and ids cell array 
%   Returns 1 (nx1) cell array structure that represents the KEGG Ids.
%       
%   
%   Usage: metKEGGID = assignModelSeedMetKEGGID( metaboliteIdArray, modelSeedKEGG)
%   Dimitra Lappa, 2016-05-10




       
        for i=1:length(metaboliteIdArray)
            index = find(ismember([modelSeedKEGG(:,2)], metaboliteIdArray{i,1}));
            if ~isempty(index)
                for k=1:length(index)
                    metKEGG{1,k} = modelSeedKEGG{index(k), 1};
                end
            else
                metKEGG = '';
            end
            metKEGGID{i,1}=metKEGG;
        end
    
        
        
        
        
end

