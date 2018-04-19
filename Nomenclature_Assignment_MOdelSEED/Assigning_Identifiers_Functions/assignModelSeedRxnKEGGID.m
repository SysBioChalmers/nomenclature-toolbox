function [ rxnKEGGID ] = assignModelSeedRxnKEGGID( reactionIdArray, modelSeedKEGG)
%assignModelSeedRxnKEGGID
%   Creating cell arrays and structures for
%   "assigning":
%       a.modelSEED reaction names into their KEGG Identifiers
%   
%   Takes as input two  (mxn) cell arrays that contain:
%       a.reaction  names and their ModelSEED identifiers
%       b.ModelSeed KEGG reaction and ids cell array 
%   Returns 1 (nx1) cell array structure that represents the KEGG Ids.
%       
%   
%   Usage: rxnKEGGID = assignModelSeedRxnKEGGID( reactionIdArray, modelSeedKEGG)
%   Dimitra Lappa, 2016-05-10




       
        for i=1:length(reactionIdArray)
            index = find(ismember([modelSeedKEGG(:,2)], reactionIdArray{i,1}));
            if ~isempty(index)
                for k=1:length(index)
                    rxnKEGG{1,k} = modelSeedKEGG{index(k), 1};
                end
            else
                rxnKEGG = '';
            end
            rxnKEGGID{i,1}=rxnKEGG;
        end
    
        
        
        
        
end



