function [ metFormula ] = assignModelSeedFormula( metaboliteIdArray, modelSeedMetNameFormula)
%assignModelSeedFormula
%   Creating cella arrays and structures for
%   "assigning":
%       a.modelSEED metabolite names into their chemical formulas
%   
%   Takes as input two  (mxn)cell arrays that contain:
%       a.metabolite names and their ModelSEED identifiers
%       b.ModelSeed id-name-formula cell array that corresponds to the
%       mapping
%   Returns 1 (1xn) cell array structure that represents these formulas.
%       
%   
%   Usage: metFormula = assignModelSeedFormula( metaboliteIdArray )
%
%   Dimitra Lappa, 2016-04-10

    % Create the dictionaries
    for i=1:length(metaboliteIdArray)
            index = find(ismember(modelSeedMetNameFormula{1, 1}, metaboliteIdArray{i,1}));
            if index ~=0
                formula = modelSeedMetNameFormula{1, 3}{index, 1};
            else
                formula = 'NO FORMULA';
            end
            metFormula{i,1}=formula;
    end






end

