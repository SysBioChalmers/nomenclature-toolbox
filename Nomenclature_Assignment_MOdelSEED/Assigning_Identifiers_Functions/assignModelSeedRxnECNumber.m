function [ rxnECNumbers ] = assignModelSeedRxnECNumber( reactionIdArray, modelSeedECNumbers)
%assignModelSeedRxnECNumber
%   Creating cell arrays and structures for
%   "assigning":
%       a.modelSEED metabolite names into their Enzyme Commission Numbers
%   
%   Takes as input two  (mxn) cell arrays that contain:
%       a.reaction  names and their ModelSEED identifiers
%       b.ModelSeed EC Numbers and ids cell array 
%   Returns 1 (nx1) cell array structure that represents the KEGG Ids.
%       
%   
%   Usage: rxnECNumbers = assignModelSeedRxnECNumber( metaboliteIdArray, modelSeedECNumbers)
%   Dimitra Lappa, 2016-05-10




        
        for i=1:length(reactionIdArray)
            index = find(ismember([modelSeedECNumbers(:,2)], reactionIdArray{i,1}));
            if ~isempty(index)
                for k=1:length(index)
                    rxnEC{1,k} = modelSeedECNumbers{index(k), 1};
                end
            else
                rxnEC = '';
            end
            rxnECNumbers{i,1}=rxnEC;
        end
    
        
        
        
        
end

