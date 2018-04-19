function [ deltaG ] = assignModelSeedDeltaG( metaboliteIdArray, modelSeedMetIdDeltaG)
%assignModelSeedDeltaG
%   Creating cell arrays and structures for
%   "assigning":
%       a.modelSEED metabolite names into their DeltaGs and DeltaG Errors
%   
%   Takes as input two  (mxn) cell arrays that contain:
%       a.metabolite names and their ModelSEED identifiers
%       b.ModelSeed id-DeltaG cell array that corresponds to the
%       mapping
%   Returns 1 (nx2) cell array structure that represents the metabolites
%   and their DeltaGs and DeltaG Errors
%       
%   
%   Usage: deltaG = assignModelSeedDeltaG( metaboliteIdArray, modelSeedMetIdDeltaG )
%
%   Dimitra Lappa, 2016-06-10

    for i=1:length(metaboliteIdArray)
            index = find(ismember([modelSeedMetIdDeltaG.textdata(:,1)], metaboliteIdArray{i,1}));
            if index ~=0
                DeltaG = modelSeedMetIdDeltaG.data(index, 1);
                DeltaGError = modelSeedMetIdDeltaG.data(index, 2);
            else
                DeltaG = 0;
                DeltaGError = 0;
            end
            deltaG{i,1}=DeltaG;
            deltaG{i,2}=DeltaGError;
    end
    
end


